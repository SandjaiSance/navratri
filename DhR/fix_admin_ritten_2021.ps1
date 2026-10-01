$ErrorActionPreference = 'Stop'

$path = 'd:\GithubCopilotWS\DhR\Admin_Ritten_2021.xlsx'
$targetYear = 2021
$hourRate = [decimal]32.5

function Get-WeekdayDatesForMonth {
    param(
        [int]$Year,
        [int]$Month
    )

    $dates = New-Object System.Collections.Generic.List[datetime]
    $cursor = [datetime]::new($Year, $Month, 1)
    $lastDate = $cursor.AddMonths(1).AddDays(-1)

    while ($cursor -le $lastDate) {
        if ($cursor.DayOfWeek -ne [System.DayOfWeek]::Saturday -and $cursor.DayOfWeek -ne [System.DayOfWeek]::Sunday) {
            $dates.Add($cursor)
        }

        $cursor = $cursor.AddDays(1)
    }

    return $dates
}

function Select-PlanningDates {
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
                $candidateKey = $candidateDate.ToString('yyyy-MM-dd')
                if ($used.ContainsKey($candidateKey)) {
                    continue
                }

                $used[$candidateKey] = $true
                $selected.Add($candidateDate)
                $offset = $BusinessDates.Count
                break
            }
        }
    }

    return @($selected | Sort-Object)
}

function Get-AllocatedMonthlyHours {
    param(
        [int]$TotalHours,
        [hashtable]$BaseHours
    )

    $sourceTotal = [int](($BaseHours.Values | Measure-Object -Sum).Sum)
    if ($sourceTotal -le 0) {
        throw 'Kan maandverdeling niet bepalen zonder bronuren.'
    }

    $allocations = @{}
    $remainders = @()
    $assigned = 0

    for ($month = 1; $month -le 12; $month++) {
        $exact = ($TotalHours * [double]$BaseHours[$month]) / $sourceTotal
        $base = [int][math]::Floor($exact)
        $allocations[$month] = $base
        $assigned += $base
        $remainders += [pscustomobject]@{
            Month = $month
            Fraction = $exact - $base
        }
    }

    $remaining = $TotalHours - $assigned
    foreach ($entry in ($remainders | Sort-Object @{ Expression = 'Fraction'; Descending = $true }, @{ Expression = 'Month'; Descending = $false } | Select-Object -First $remaining)) {
        $allocations[$entry.Month] = [int]$allocations[$entry.Month] + 1
    }

    return $allocations
}

