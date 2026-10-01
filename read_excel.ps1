$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

$files = @(
    "D:\GithubCopilotWS\DhR\Admin_Ritten_2023.xlsx",
    "D:\GithubCopilotWS\DhR\Admin_Ritten_2024.xlsx"
)

foreach ($filePath in $files) {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "FILE: $filePath" -ForegroundColor Cyan
    Write-Host "========================================`n"

    $wb = $excel.Workbooks.Open($filePath, 0, $true)  # UpdateLinks=0, ReadOnly=$true

    # Find sheet Maandsamenvatting
    $ws = $null
    foreach ($sheet in $wb.Sheets) {
        if ($sheet.Name -eq "Maandsamenvatting") {
            $ws = $sheet
            break
        }
    }

    if ($null -eq $ws) {
        Write-Host "Sheet 'Maandsamenvatting' NOT FOUND. Available sheets:"
        foreach ($sheet in $wb.Sheets) { Write-Host "  - $($sheet.Name)" }
    } else {
        Write-Host "=== Sheet: Maandsamenvatting ===" -ForegroundColor Yellow

        # Part 1: Columns A:E, rows 1-16
        Write-Host "`n--- PART 1: Columns A:E, Rows 1-16 (non-empty) ---" -ForegroundColor Green
        for ($row = 1; $row -le 16; $row++) {
            for ($col = 1; $col -le 5; $col++) {
                $cell = $ws.Cells.Item($row, $col)
                $val = $cell.Value2
                $text = $cell.Text
                if ($null -ne $val -or ($text -ne "" -and $null -ne $text)) {
                    $colLetter = [char](64 + $col)
                    $formula = $cell.Formula
                    Write-Host "  Cell ${colLetter}${row}: Text=[$text]  Value2=[$val]  Formula=[$formula]"
                }
            }
        }

        # Part 2: Columns I:K (9:11), rows 14-27
        Write-Host "`n--- PART 2: Columns I:K, Rows 14-27 (all non-empty) ---" -ForegroundColor Green
        for ($row = 14; $row -le 27; $row++) {
            for ($col = 9; $col -le 11; $col++) {
                $cell = $ws.Cells.Item($row, $col)
                $val = $cell.Value2
                $text = $cell.Text
                $formula = $cell.Formula
                if ($null -ne $val -or ($text -ne "" -and $null -ne $text)) {
                    $colLetter = switch($col) { 9 {"I"} 10 {"J"} 11 {"K"} }
                    Write-Host "  Cell ${colLetter}${row}: Text=[$text]  Value2=[$val]  Formula=[$formula]"
                }
            }
        }

        # Part 3: Search entire sheet for 'vorderingen'
        Write-Host "`n--- PART 3: Search for 'vorderingen' / 'Overige' in entire sheet ---" -ForegroundColor Green
        $usedRange = $ws.UsedRange
        $rowCount = $usedRange.Rows.Count
        $colCount = $usedRange.Columns.Count
        $startRow = $usedRange.Row
        $startCol = $usedRange.Column
        for ($r = $startRow; $r -le ($startRow + $rowCount - 1); $r++) {
            for ($c = $startCol; $c -le ($startCol + $colCount - 1); $c++) {
                $cell = $ws.Cells.Item($r, $c)
                $text = $cell.Text
                $val = $cell.Value2
                $formula = $cell.Formula
                $combined = "$text $val $formula"
                if ($combined -match "vorderin" -or $combined -match "Overige") {
                    $colLetter = ""
                    if ($c -le 26) { $colLetter = [char](64 + $c) }
                    else { $colLetter = [char](64 + [math]::Floor(($c-1)/26)) + [char](64 + (($c-1)%26+1)) }
                    Write-Host "  FOUND Cell ${colLetter}${r}: Text=[$text]  Value2=[$val]  Formula=[$formula]"
                }
            }
        }
    }

    $wb.Close($false)
    Write-Host "`nFile closed."
}

$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
Write-Host "`nDone." -ForegroundColor Cyan
