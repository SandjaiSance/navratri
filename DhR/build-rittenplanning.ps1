$ErrorActionPreference = 'Stop'

$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$analysisYears = 2021..2025
$outputYears = 2019..2025
$culture = [System.Globalization.CultureInfo]::InvariantCulture
$nlCulture = [System.Globalization.CultureInfo]::GetCultureInfo('nl-NL')
$maxHoursPerDay = 6
$hourRate = [decimal]32.5
$historicalReferenceYears = 2022..2024
$kmPerHourPattern = @(23, 24, 25, 26, 27, 28, 29, 30, 31)

function Get-AnalysisPath {
    param(
        [int]$Year
    )

    return (Join-Path $baseDir ("belasting {0} analyse.xlsx" -f $Year))
}

function Get-OutputPath {
    param(
        [int]$Year
    )

    return (Join-Path $baseDir ("Admin_Ritten_{0}.xlsx" -f $Year))
}

function Get-DecimalFromCellText {
    param(
        [string]$Text
    )

    $value = [decimal]0
    [decimal]::TryParse(($Text -replace ',', ''), [System.Globalization.NumberStyles]::Any, $culture, [ref]$value) | Out-Null
    return $value
}

function Get-EasterSunday {
    param(
        [int]$Year
    )

    $a = $Year % 19
    $b = [math]::Floor($Year / 100)
    $c = $Year % 100
    $d = [math]::Floor($b / 4)
    $e = $b % 4
    $f = [math]::Floor(($b + 8) / 25)
    $g = [math]::Floor(($b - $f + 1) / 3)
    $h = (19 * $a + $b - $d - $g + 15) % 30
    $i = [math]::Floor($c / 4)
    $k = $c % 4
    $l = (32 + 2 * $e + 2 * $i - $h - $k) % 7
    $m = [math]::Floor(($a + 11 * $h + 22 * $l) / 451)
    $month = [math]::Floor(($h + $l - 7 * $m + 114) / 31)
    $day = (($h + $l - 7 * $m + 114) % 31) + 1

    return [datetime]::new($Year, $month, $day)
}

function Get-DutchHolidayMap {
    param(
        [int[]]$Years
    )

    $holidayMap = @{}

    foreach ($year in $Years | Sort-Object -Unique) {
        $easterSunday = Get-EasterSunday -Year $year
        $dates = @(
            [datetime]::new($year, 1, 1),
            $easterSunday.AddDays(1),
            [datetime]::new($year, 4, 27),
            $easterSunday.AddDays(39),
            $easterSunday.AddDays(50),
            [datetime]::new($year, 12, 25),
            [datetime]::new($year, 12, 26)
        )

        if (($year % 5) -eq 0) {
            $dates += [datetime]::new($year, 5, 5)
        }

        foreach ($date in $dates) {
            $holidayMap[$date.ToString('yyyy-MM-dd')] = $true
        }
    }

    return $holidayMap
}

function Test-PlanningDate {
    param(
        [datetime]$Date,
        [hashtable]$HolidayMap
    )

    if ($Date.DayOfWeek -eq [DayOfWeek]::Sunday) {
        return $false
    }

    return -not $HolidayMap.ContainsKey($Date.ToString('yyyy-MM-dd'))
}

function Get-GroupedIncomeDaysFromWorksheet {
    param(
        $Worksheet,
        [int]$SourceYear,
        [ref]$KmPatternIndex
    )

    $rows = @()
    $usedRange = $Worksheet.UsedRange
    $maxRow = $usedRange.Rows.Count
    $dailyAmounts = @{}

    for ($row = 2; $row -le $maxRow; $row++) {
        $category = [string]$Worksheet.Cells.Item($row, 8).Text
        if ($category -ne 'Inkomsten - Rijschool') {
            continue
        }

        $dateText = [string]$Worksheet.Cells.Item($row, 1).Text
        if ([string]::IsNullOrWhiteSpace($dateText)) {
            continue
        }

        $amount = Get-DecimalFromCellText ([string]$Worksheet.Cells.Item($row, 10).Text)
        
        # Try to parse date with multiple format attempts
        $transactionDate = $null
        $dateFormats = @('dd/MM/yyyy', 'dd-MM-yyyy', 'd/M/yyyy', 'MM/dd/yyyy', 'yyyy-MM-dd')
        foreach ($format in $dateFormats) {
            if ([datetime]::TryParseExact($dateText, $format, $culture, [System.Globalization.DateTimeStyles]::None, [ref]$transactionDate)) {
                break
            }
        }
        
        if ($transactionDate -eq $null) {
            Write-Host "WARNING: Could not parse date '$dateText' at row $row"
            continue
        }
        
        $key = $transactionDate.ToString('yyyy-MM-dd')

        if (-not $dailyAmounts.ContainsKey($key)) {
            $dailyAmounts[$key] = [decimal]0
        }

        $dailyAmounts[$key] = [decimal]$dailyAmounts[$key] + $amount
    }

    foreach ($entry in ($dailyAmounts.GetEnumerator() | Sort-Object Name)) {
        $transactionDate = [datetime]::ParseExact($entry.Name, 'yyyy-MM-dd', $culture)
        $amount = [decimal]$entry.Value
        $hoursRaw = $amount / $hourRate

        if ($hoursRaw -le 1) {
            continue
        }

        $hoursRounded = [int][math]::Round([double]$hoursRaw, 0, [System.MidpointRounding]::AwayFromZero)
        if ($hoursRounded -le 0) {
            continue
        }

        $patternValue = [decimal]$kmPerHourPattern[$KmPatternIndex.Value % $kmPerHourPattern.Count]
        $KmPatternIndex.Value++
        $weeksBack = [int][math]::Min(20, [math]::Max(15, $hoursRounded))

        $rows += [pscustomobject]@{
            SourceYear = $SourceYear
            TransactionDate = $transactionDate
            Amount = [math]::Round([double]$amount, 2, [System.MidpointRounding]::AwayFromZero)
            Hours = $hoursRounded
            KmPerHour = $patternValue
            Kilometers = [decimal]$hoursRounded * $patternValue
            WeeksBack = $weeksBack
        }
    }

    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($usedRange)
    return $rows | Sort-Object TransactionDate, Amount
}