function New-HourPattern {
    param(
        [int]$TotalHours,
        [int]$DayCount
    )

    if ($DayCount -le 0) {
        throw 'Dagtelling moet groter dan nul zijn.'
    }

    $seed = @(2, 3, 4, 5, 6, 4)
    $hoursPattern = New-Object System.Collections.Generic.List[int]

    for ($index = 0; $index -lt $DayCount; $index++) {
        $hoursPattern.Add($seed[$index % $seed.Count])
    }

    $currentTotal = [int](($hoursPattern | Measure-Object -Sum).Sum)
    $diff = $TotalHours - $currentTotal

    while ($diff -ne 0) {
        if ($diff -gt 0) {
            for ($index = 0; $index -lt $hoursPattern.Count -and $diff -gt 0; $index++) {
                if ($hoursPattern[$index] -lt 6) {
                    $hoursPattern[$index]++
                    $diff--
                }
            }
        }
        else {
            for ($index = $hoursPattern.Count - 1; $index -ge 0 -and $diff -lt 0; $index--) {
                if ($hoursPattern[$index] -gt 2) {
                    $hoursPattern[$index]--
                    $diff++
                }
            }
        }
    }

    return $hoursPattern
}

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $workbook = $excel.Workbooks.Open($path, 0, $false)
    $planningSheet = $workbook.Worksheets.Item('Rittenplanning')
    $summarySheet = $workbook.Worksheets.Item('Maandsamenvatting')
    $sourceSheet = $workbook.Worksheets.Item('Bron transacties')

    $monthlyHours = @{}
    $monthlyKmPerHour = @{}
    $sourceTotalHours = 0

    for ($month = 1; $month -le 12; $month++) {
        $monthlyHours[$month] = 0
    }

    $sourceLastRow = [int]$sourceSheet.UsedRange.Rows.Count
    for ($rowIndex = 2; $rowIndex -le $sourceLastRow; $rowIndex++) {
        $dateValue = $sourceSheet.Range('A' + $rowIndex).Value2
        $hoursValue = $sourceSheet.Range('C' + $rowIndex).Value2

        if ($null -eq $dateValue -or $null -eq $hoursValue -or [string]$hoursValue -eq '') {
            continue
        }

        $transactionDate = $null
        if ($dateValue -is [double] -or $dateValue -is [int]) {
            $transactionDate = [datetime]::FromOADate([double]$dateValue)
        }
        elseif ($dateValue -is [datetime]) {
            $transactionDate = [datetime]$dateValue
        }
        else {
            continue
        }

        if ($transactionDate.Year -ne $targetYear) {
            continue
        }

        $hours = [int][math]::Round([double]$hoursValue, 0, [System.MidpointRounding]::AwayFromZero)
        $month = $transactionDate.Month
        $monthlyHours[$month] = [int]$monthlyHours[$month] + $hours
        $sourceTotalHours += $hours
    }

    for ($month = 1; $month -le 12; $month++) {
        $summaryRow = 2 + $month
        $hours = [int]$monthlyHours[$month]
        $kilometers = [double]$summarySheet.Range('D' + $summaryRow).Value2

        $monthlyKmPerHour[$month] = if ($hours -gt 0) {
            [math]::Round(($kilometers / $hours), 8, [System.MidpointRounding]::AwayFromZero)
        }
        else {
            27
        }
    }

    $targetTotalHours = $sourceTotalHours

    if ($targetTotalHours -le 0) {
        throw ('Doeluren ({0}) zijn ongeldig.' -f $targetTotalHours)
    }

    $costRijschoolRatio = [decimal]([double]$summarySheet.Range('B21').Value2 / [double]$summarySheet.Range('B20').Value2)
    $costMobileRatio = [decimal]([double]$summarySheet.Range('B23').Value2 / [double]$summarySheet.Range('B20').Value2)
    $allocatedHours = Get-AllocatedMonthlyHours -TotalHours $targetTotalHours -BaseHours $monthlyHours

    $planningRows = New-Object System.Collections.Generic.List[object]

    for ($month = 1; $month -le 12; $month++) {
        $hoursInMonth = [int]$allocatedHours[$month]
        if ($hoursInMonth -le 0) {
            continue
        }

        $businessDates = @(Get-WeekdayDatesForMonth -Year $targetYear -Month $month)
        if ($businessDates.Count -eq 0) {
            continue
        }

        $activeDayCount = [int][math]::Ceiling($hoursInMonth / 4.0)
        $minDayCount = [int][math]::Ceiling($hoursInMonth / 8.0)
        $maxDayCount = [int][math]::Floor($hoursInMonth / 2.0)
        $activeDayCount = [math]::Max($activeDayCount, $minDayCount)
        $activeDayCount = [math]::Min($activeDayCount, $maxDayCount)
        $activeDayCount = [math]::Min($activeDayCount, $businessDates.Count)

        $selectedDates = @(Select-PlanningDates -BusinessDates $businessDates -ActiveDayCount $activeDayCount)
        $hoursPattern = @(New-HourPattern -TotalHours $hoursInMonth -DayCount $selectedDates.Count)

        for ($index = 0; $index -lt $selectedDates.Count; $index++) {
            $hoursForDay = [int]$hoursPattern[$index]

            $kmPerHour = [decimal]$monthlyKmPerHour[$month]
            $planningRows.Add([pscustomobject]@{
                PlanningDate = $selectedDates[$index]
                Hours = [decimal]$hoursForDay
                KmPerHour = $kmPerHour
                Kilometers = [decimal]([math]::Round(([double]$hoursForDay * [double]$kmPerHour), 2, [System.MidpointRounding]::AwayFromZero))
            })
        }
    }

    $planningRows = @($planningRows | Sort-Object PlanningDate)
    $lastDataRow = $planningRows.Count + 1
    $totalRow = $lastDataRow + 2
    $kmRow = $lastDataRow + 4

    $planningSheet.Range('A1:D500').ClearContents()
    $planningSheet.Range('A1').Value = 'Plandatum'
    $planningSheet.Range('B1').Value = 'Uren gepland'
    $planningSheet.Range('C1').Value = 'Km per uur'
    $planningSheet.Range('D1').Value = 'Kilometers'

    $rowIndex = 2
    foreach ($planningRow in $planningRows) {
        $planningSheet.Range('A' + $rowIndex).Value = $planningRow.PlanningDate
        $planningSheet.Range('B' + $rowIndex).Value2 = [double]$planningRow.Hours
        $planningSheet.Range('C' + $rowIndex).Value2 = [double]$planningRow.KmPerHour
        $planningSheet.Range('D' + $rowIndex).Value2 = [double]$planningRow.Kilometers
        $rowIndex++
    }

    $planningSheet.Range('A2:A' + $lastDataRow).NumberFormat = 'dd/mm/yyyy'
    $planningSheet.Range('B2:D' + $lastDataRow).NumberFormat = '0.00'
    $planningSheet.Range('A' + $totalRow).Value = 'Totaal'
    $planningSheet.Range('B' + $totalRow).Formula = '=SUM(B2:B' + $lastDataRow + ')'
    $planningSheet.Range('D' + $totalRow).Formula = '=SUM(D2:D' + $lastDataRow + ')'
    $planningSheet.Range('A' + $kmRow).Value = 'Km-vergoeding'
    $planningSheet.Range('B' + $kmRow).Value = 'Jaar 2021'
    $planningSheet.Range('D' + $kmRow).Formula = '=D' + $totalRow + '*0.23'

    $summarySheet.Range('A1').Value = '2021'
    $summarySheet.Range('B1').Value = 'zakelijk'
    $summarySheet.Range('A2').Value = 'Maand'
    $summarySheet.Range('B2').Value = 'Uren gepland'
    $summarySheet.Range('C2').Value = 'Inkomsten rijschool'
    $summarySheet.Range('D2').Value = 'Kilometers'
    $summarySheet.Range('E2').Value = 'Uurtarief'

    for ($month = 1; $month -le 12; $month++) {
        $summaryRow = 2 + $month
        $startDate = ('DATE(2021,{0},1)' -f $month)
        if ($month -eq 12) {
            $endDate = 'DATE(2022,1,1)'
        }
        else {
            $endDate = ('DATE(2021,{0},1)' -f ($month + 1))
        }

        $summarySheet.Range('B' + $summaryRow).Formula = '=SUMIFS(Rittenplanning!$B:$B,Rittenplanning!$A:$A,">="&' + $startDate + ',Rittenplanning!$A:$A,"<"&' + $endDate + ')'
        $summarySheet.Range('C' + $summaryRow).Formula = '=B' + $summaryRow + '*E' + $summaryRow
        $summarySheet.Range('D' + $summaryRow).Formula = '=SUMIFS(Rittenplanning!$D:$D,Rittenplanning!$A:$A,">="&' + $startDate + ',Rittenplanning!$A:$A,"<"&' + $endDate + ')'
        $summarySheet.Range('E' + $summaryRow).Value2 = [double]$hourRate
    }

    $summarySheet.Range('A16').Value = 'Totaal'
    $summarySheet.Range('B16').Formula = '=SUM(B3:B14)'
    $summarySheet.Range('C16').Formula = '=SUM(C3:C14)'
    $summarySheet.Range('D16').Formula = '=SUM(D3:D14)'
    $summarySheet.Range('E16').Value2 = [double]$hourRate

    $summarySheet.Range('A19').Value = 'Verlies- en winstrekening'
    $summarySheet.Range('A20').Value = 'Inkomsten - Rijschool'
    $summarySheet.Range('B20').Formula = '=C16'
    $summarySheet.Range('A21').Value = 'Kosten - Rijschool'
    $summarySheet.Range('B21').Formula = '=ROUND(B20*' + ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0:0.0000000000}', [double]$costRijschoolRatio)) + ',2)'
    $summarySheet.Range('A22').Value = 'Kosten - km'
    $summarySheet.Range('B22').Formula = '=ROUND(D16*0.23,2)'
    $summarySheet.Range('A23').Value = 'Kosten - Internet/Mobiel'
    $summarySheet.Range('B23').Formula = '=ROUND(B20*' + ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0:0.0000000000}', [double]$costMobileRatio)) + ',2)'
    $summarySheet.Range('C23').Formula = '=SUM(B21:B23)'
    $summarySheet.Range('A24').Value = 'Totale kosten'
    $summarySheet.Range('B24').Formula = '=SUM(B21:B23)'
    $summarySheet.Range('A25').Value = 'Resultaat'
    $summarySheet.Range('B25').Formula = '=B20-B24'
    $summarySheet.Range('C26').Formula = '=B24+B25'

    $summarySheet.Range('B3:E16').NumberFormat = '0.00'
    $summarySheet.Range('B20:C26').NumberFormat = '0.00'
    $summarySheet.Columns('A:E').AutoFit() | Out-Null

    $workbook.Application.CalculateFullRebuild()
    $workbook.Save()

    Write-Output ('SOURCE_TOTAL_HOURS=' + $sourceTotalHours)
    Write-Output ('TARGET_TOTAL_HOURS=' + $targetTotalHours)
    Write-Output ('PLAN_ROWS=' + $planningRows.Count)
    Write-Output ('SUMMARY_B16=' + $summarySheet.Range('B16').Text)
    Write-Output ('SUMMARY_C16=' + $summarySheet.Range('C16').Text)
    Write-Output ('SUMMARY_D16=' + $summarySheet.Range('D16').Text)
    Write-Output ('PL_B20=' + $summarySheet.Range('B20').Text)
    Write-Output ('PL_B24=' + $summarySheet.Range('B24').Text)
    Write-Output ('PL_B25=' + $summarySheet.Range('B25').Text)
    Write-Output ('PL_C26=' + $summarySheet.Range('C26').Text)
}
finally {
    if ($sourceSheet) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($sourceSheet)
    }

    if ($summarySheet) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($summarySheet)
    }

    if ($planningSheet) {
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($planningSheet)
    }

    if ($workbook) {
        $workbook.Close($true)
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
    }

    if ($excel) {
        $excel.Quit()
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
    }
}