# Debug script to check Excel cell values and formats

$excelPath = "C:\GithubCopilotWS\DhR\belasting 2025 analyse.xlsx"

Write-Host "Opening Excel file: $excelPath"

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $workbook = $excel.Workbooks.Open($excelPath, $false, $false)
    $worksheet = $workbook.Worksheets.Item("Transacties")
    
    Write-Host ""
    Write-Host "Checking first 5 data rows (rows 2-6):"
    Write-Host "="*100
    
    for ($row = 2; $row -le 6; $row++) {
        $cell1 = $worksheet.Cells.Item($row, 1)
        $cell8 = $worksheet.Cells.Item($row, 8)
        $cell10 = $worksheet.Cells.Item($row, 10)
        
        Write-Host ""
        Write-Host "Row $row:"
        Write-Host "  Column 1 (.Value): $($cell1.Value) (type: $(if($cell1.Value) {$cell1.Value.GetType().Name} else {'null'}))"
        Write-Host "  Column 1 (.Text):  $($cell1.Text) (type: $(if($cell1.Text) {$cell1.Text.GetType().Name} else {'null'}))"
        Write-Host "  Column 1 (.NumberFormat): $($cell1.NumberFormat)"
        Write-Host "  Column 8 (.Value): $($cell8.Value)"
        Write-Host "  Column 8 (.Text):  $($cell8.Text)"
        Write-Host "  Column 10 (.Value): $($cell10.Value)"
        Write-Host "  Column 10 (.Text):  $($cell10.Text)"
        
        # Try to parse the date
        if ($cell1.Text) {
            Write-Host "  Attempting to parse Column 1 as date..."
            try {
                $dateText = [string]$cell1.Text
                $culture = [System.Globalization.CultureInfo]::InvariantCulture
                $parsed = [datetime]::ParseExact($dateText, 'dd/MM/yyyy', $culture)
                Write-Host "    SUCCESS: Parsed as $($parsed.ToString('dd/MM/yyyy'))"
            } catch {
                Write-Host "    FAILED: $($_.Exception.Message)"
                
                # Try other formats
                $formats = @('dd-MM-yyyy', 'MM/dd/yyyy', 'dd.MM.yyyy', 'yyyy-MM-dd', 'd/M/yyyy')
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