function Get-AllSourceRows {
    param(
        $Excel,
        [int[]]$Years
    )

    $allRows = @()
    $kmPatternIndex = 0

    foreach ($year in $Years) {
        $path = Get-AnalysisPath -Year $year
        if (-not (Test-Path $path)) {
            throw ("Bronbestand ontbreekt: {0}" -f $path)
        }

        $workbook = $null
        $worksheet = $null

        try {
            $workbook = $Excel.Workbooks.Open($path, $null, $true)
            $worksheet = $workbook.Worksheets.Item('Transacties')
            $yearRows = Get-GroupedIncomeDaysFromWorksheet -Worksheet $worksheet -SourceYear $year -KmPatternIndex ([ref]$kmPatternIndex)
            $allRows += $yearRows
            $workbook.Close($false)
        }
        finally {
            if ($worksheet) {
                [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($worksheet)
            }
            if ($workbook) {
                [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
            }
        }
    }

    return $allRows | Sort-Object TransactionDate, SourceYear, Amount
}

function Get-ProfitLossData {
    param(
        $Excel,
        [int]$Year
    )

    $path = Get-AnalysisPath -Year $Year
    if (-not (Test-Path $path)) {
        return $null
    }

    $workbook = $null
    $worksheet = $null

    try {
        $workbook = $Excel.Workbooks.Open($path, $null, $true)
        $worksheet = $workbook.Worksheets.Item('Transacties')
        $usedRange = $worksheet.UsedRange
        $maxRow = $usedRange.Rows.Count
        $totals = @{}

        for ($row = 2; $row -le $maxRow; $row++) {
            $category = [string]$worksheet.Cells.Item($row, 8).Text
            if ([string]::IsNullOrWhiteSpace($category)) {
                continue
            }

            $amount = Get-DecimalFromCellText ([string]$worksheet.Cells.Item($row, 10).Text)
            if (-not $totals.ContainsKey($category)) {
                $totals[$category] = [decimal]0
            }

            $totals[$category] = [decimal]$totals[$category] + $amount
        }

        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($usedRange)
        $workbook.Close($false)

        $income = [decimal]($totals['Inkomsten - Rijschool'])
        $costRijschool = [decimal]($totals['Kosten - Rijschool'])
        $costMobile = [math]::Round([double](([decimal]($totals['Kosten - Internet/Mobiel'])) * 0.5), 2, [System.MidpointRounding]::AwayFromZero)
        $costMobile = [decimal]$costMobile

        return [pscustomobject]@{
            IncomeRijschool = $income
            CostRijschool = $costRijschool
            CostInternetMobiel = $costMobile
        }
    }
    finally {
        if ($worksheet) {
            [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($worksheet)
        }
        if ($workbook) {
            [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
        }
    }
}

function Get-CandidateDates {
    param(
        [datetime]$TransactionDate,
        [int]$WeeksBack,
        [hashtable]$HolidayMap
    )

    $startDate = $TransactionDate.AddDays(-7 * $WeeksBack)
    $endDate = $TransactionDate.AddDays(-1)
    $dates = @()
    $currentDate = $startDate

    while ($currentDate -le $endDate) {
        if (Test-PlanningDate -Date $currentDate -HolidayMap $HolidayMap) {
            $dates += $currentDate
        }

        $currentDate = $currentDate.AddDays(1)
    }

    return $dates
}

function Find-AvailableDateIndex {
    param(
        [datetime[]]$CandidateDates,
        [int]$DesiredIndex,
        [hashtable]$DailyLoadMap
    )

    for ($offset = 0; $offset -lt $CandidateDates.Count; $offset++) {
        $indices = @($DesiredIndex - $offset)
        if ($offset -gt 0) {
            $indices += ($DesiredIndex + $offset)
        }

        foreach ($index in $indices) {
            if ($index -lt 0 -or $index -ge $CandidateDates.Count) {
                continue
            }

            $key = $CandidateDates[$index].ToString('yyyy-MM-dd')
            $currentLoad = 0
            if ($DailyLoadMap.ContainsKey($key)) {
                $currentLoad = [int]$DailyLoadMap[$key]
            }

            if ($currentLoad -lt $maxHoursPerDay) {
                return $index
            }
        }
    }

    throw 'Geen beschikbare plandatum gevonden binnen het venster.'
}

function New-PlanningRows {
    param(
        [object[]]$SourceRows,
        [hashtable]$HolidayMap
    )

    $dailyLoadMap = @{}
    $planningRows = @()

    foreach ($source in $SourceRows) {
        $candidateDates = Get-CandidateDates -TransactionDate $source.TransactionDate -WeeksBack $source.WeeksBack -HolidayMap $HolidayMap

        if ($candidateDates.Count -eq 0) {
            throw ('Geen plandata gevonden voor transactie op {0:dd/MM/yyyy}.' -f $source.TransactionDate)
        }

        $allocatedDates = New-Object System.Collections.Generic.List[datetime]

        for ($hourIndex = 0; $hourIndex -lt $source.Hours; $hourIndex++) {
            $desiredIndex = [int][math]::Floor((($hourIndex + 0.5) * $candidateDates.Count) / $source.Hours)
            if ($desiredIndex -ge $candidateDates.Count) {
                $desiredIndex = $candidateDates.Count - 1
            }

            $selectedIndex = Find-AvailableDateIndex -CandidateDates $candidateDates -DesiredIndex $desiredIndex -DailyLoadMap $dailyLoadMap
            $selectedDate = $candidateDates[$selectedIndex]
            $key = $selectedDate.ToString('yyyy-MM-dd')

            if (-not $dailyLoadMap.ContainsKey($key)) {
                $dailyLoadMap[$key] = 0
            }

            $dailyLoadMap[$key] = [int]$dailyLoadMap[$key] + 1
            $allocatedDates.Add($selectedDate)
        }

        $groupedDates = $allocatedDates |
            Group-Object { $_.ToString('yyyy-MM-dd') } |
            Sort-Object Name

        foreach ($group in $groupedDates) {
            $plannedDate = [datetime]::ParseExact($group.Name, 'yyyy-MM-dd', $culture)
            $plannedHours = [int]$group.Count

            $planningRows += [pscustomobject]@{
                PlanningDate = $plannedDate
                TransactionDate = $source.TransactionDate
                SourceYear = $source.SourceYear
                Hours = $plannedHours
                KmPerHour = $source.KmPerHour
                Kilometers = [decimal]$plannedHours * $source.KmPerHour
            }
        }
    }

    return $planningRows | Sort-Object PlanningDate, TransactionDate, SourceYear
}

function Group-PlanningRowsPerDay {
    param(
        [object[]]$Rows
    )

    $groupedRows = @()
    $dailyGroups = $Rows |
        Group-Object { $_.PlanningDate.ToString('yyyy-MM-dd') } |
        Sort-Object Name

    foreach ($group in $dailyGroups) {
        $planningDate = [datetime]::ParseExact($group.Name, 'yyyy-MM-dd', $culture)
        $hours = [int](($group.Group | Measure-Object Hours -Sum).Sum)
        $kilometers = [decimal](($group.Group | Measure-Object Kilometers -Sum).Sum)
        $kmPerHour = if ($hours -gt 0) {
            [math]::Round([double]($kilometers / $hours), 2, [System.MidpointRounding]::AwayFromZero)
        }
        else {
            0
        }

        $groupedRows += [pscustomobject]@{
            PlanningDate = $planningDate
            Hours = $hours
            KmPerHour = [decimal]$kmPerHour
            Kilometers = $kilometers
        }
    }

    return $groupedRows
}

function Find-HistoricalPlanningDate {
    param(
        [datetime]$PreferredDate,
        [hashtable]$HolidayMap,
        [hashtable]$DailyLoadMap,
        [int]$Hours,
        [int]$TargetYear
    )

    for ($offset = 0; $offset -le 60; $offset++) {
        $candidateOffsets = if ($offset -eq 0) { @(0) } else { @(-$offset, $offset) }

        foreach ($candidateOffset in $candidateOffsets) {
            $candidateDate = $PreferredDate.AddDays($candidateOffset)
            if ($candidateDate.Year -ne $TargetYear) {
                continue
            }

            if (-not (Test-PlanningDate -Date $candidateDate -HolidayMap $HolidayMap)) {
                continue
            }

            $key = $candidateDate.ToString('yyyy-MM-dd')
            $currentLoad = 0
            if ($DailyLoadMap.ContainsKey($key)) {
                $currentLoad = [int]$DailyLoadMap[$key]
            }

            if (($currentLoad + $Hours) -le $maxHoursPerDay) {
                return $candidateDate
            }
        }
    }

    throw ('Geen historische plandatum gevonden voor {0:dd/MM/yyyy} in {1}.' -f $PreferredDate, $TargetYear)
}

function New-HistoricalPlanningRows {
    param(
        [object[]]$TemplateRows,
        [int]$TemplateYear,
        [int]$TargetYear,
        [hashtable]$HolidayMap
    )

    $dailyLoadMap = @{}
    $historicalRows = @()
    $yearOffset = $TargetYear - $TemplateYear

    foreach ($row in ($TemplateRows | Sort-Object PlanningDate)) {
        $preferredDate = $row.PlanningDate.AddYears($yearOffset)
        $plannedDate = Find-HistoricalPlanningDate -PreferredDate $preferredDate -HolidayMap $HolidayMap -DailyLoadMap $dailyLoadMap -Hours $row.Hours -TargetYear $TargetYear
        $key = $plannedDate.ToString('yyyy-MM-dd')

        if (-not $dailyLoadMap.ContainsKey($key)) {
            $dailyLoadMap[$key] = 0
        }

        $dailyLoadMap[$key] = [int]$dailyLoadMap[$key] + [int]$row.Hours

        $historicalRows += [pscustomobject]@{
            PlanningDate = $plannedDate
            Hours = [int]$row.Hours
            KmPerHour = [decimal]$row.KmPerHour
            Kilometers = [decimal]$row.Kilometers
        }
    }

    return $historicalRows | Sort-Object PlanningDate
}

function Write-SourceSheet {
    param(
        $Worksheet,
        [object[]]$Rows
    )

    $headers = @('Transactiedatum', 'Inkomsten rijschool', 'Uren afgerond', 'Km per uur', 'Kilometers', 'Weken terug')
    for ($column = 0; $column -lt $headers.Count; $column++) {
        $Worksheet.Cells.Item(1, $column + 1) = $headers[$column]
    }

    $rowIndex = 2
    foreach ($row in $Rows) {
        $Worksheet.Cells.Item($rowIndex, 1) = $row.TransactionDate.ToOADate()
        $Worksheet.Cells.Item($rowIndex, 2) = [double]$row.Amount
        $Worksheet.Cells.Item($rowIndex, 3) = [double]$row.Hours
        $Worksheet.Cells.Item($rowIndex, 4) = [double]$row.KmPerHour
        $Worksheet.Cells.Item($rowIndex, 5) = [double]$row.Kilometers
        $Worksheet.Cells.Item($rowIndex, 6) = [double]$row.WeeksBack
        $rowIndex++
    }

    $Worksheet.Cells.Item($rowIndex + 1, 1) = 'Totaal'
    $Worksheet.Cells.Item($rowIndex + 1, 2).Formula = ('=SUM(B2:B{0})' -f ($rowIndex - 1))
    $Worksheet.Cells.Item($rowIndex + 1, 3).Formula = ('=SUM(C2:C{0})' -f ($rowIndex - 1))
    $Worksheet.Cells.Item($rowIndex + 1, 5).Formula = ('=SUM(E2:E{0})' -f ($rowIndex - 1))

    $Worksheet.Range('A:A').NumberFormat = 'dd/mm/yyyy'
    $Worksheet.Range('B:F').NumberFormat = '0.00'
    $Worksheet.Range('A:F').Columns.AutoFit() | Out-Null
    $Worksheet.Columns.Item('A').ColumnWidth = 14
    $Worksheet.Range('A1:F1').Font.Bold = $true
}

function Write-PlanningSheet {
    param(
        $Worksheet,
        [object[]]$Rows,
        [int]$Year
    )

    $headers = @('Plandatum', 'Uren gepland', 'Km per uur', 'Kilometers')
    for ($column = 0; $column -lt $headers.Count; $column++) {
        $Worksheet.Cells.Item(1, $column + 1) = $headers[$column]
    }

    $rowIndex = 2
    foreach ($row in $Rows) {
        $Worksheet.Cells.Item($rowIndex, 1) = $row.PlanningDate.ToOADate()
        $Worksheet.Cells.Item($rowIndex, 2) = [double]$row.Hours
        $Worksheet.Cells.Item($rowIndex, 3) = [double]$row.KmPerHour
        $Worksheet.Cells.Item($rowIndex, 4) = [double]$row.Kilometers
        $rowIndex++
    }

    $Worksheet.Cells.Item($rowIndex + 1, 1) = 'Totaal'
    $Worksheet.Cells.Item($rowIndex + 1, 2).Formula = ('=SUM(B2:B{0})' -f ($rowIndex - 1))
    $Worksheet.Cells.Item($rowIndex + 1, 4).Formula = ('=SUM(D2:D{0})' -f ($rowIndex - 1))

    $Worksheet.Cells.Item($rowIndex + 3, 1) = 'Km-vergoeding'
    $Worksheet.Cells.Item($rowIndex + 3, 2) = ('Jaar {0}' -f $Year)
    $Worksheet.Cells.Item($rowIndex + 3, 4).Formula = ('=D{0}*0.23' -f ($rowIndex + 1))

    $Worksheet.Range('A:A').NumberFormat = 'dd/mm/yyyy'
    $Worksheet.Range('B:D').NumberFormat = '0.00'
    $Worksheet.Range('A:D').Columns.AutoFit() | Out-Null
    $Worksheet.Columns.Item('A').ColumnWidth = 14
    $Worksheet.Range('A1:D1').Font.Bold = $true
}

function Write-MonthSummarySheet {
    param(
        $Worksheet,
        [object[]]$Rows,
        $ProfitLossData
    )

    $Worksheet.Cells.Item(1, 1) = 'Maand'
    $Worksheet.Cells.Item(1, 2) = 'Uren gepland'
    $Worksheet.Cells.Item(1, 3) = 'Inkomsten rijschool'
    $Worksheet.Cells.Item(1, 4) = 'Kilometers'
    $Worksheet.Cells.Item(1, 5) = 'Uurtarief'
    $Worksheet.Range('A:A').NumberFormat = '@'
    $Worksheet.Range('A1:E1').Font.Bold = $true

    $monthlyGroups = $Rows |
        Group-Object { $_.PlanningDate.ToString('yyyy-MM') } |
        Sort-Object Name

    $rowIndex = 2
    foreach ($group in $monthlyGroups) {
        $monthDate = [datetime]::ParseExact(($group.Name + '-01'), 'yyyy-MM-dd', $culture)
        $plannedHours = [double](($group.Group | Measure-Object Hours -Sum).Sum)
        $plannedKilometers = [double](($group.Group | Measure-Object Kilometers -Sum).Sum)

        $Worksheet.Cells.Item($rowIndex, 1) = $monthDate.ToString('MMMM yyyy', $nlCulture)
        $Worksheet.Cells.Item($rowIndex, 2) = $plannedHours
        $Worksheet.Cells.Item($rowIndex, 3) = [double]($plannedHours * $hourRate)
        $Worksheet.Cells.Item($rowIndex, 4) = $plannedKilometers
        $Worksheet.Cells.Item($rowIndex, 5) = [double]$hourRate
        $rowIndex++
    }

    $Worksheet.Cells.Item($rowIndex + 1, 1) = 'Totaal'
    $Worksheet.Cells.Item($rowIndex + 1, 2).Formula = ('=SUM(B2:B{0})' -f ($rowIndex - 1))
    $Worksheet.Cells.Item($rowIndex + 1, 3).Formula = ('=SUM(C2:C{0})' -f ($rowIndex - 1))
    $Worksheet.Cells.Item($rowIndex + 1, 4).Formula = ('=SUM(D2:D{0})' -f ($rowIndex - 1))
    $Worksheet.Cells.Item($rowIndex + 1, 5) = [double]$hourRate
    $Worksheet.Range('B:E').NumberFormat = '0.00'
    $Worksheet.Range('A:E').Columns.AutoFit() | Out-Null

    if ($ProfitLossData) {
        $totalKilometers = [decimal](($Rows | Measure-Object Kilometers -Sum).Sum)
        $costKm = [math]::Round([double]($totalKilometers * [decimal]0.23), 2, [System.MidpointRounding]::AwayFromZero)
        $costKm = [decimal]$costKm
        $totalCosts = $ProfitLossData.CostRijschool + $costKm + $ProfitLossData.CostInternetMobiel
        $result = $ProfitLossData.IncomeRijschool - $totalCosts
        $startRow = $rowIndex + 4
        $Worksheet.Cells.Item($startRow, 1) = 'Verlies- en winstrekening'
        $Worksheet.Cells.Item($startRow, 1).Font.Bold = $true

        $Worksheet.Cells.Item($startRow + 1, 1) = 'Inkomsten - Rijschool'
        $Worksheet.Cells.Item($startRow + 1, 2) = [double]$ProfitLossData.IncomeRijschool
        $Worksheet.Cells.Item($startRow + 2, 1) = 'Kosten - Rijschool'
        $Worksheet.Cells.Item($startRow + 2, 2) = [double]$ProfitLossData.CostRijschool
        $Worksheet.Cells.Item($startRow + 3, 1) = 'Kosten - km'
        $Worksheet.Cells.Item($startRow + 3, 2) = [double]$costKm
        $Worksheet.Cells.Item($startRow + 4, 1) = 'Kosten - Internet/Mobiel'
        $Worksheet.Cells.Item($startRow + 4, 2) = [double]$ProfitLossData.CostInternetMobiel
        $Worksheet.Cells.Item($startRow + 5, 1) = 'Totale kosten'
        $Worksheet.Cells.Item($startRow + 5, 2) = [double]$totalCosts
        $Worksheet.Cells.Item($startRow + 6, 1) = 'Resultaat'
        $Worksheet.Cells.Item($startRow + 6, 2) = [double]$result

        $Worksheet.Range(('A{0}:B{1}' -f ($startRow + 1), ($startRow + 6))).NumberFormat = '0.00'
        $Worksheet.Range(('A{0}:B{1}' -f ($startRow + 5), ($startRow + 6))).Font.Bold = $true
        $Worksheet.Range(('A{0}:B{1}' -f ($startRow + 1), ($startRow + 6))).Columns.AutoFit() | Out-Null
    }
}

function Get-WritableOutputPath {
    param(
        [string]$PreferredPath
    )

    if (-not (Test-Path $PreferredPath)) {
        return $PreferredPath
    }

    try {
        Remove-Item $PreferredPath -Force
        return $PreferredPath
    }
    catch {
        $directory = Split-Path -Parent $PreferredPath
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($PreferredPath)
        $extension = [System.IO.Path]::GetExtension($PreferredPath)
        $suffix = Get-Date -Format 'yyyyMMdd-HHmmss'
        return (Join-Path $directory ($fileName + ' ' + $suffix + $extension))
    }
}

function Get-HistoricalModel {
    param(
        [object[]]$SourceRows,
        $Excel,
        [int[]]$ReferenceYears
    )

    $monthlyShares = @{}
    $monthlyKmPerHour = @{}
    $yearHours = @{}
    $costIncomeTotal = [decimal]0
    $costRijschoolTotal = [decimal]0
    $costMobileTotal = [decimal]0

    foreach ($year in $ReferenceYears) {
        $rowsForYear = @($SourceRows | Where-Object { $_.SourceYear -eq $year })
        $yearTotalHours = [int](($rowsForYear | Measure-Object Hours -Sum).Sum)
        $yearHours[$year] = $yearTotalHours

        for ($month = 1; $month -le 12; $month++) {
            $monthRows = @($rowsForYear | Where-Object { $_.TransactionDate.Month -eq $month })
            $monthHours = [int](($monthRows | Measure-Object Hours -Sum).Sum)

            if (-not $monthlyShares.ContainsKey($month)) {
                $monthlyShares[$month] = @()
            }

            if ($yearTotalHours -gt 0) {
                $monthlyShares[$month] += ($monthHours / $yearTotalHours)
            }

            if ($monthRows.Count -gt 0) {
                $hoursWeightedKm = ($monthRows | ForEach-Object { [double]$_.KmPerHour * [double]$_.Hours } | Measure-Object -Sum).Sum
                $hoursTotal = ($monthRows | Measure-Object Hours -Sum).Sum

                if ($hoursTotal -gt 0) {
                    if (-not $monthlyKmPerHour.ContainsKey($month)) {
                        $monthlyKmPerHour[$month] = @()
                    }

                    $monthlyKmPerHour[$month] += ($hoursWeightedKm / $hoursTotal)
                }
            }
        }

        $profitLossData = Get-ProfitLossData -Excel $Excel -Year $year
        if ($profitLossData) {
            $costIncomeTotal += [decimal]$profitLossData.IncomeRijschool
            $costRijschoolTotal += [decimal]$profitLossData.CostRijschool
            $costMobileTotal += [decimal]$profitLossData.CostInternetMobiel
        }
    }

    $shareMap = @{}
    $kmMap = @{}
    for ($month = 1; $month -le 12; $month++) {
        $shareValues = @($monthlyShares[$month])
        $shareMap[$month] = if ($shareValues.Count -gt 0) { ($shareValues | Measure-Object -Average).Average } else { (1 / 12) }

        $kmValues = @($monthlyKmPerHour[$month])
        $kmMap[$month] = if ($kmValues.Count -gt 0) {
            [math]::Round(($kmValues | Measure-Object -Average).Average, 2, [System.MidpointRounding]::AwayFromZero)
        }
        else {
            27
        }
    }

    $firstYear = [int](($ReferenceYears | Measure-Object -Minimum).Minimum)
    $lastYear = [int](($ReferenceYears | Measure-Object -Maximum).Maximum)
    $yearSpan = [math]::Max(1, ($lastYear - $firstYear))
    $firstHours = [double]$yearHours[$firstYear]
    $lastHours = [double]$yearHours[$lastYear]
    if ($firstHours -le 0 -or $lastHours -le 0) {
        $positiveHours = @($yearHours.Values | Where-Object { [double]$_ -gt 0 })
        if ($positiveHours.Count -lt 2) {
            throw 'Onvoldoende referentie-uren voor historische planning.'
        }

        $firstHours = [double]$positiveHours[0]
        $lastHours = [double]$positiveHours[$positiveHours.Count - 1]
    }

    $growthFactor = [math]::Pow(($lastHours / $firstHours), (1.0 / $yearSpan))

    return [pscustomobject]@{
        FirstReferenceYear = $firstYear
        FirstReferenceHours = $firstHours
        GrowthFactor = $growthFactor
        MonthlyShares = $shareMap
        MonthlyKmPerHour = $kmMap
        CostRijschoolRatio = if ($costIncomeTotal -gt 0) { $costRijschoolTotal / $costIncomeTotal } else { 0 }
        CostInternetMobielRatio = if ($costIncomeTotal -gt 0) { $costMobileTotal / $costIncomeTotal } else { 0 }
    }
}

function Get-HistoricalTargetHours {
    param(
        $HistoricalModel,
        [int]$TargetYear
    )

    $yearsBack = $HistoricalModel.FirstReferenceYear - $TargetYear
    $hours = $HistoricalModel.FirstReferenceHours / [math]::Pow($HistoricalModel.GrowthFactor, $yearsBack)
    return [int][math]::Round($hours, 0, [System.MidpointRounding]::AwayFromZero)
}

function Get-AllocatedMonthlyHours {
    param(
        [int]$TotalHours,
        [hashtable]$ShareMap
    )

    $allocations = @{}
    $remainders = @()
    $assigned = 0

    for ($month = 1; $month -le 12; $month++) {
        $exact = $TotalHours * [double]$ShareMap[$month]
        $base = [int][math]::Floor($exact)
        $allocations[$month] = $base
        $assigned += $base
        $remainders += [pscustomobject]@{ Month = $month; Fraction = ($exact - $base) }
    }

    $remaining = $TotalHours - $assigned
    foreach ($entry in ($remainders | Sort-Object @{ Expression = 'Fraction'; Descending = $true }, @{ Expression = 'Month'; Descending = $false } | Select-Object -First $remaining)) {
        $allocations[$entry.Month] = [int]$allocations[$entry.Month] + 1
    }

    return $allocations
}

function Get-BusinessDatesForMonth {
    param(
        [int]$Year,
        [int]$Month,
        [hashtable]$HolidayMap
    )

    $dates = @()
    $currentDate = [datetime]::new($Year, $Month, 1)
    $lastDate = $currentDate.AddMonths(1).AddDays(-1)

    while ($currentDate -le $lastDate) {
        if (Test-PlanningDate -Date $currentDate -HolidayMap $HolidayMap) {
            $dates += $currentDate
        }

        $currentDate = $currentDate.AddDays(1)
    }

    return $dates
}

function Select-HistoricalPlanningDates {
    param(
        [datetime[]]$BusinessDates,
        [int]$ActiveDayCount
    )

    $selected = New-Object System.Collections.Generic.List[datetime]
    $used = @{}

    for ($index = 0; $index -lt $ActiveDayCount; $index++) {
        $desired = [int][math]::Floor((($index + 0.5) * $BusinessDates.Count) / $ActiveDayCount)
        if ($desired -ge $BusinessDates.Count) {
            $desired = $BusinessDates.Count - 1
        }

        for ($offset = 0; $offset -lt $BusinessDates.Count; $offset++) {
            $candidateIndices = @($desired - $offset)
            if ($offset -gt 0) {
                $candidateIndices += ($desired + $offset)
            }

            foreach ($candidateIndex in $candidateIndices) {
                if ($candidateIndex -lt 0 -or $candidateIndex -ge $BusinessDates.Count) {
                    continue
                }

                $candidateDate = $BusinessDates[$candidateIndex]
                $key = $candidateDate.ToString('yyyy-MM-dd')
                if ($used.ContainsKey($key)) {
                    continue
                }

                $used[$key] = $true
                $selected.Add($candidateDate)
                $offset = $BusinessDates.Count
                break
            }
        }
    }

    return @($selected | Sort-Object)
}

function New-HistoricalPlanningRows {
    param(
        $HistoricalModel,
        [int]$TargetYear,
        [hashtable]$HolidayMap
    )

    $targetHours = Get-HistoricalTargetHours -HistoricalModel $HistoricalModel -TargetYear $TargetYear
    $monthlyHours = Get-AllocatedMonthlyHours -TotalHours $targetHours -ShareMap $HistoricalModel.MonthlyShares
    $historicalRows = @()

    for ($month = 1; $month -le 12; $month++) {
        $hoursInMonth = [int]$monthlyHours[$month]
        if ($hoursInMonth -le 0) {
            continue
        }

        $businessDates = @(Get-BusinessDatesForMonth -Year $TargetYear -Month $month -HolidayMap $HolidayMap)
        if ($businessDates.Count -eq 0) {
            continue
        }

        $activeDayCount = [int][math]::Ceiling($hoursInMonth / 4.0)
        $minDayCount = [int][math]::Ceiling($hoursInMonth / [double]$maxHoursPerDay)
        $activeDayCount = [math]::Max($activeDayCount, $minDayCount)
        $activeDayCount = [math]::Min($activeDayCount, $businessDates.Count)

        $selectedDates = Select-HistoricalPlanningDates -BusinessDates $businessDates -ActiveDayCount $activeDayCount
        $baseHours = [int][math]::Floor($hoursInMonth / $selectedDates.Count)
        $remainingHours = $hoursInMonth - ($baseHours * $selectedDates.Count)

        for ($index = 0; $index -lt $selectedDates.Count; $index++) {
            $hoursForDay = $baseHours
            if ($remainingHours -gt 0) {
                $hoursForDay++
                $remainingHours--
            }

            $kmPerHour = [decimal]$HistoricalModel.MonthlyKmPerHour[$month]
            $historicalRows += [pscustomobject]@{
                PlanningDate = $selectedDates[$index]
                Hours = $hoursForDay
                KmPerHour = $kmPerHour
                Kilometers = [decimal]$hoursForDay * $kmPerHour
            }
        }
    }

    return $historicalRows | Sort-Object PlanningDate
}

function Get-HistoricalProfitLossData {
    param(
        $HistoricalModel,
        [object[]]$PlanningRows
    )

    $totalHours = [decimal](($PlanningRows | Measure-Object Hours -Sum).Sum)
    $income = $totalHours * $hourRate
    $costRijschool = [math]::Round([double]($income * [decimal]$HistoricalModel.CostRijschoolRatio), 2, [System.MidpointRounding]::AwayFromZero)
    $costMobile = [math]::Round([double]($income * [decimal]$HistoricalModel.CostInternetMobielRatio), 2, [System.MidpointRounding]::AwayFromZero)

    return [pscustomobject]@{
        IncomeRijschool = [decimal]$income
        CostRijschool = [decimal]$costRijschool
        CostInternetMobiel = [decimal]$costMobile
    }
}

function Write-Workbook {
    param(
        $Excel,
        [string]$OutputPath,
        [object[]]$PlanningRows,
        [object[]]$SourceRows,
        [int]$Year,
        $ProfitLossData,
        [switch]$SkipSourceSheet
    )

    $finalOutputPath = Get-WritableOutputPath -PreferredPath $OutputPath
    $workbook = $Excel.Workbooks.Add()
    $sourceSheet = $null

    $planningSheet = $workbook.Worksheets.Item(1)
    $planningSheet.Name = 'Rittenplanning'
    $dailyPlanningRows = Group-PlanningRowsPerDay -Rows $PlanningRows
    Write-PlanningSheet -Worksheet $planningSheet -Rows $dailyPlanningRows -Year $Year

    if (-not $SkipSourceSheet -and $SourceRows.Count -gt 0) {
        $sourceSheet = $workbook.Worksheets.Add()
        $sourceSheet.Name = 'Bron transacties'
        Write-SourceSheet -Worksheet $sourceSheet -Rows $SourceRows
    }

    $summarySheet = $workbook.Worksheets.Add()
    $summarySheet.Name = 'Maandsamenvatting'
    Write-MonthSummarySheet -Worksheet $summarySheet -Rows $dailyPlanningRows -ProfitLossData $ProfitLossData

    $workbook.SaveAs($finalOutputPath)
    $workbook.Close($true)

    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($planningSheet)
    if ($sourceSheet) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($sourceSheet)
    }
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($summarySheet)
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)

    return $finalOutputPath
}

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $sourceRows = Get-AllSourceRows -Excel $excel -Years $analysisYears
    $holidayMap = Get-DutchHolidayMap -Years $outputYears
    $planningRows = New-PlanningRows -SourceRows $sourceRows -HolidayMap $holidayMap
    $historicalModel = Get-HistoricalModel -SourceRows $sourceRows -Excel $excel -ReferenceYears $historicalReferenceYears

    foreach ($year in $outputYears) {
        if ($year -lt ($analysisYears | Measure-Object -Minimum).Minimum) {
            $yearPlanningRows = New-HistoricalPlanningRows -HistoricalModel $historicalModel -TargetYear $year -HolidayMap $holidayMap
            $yearSourceRows = @()
            $profitLossData = Get-HistoricalProfitLossData -HistoricalModel $historicalModel -PlanningRows $yearPlanningRows
            $writtenPath = Write-Workbook -Excel $excel -OutputPath (Get-OutputPath -Year $year) -PlanningRows $yearPlanningRows -SourceRows $yearSourceRows -Year $year -ProfitLossData $profitLossData -SkipSourceSheet
            Write-Output ("YEAR={0} | SOURCE_ROWS={1} | PLAN_ROWS={2} | FILE={3}" -f $year, 0, $yearPlanningRows.Count, $writtenPath)
            continue
        }

        $yearPlanningRows = @($planningRows | Where-Object { $_.PlanningDate.Year -eq $year })
        $yearSourceRows = @($sourceRows | Where-Object { $_.SourceYear -eq $year })
        $profitLossData = $null

        if ($analysisYears -contains $year) {
            $profitLossData = Get-ProfitLossData -Excel $excel -Year $year
        }

        if ($yearPlanningRows.Count -eq 0 -and $yearSourceRows.Count -eq 0 -and -not $profitLossData) {
            continue
        }

        $writtenPath = Write-Workbook -Excel $excel -OutputPath (Get-OutputPath -Year $year) -PlanningRows $yearPlanningRows -SourceRows $yearSourceRows -Year $year -ProfitLossData $profitLossData
        Write-Output ("YEAR={0} | SOURCE_ROWS={1} | PLAN_ROWS={2} | FILE={3}" -f $year, $yearSourceRows.Count, $yearPlanningRows.Count, $writtenPath)
    }
}
finally {
    $excel.Quit()
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
}
