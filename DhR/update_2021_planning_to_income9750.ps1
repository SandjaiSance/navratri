$ErrorActionPreference = 'Stop'

$path = 'd:\GithubCopilotWS\DhR\Admin_Ritten_2021.xlsx'

$targets = @(
  @{ Month = 1; Label = 'januari 2021'; Total = 11; Rate = 757 / 29 },
  @{ Month = 2; Label = 'februari 2021'; Total = 12; Rate = 912 / 34 },
  @{ Month = 3; Label = 'maart 2021'; Total = 17; Rate = 1275 / 47 },
  @{ Month = 4; Label = 'april 2021'; Total = 20; Rate = 1497 / 55 },
  @{ Month = 5; Label = 'mei 2021'; Total = 20; Rate = 1427 / 53 },
  @{ Month = 6; Label = 'juni 2021'; Total = 26; Rate = 1901 / 71 },
  @{ Month = 7; Label = 'juli 2021'; Total = 26; Rate = 1940 / 72 },
  @{ Month = 8; Label = 'augustus 2021'; Total = 25; Rate = 1814 / 69 },
  @{ Month = 9; Label = 'september 2021'; Total = 28; Rate = 2032 / 77 },
  @{ Month = 10; Label = 'oktober 2021'; Total = 31; Rate = 2232 / 84 },
  @{ Month = 11; Label = 'november 2021'; Total = 38; Rate = 2787 / 104 },
  @{ Month = 12; Label = 'december 2021'; Total = 46; Rate = 3267 / 121 }
)

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
  $wb = $excel.Workbooks.Open($path, 0, $false)
  $plan = $wb.Worksheets.Item('Rittenplanning')
  $summary = $wb.Worksheets.Item('Maandsamenvatting')

  $plan.Range('A1:D500').ClearContents()
  $plan.Range('A1').Value = 'Plandatum'
  $plan.Range('B1').Value = 'Uren gepland'
  $plan.Range('C1').Value = 'Km per uur'
  $plan.Range('D1').Value = 'Kilometers'

  $row = 2
  foreach ($target in $targets) {
    $daysNeeded = [int][math]::Round($target.Total / 2.5)
    $minDays = [int][math]::Ceiling($target.Total / 4.0)
    if ($daysNeeded -lt $minDays) { $daysNeeded = $minDays }

    $seed = @(2, 3, 1, 4, 2, 3, 1, 4)
    $hoursPattern = New-Object System.Collections.Generic.List[int]
    for ($i = 0; $i -lt $daysNeeded; $i++) {
      $hoursPattern.Add($seed[$i % $seed.Count])
    }

    $currentTotal = 0
    foreach ($value in $hoursPattern) { $currentTotal += $value }
    $diff = $target.Total - $currentTotal

    while ($diff -ne 0) {
      if ($diff -gt 0) {
        for ($i = 0; $i -lt $hoursPattern.Count -and $diff -gt 0; $i++) {
          if ($hoursPattern[$i] -lt 4) {
            $hoursPattern[$i] += 1
            $diff -= 1
          }
        }
      }
      else {
        for ($i = $hoursPattern.Count - 1; $i -ge 0 -and $diff -lt 0; $i--) {
          if ($hoursPattern[$i] -gt 1) {
            $hoursPattern[$i] -= 1
            $diff += 1
          }
        }
      }
    }

    $cursor = [datetime]::new(2021, $target.Month, 1)
    $written = 0

    while ($written -lt $daysNeeded) {
      if ($cursor.DayOfWeek -ne 'Saturday' -and $cursor.DayOfWeek -ne 'Sunday') {
        $hours = [double]([int]$hoursPattern[$written])
        $km = [math]::Round($hours * [double]$target.Rate, 2)
        $plan.Range('A' + $row).Value = $cursor
        $plan.Range('B' + $row).Value2 = $hours
        $plan.Range('C' + $row).Value2 = [double]$target.Rate
        $plan.Range('D' + $row).Value2 = [double]$km
        $written += 1
        $row += 1
      }
      $cursor = $cursor.AddDays(1)
    }
  }

  $lastDataRow = $row - 1
  $totalRow = $lastDataRow + 2
  $kmRow = $lastDataRow + 4

  $plan.Range('A2:A' + $lastDataRow).NumberFormat = 'dd/mm/yyyy'
  $plan.Range('B2:D' + $lastDataRow).NumberFormat = '0.00'
  $plan.Range('A' + $totalRow).Value = 'Totaal'
  $plan.Range('B' + $totalRow).Formula = '=SUM(B2:B' + $lastDataRow + ')'
  $plan.Range('D' + $totalRow).Formula = '=SUM(D2:D' + $lastDataRow + ')'
  $plan.Range('A' + $kmRow).Value = 'Km-vergoeding'
  $plan.Range('B' + $kmRow).Value = 'Jaar 2021'
  $plan.Range('D' + $kmRow).Formula = '=D' + $totalRow + '*0.23'

  for ($i = 0; $i -lt $targets.Count; $i++) {
    $month = $i + 1
    $nextMonth = $month + 1
    $nextYear = 2021
    if ($nextMonth -eq 13) {
      $nextMonth = 1
      $nextYear = 2022
    }
    $summaryRow = 3 + $i
    $summary.Range('B' + $summaryRow).Formula = '=SUMIFS(Rittenplanning!$B:$B,Rittenplanning!$A:$A,">="&DATE(2021,' + $month + ',1),Rittenplanning!$A:$A,"<"&DATE(' + $nextYear + ',' + $nextMonth + ',1))'
    $summary.Range('C' + $summaryRow).Formula = '=B' + $summaryRow + '*E' + $summaryRow
    $summary.Range('D' + $summaryRow).Formula = '=SUMIFS(Rittenplanning!$D:$D,Rittenplanning!$A:$A,">="&DATE(2021,' + $month + ',1),Rittenplanning!$A:$A,"<"&DATE(' + $nextYear + ',' + $nextMonth + ',1))'
  }

  $summary.Range('B16').Formula = '=SUM(B3:B14)'
  $summary.Range('C16').Formula = '=SUM(C3:C14)'
  $summary.Range('D16').Formula = '=SUM(D3:D14)'
  $summary.Range('B20').Formula = '=C16'
  $summary.Range('B3:D20').NumberFormat = '0.00'
  $summary.Columns('B').ColumnWidth = 12

  $wb.Application.CalculateFullRebuild()
  $wb.Save()

  Write-Output ('lastDataRow=' + $lastDataRow)
  Write-Output ('b16=' + $summary.Range('B16').Text + ';c16=' + $summary.Range('C16').Text + ';d16=' + $summary.Range('D16').Text)
  Write-Output ('b20=' + $summary.Range('B20').Text + ';b25=' + $summary.Range('B25').Text)
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