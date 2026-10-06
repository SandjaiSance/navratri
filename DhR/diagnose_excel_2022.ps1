# Diagnostic script to understand Excel structure

$excelPath = 'C:\GithubCopilotWS\DhR\Admin_Ritten_2022.xlsx'

Write-Host "Opening: $excelPath"
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false

try {
    $workbook = $excel.Workbooks.Open($excelPath)
    
    Write-Host "Number of sheets: $($workbook.Sheets.Count)"
    
    for ($sheetNum = 1; $sheetNum -le $workbook.Sheets.Count; $sheetNum++) {
        $ws = $workbook.Sheets($sheetNum)
        Write-Host ""
        Write-Host "=== Sheet $($sheetNum): $($ws.Name) ==="
        
        $usedRange = $ws.UsedRange
        $maxRow = $usedRange.Rows.Count
        $maxCol = $usedRange.Columns.Count
        
        Write-Host "Dimensions: $maxRow rows x $maxCol columns"
        Write-Host ""
        Write-Host "First 8 rows, first 12 columns:"
        
        for ($row = 1; $row -le [Math]::Min(8, $maxRow); $row++) {
            $line = "Row $($row): "
            for ($col = 1; $col -le [Math]::Min(12, $maxCol); $col++) {
                $val = $ws.Cells($row, $col).Value()
                if ($null -ne $val) {
                    $line += "[C$col=$val] "
                }
            }
            Write-Host $line
        }
    }
}
catch {
    Write-Host "ERROR: $_"
}
finally {
    $workbook.Close($false)
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
    Remove-Variable excel -ErrorAction SilentlyContinue
}
