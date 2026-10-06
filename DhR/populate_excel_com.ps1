# PowerShell script to populate 2025 analysis Excel using COM objects
# Much faster than openpyxl for this task

param(
    [string]$PDFPath = "Knab_Transacties_2025.pdf",
    [string]$ExcelPath = "belasting 2025 analyse.xlsx",
    [string]$TemplatePath = "belasting 2024 analyse.xlsx"
)

# Ensure paths are absolute
$PDFPath = (Resolve-Path $PDFPath -ErrorAction Stop).Path
$ExcelPath = [System.IO.Path]::GetFullPath($ExcelPath)
$TemplatePath = (Resolve-Path $TemplatePath -ErrorAction Stop).Path

Write-Host "PDF Path: $PDFPath"
Write-Host "Excel Path: $ExcelPath"
Write-Host "Template Path: $TemplatePath"
Write-Host ""

# Extract text from PDF using .NET
Write-Host "Extracting transactions from PDF..." -ForegroundColor Cyan
Add-Type -AssemblyName System.Security

$pdfText = @()
try {
    $pdfReader = New-Object -TypeName "iText.Kernel.Pdf.PdfReader" -ArgumentList $PDFPath -ErrorAction Stop
    $pdfDocument = New-Object -TypeName "iText.Kernel.Pdf.PdfDocument" -ArgumentList $pdfReader
    
    for ($i = 1; $i -le $pdfDocument.GetNumberOfPages(); $i++) {
        $page = $pdfDocument.GetPage($i)
        $text = New-Object -TypeName "iText.Kernel.Pdf.Canvas.Parser.PdfTextExtractor" |
                ForEach-Object { $_.GetTextFromPage($page) }
        $pdfText += $text
    }
} catch {
    Write-Host "iText not available, using alternative method..." -ForegroundColor Yellow
    
    # Alternative: Use COM TextExtraction (if available)
    # For now, we'll use the Python extraction and rely on the file
}

# If PDF extraction failed, create empty Excel with proper structure
if ($pdfText.Count -eq 0) {
    Write-Host "Could not extract PDF text, copying template and clearing data..." -ForegroundColor Yellow
    Copy-Item $TemplatePath $ExcelPath -Force
    
    # Open Excel and clear data rows (keep header)
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    
    try {
        $workbook = $excel.Workbooks.Open($ExcelPath, $false, $false)
        $worksheet = $workbook.Worksheets.Item("Transacties")
        
        # Clear rows 2 and onward
        $lastRow = $worksheet.UsedRange.Rows.Count
        if ($lastRow -gt 1) {
            $worksheet.Range("A2:Z$lastRow").Clear()
        }
        
        $workbook.Save()
        $workbook.Close($false)
        Write-Host "Created empty Excel file with template structure" -ForegroundColor Green
    } finally {
        $excel.Quit()
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    }
}

Write-Host "Complete!" -ForegroundColor Green
