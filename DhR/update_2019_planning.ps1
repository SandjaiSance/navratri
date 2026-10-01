$ErrorActionPreference = 'Stop'

$path = 'd:\GithubCopilotWS\DhR\Admin_Ritten_2019.xlsx'

$targets = @(
  @{ Month = 1; Label = 'januari 2019'; Total = 84; Rate = 26.78 },
  @{ Month = 2; Label = 'februari 2019'; Total = 86; Rate = 25.87 },
  @{ Month = 3; Label = 'maart 2019'; Total = 88; Rate = 26.42 },
  @{ Month = 4; Label = 'april 2019'; Total = 90; Rate = 26.90 },
  @{ Month = 5; Label = 'mei 2019'; Total = 92; Rate = 27.68 },
  @{ Month = 6; Label = 'juni 2019'; Total = 89; Rate = 26.22 },
  @{ Month = 7; Label = 'juli 2019'; Total = 94; Rate = 27.68 },
  @{ Month = 8; Label = 'augustus 2019'; Total = 80; Rate = 26.49 },
  @{ Month = 9; Label = 'september 2019'; Total = 90; Rate = 26.39 },
  @{ Month = 10; Label = 'oktober 2019'; Total = 96; Rate = 26.55 },
  @{ Month = 11; Label = 'november 2019'; Total = 92; Rate = 27.17 },
  @{ Month = 12; Label = 'december 2019'; Total = 99; Rate = 26.36 }
)

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
  $wb = $excel.Workbooks.Open($path, 0, $false)
  $plan = $wb.Worksheets.Item('Rittenplanning')
  $summary = $wb.Worksheets.Item('Maandsamenvatting')

  $rowCount = 0

  foreach ($target in $targets) {
    $daysNeeded = [int][math]::Round($target.Total / 5.0)
    $minDays = [int][math]::Ceiling($target.Total / 7.0)
    $maxDays = [int][math]::Floor($target.Total / 3.0)
    if ($daysNeeded -lt $minDays) { $daysNeeded = $minDays }
    if ($daysNeeded -gt $maxDays) { $daysNeeded = $maxDays }

    $baseHours = [int][math]::Floor($target.Total / $daysNeeded)
    $remainder = $target.Total - ($baseHours * $daysNeeded)
    $cursor = Get-Date -Year 2019 -Month $target.Month -Day 1
    $written = 0

    while ($written -lt $daysNeeded) {
      if ($cursor.DayOfWeek -ne 'Saturday' -and $cursor.DayOfWeek -ne 'Sunday') {
        $hours = $baseHours
        if ($written -lt $remainder) { $hours += 1 }
        $rowCount += 1
        $written += 1
      }
      $cursor = $cursor.AddDays(1)
    }
  }

  $plan.Range('A1:D250').ClearContents()
  $plan.Range('A1').Value = 'Plandatum'
  $plan.Range('B1').Value = 'Uren gepland'
  $plan.Range('C1').Value = 'Km per uur'
  $plan.Range('D1').Value = 'Kilometers'

  $endRow = $rowCount + 1
  $targetRow = 2
  foreach ($target in $targets) {
    $daysNeeded = [int][math]::Round($target.Total / 5.0)
    $minDays = [int][math]::Ceiling($target.Total / 7.0)
    $maxDays = [int][math]::Floor($target.Total / 3.0)
    if ($daysNeeded -lt $minDays) { $daysNeeded = $minDays }
    if ($daysNeeded -gt $maxDays) { $daysNeeded = $maxDays }

    $baseHours = [int][math]::Floor($target.Total / $daysNeeded)
    $remainder = $target.Total - ($baseHours * $daysNeeded)
    $cursor = [datetime]::new(2019, $target.Month, 1)
    $written = 0

    while ($written -lt $daysNeeded) {
      if ($cursor.DayOfWeek -ne 'Saturday' -and $cursor.DayOfWeek -ne 'Sunday') {
        $hours = $baseHours
        if ($written -lt $remainder) { $hours += 1 }
        $km = [math]::Round($hours * $target.Rate, 2)
        $plan.Range('A' + $targetRow).Value = $cursor
        $plan.Range('B' + $targetRow).Value2 = [double]$hours
        $plan.Range('C' + $targetRow).Value2 = [double]$target.Rate
        $plan.Range('D' + $targetRow).Value2 = [double]$km
        $targetRow += 1
        $written += 1
      }
      $cursor = $cursor.AddDays(1)
    }
  }
  $plan.Range('A2:A' + $endRow).NumberFormat = 'dd/mm/yyyy'
  $plan.Range('B2:D' + $endRow).NumberFormat = '0.00'

  $totalRow = $endRow + 2
  $kmRow = $endRow + 4
  $plan.Range('A' + $totalRow).Value = 'Totaal'
  $plan.Range('B' + $totalRow).Formula = '=SUM(B2:B' + $endRow + ')'
  $plan.Range('D' + $totalRow).Formula = '=SUM(D2:D' + $endRow + ')'
  $plan.Range('A' + $kmRow).Value = 'Km-vergoeding'
  $plan.Range('B' + $kmRow).Value = 'Jaar 2019'
  $plan.Range('D' + $kmRow).Formula = '=D' + $totalRow + '*0.23'

  for ($i = 0; $i -lt $targets.Count; $i++) {
    $month = $targets[$i].Month
    $nextMonth = $month + 1
    $nextYear = 2019
    if ($nextMonth -eq 13) {
      $nextMonth = 1
      $nextYear = 2020
    }

    $summaryRow = 2 + $i
    $summary.Range('B' + $summaryRow).Formula = '=SUMIFS(Rittenplanning!$B:$B,Rittenplanning!$A:$A,">="&DATE(2019,' + $month + ',1),Rittenplanning!$A:$A,"<"&DATE(' + $nextYear + ',' + $nextMonth + ',1))'
    $summary.Range('C' + $summaryRow).Formula = '=B' + $summaryRow + '*E' + $summaryRow
    $summary.Range('D' + $summaryRow).Formula = '=SUMIFS(Rittenplanning!$D:$D,Rittenplanning!$A:$A,">="&DATE(2019,' + $month + ',1),Rittenplanning!$A:$A,"<"&DATE(' + $nextYear + ',' + $nextMonth + ',1))'
  }

  $summary.Range('B15').Formula = '=SUM(B2:B13)'
  $summary.Range('C15').Formula = '=SUM(C2:C13)'
  $summary.Range('D15').Formula = '=SUM(D2:D13)'
  $summary.Range('B19').Formula = '=C15'
  $summary.Range('B21').Formula = '=D15*0.23'
  $summary.Range('B23').Formula = '=SUM(B20:B22)'
  $summary.Range('B24').Formula = '=B19-B23'
  $summary.Range('B2:D24').NumberFormat = '0.00'
  $summary.Columns('B').ColumnWidth = 12

  $wb.Application.CalculateFullRebuild()
  $wb.Save()

  Write-Output ('rowCount=' + $rowCount)
  Write-Output ('usedRange=' + $plan.UsedRange.Address($false, $false))
  Write-Output ('a2=' + $plan.Range('A2').Text + ';b2=' + $plan.Range('B2').Text + ';d2=' + $plan.Range('D2').Text)
  Write-Output ('a20=' + $plan.Range('A20').Text + ';b20=' + $plan.Range('B20').Text + ';d20=' + $plan.Range('D20').Text)
  Write-Output ('b15=' + $summary.Range('B15').Text + ';c15=' + $summary.Range('C15').Text + ';d15=' + $summary.Range('D15').Text)
}
finally {
  if ($summary) { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($summary) | Out-Null }
  if ($plan) { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($plan) | Out-Null }
  if ($wb) {
    $wb.Close($true)
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($wb) | Out-Null
  }
  $excel.Quit()
  [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
}