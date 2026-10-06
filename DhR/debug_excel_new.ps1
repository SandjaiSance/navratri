# Debug script to check Excel cell values from belasting 2025 analyse.xlsx

$excelPath = "C:\GithubCopilotWS\DhR\belasting 2025 analyse.xlsx"

Write-Host "Opening Excel file: $excelPath"

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $workbook = $excel.Workbooks.Open($excelPath, $false, $false)
    $worksheet = $workbook.Worksheets.Item("Transacties")
    
    Write-Host ""
    Write-Host "Checking first 10 data rows (rows 2-11):"
    Write-Host "="*120
    
    for ($row = 2; $row -le 11; $row++) {
        $cell1 = $worksheet.Cells.Item($row, 1)
        $cell2 = $worksheet.Cells.Item($row, 2)
        $cell8 = $worksheet.Cells.Item($row, 8)
        $cell10 = $worksheet.Cells.Item($row, 10)
        
        Write-Host ""
        Write-Host "Row $row:"
        Write-Host "  Col 1 .Value: '$($cell1.Value)' (type: $(if($cell1.Value) {$cell1.Value.GetType().Name} else {'[NULL]'}))"
        Write-Host "  Col 1 .Text:  '$($cell1.Text)' (type: $(if($cell1.Text) {$cell1.Text.GetType().Name} else {'[NULL]'}))"
        Write-Host "  Col 2: $($cell2.Value) (first 50 chars)"
        Write-Host "  Col 8: $($cell8.Value)"
        Write-Host "  Col 10 .Value: $($cell10.Value)"
        Write-Host "  Col 10 .Text:  $($cell10.Text)"
        
        # Try to parse the date
        if ($cell1.Text) {
            $dateText = [string]$cell1.Text
            Write-Host "  Attempting to parse date text: '$dateText'"
            try {
                $culture = [System.Globalization.CultureInfo]::InvariantCulture
                $parsed = [datetime]::ParseExact($dateText, 'dd/MM/yyyy', $culture)
                Write-Host "    SUCCESS: Parsed as $($parsed.ToString('dd/MM/yyyy'))"
            } catch {
                Write-Host "    FAILED with dd/MM/yyyy: $($_.Exception.Message)"
                
                # Try alternative formats
                $formats = @('d/M/yyyy', 'dd-MM-yyyy', 'yyyy-MM-dd', 'MM/dd/yyyy', 'dd.MM.yyyy', 'ddMMyyyy')
                foreach ($fmt in $formats) {
                    try {
                        $parsed = [datetime]::ParseExact($dateText, $fmt, $culture)
                        Write-Host "    SUCCESS with format '$fmt': $($parsed.ToString('dd/MM/yyyy'))"
                        break
                    } catch {}
                }
            }
        }
    }
    
    $workbook.Close($false)
} finally {
    $excel.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
}

Write-Host ""
Write-Host "Done!"
