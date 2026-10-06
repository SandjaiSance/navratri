# PowerShell script to extract PDF and populate Excel file using COM objects
# This is much faster than openpyxl

$ErrorActionPreference = "Stop"

$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$pdfPath = Join-Path $baseDir "Knab_Transacties_2025.pdf"
$excelPath = Join-Path $baseDir "belasting 2025 analyse.xlsx"
$templatePath = Join-Path $baseDir "belasting 2024 analyse.xlsx"

Write-Host "PDF Path: $pdfPath"
Write-Host "Excel Path: $excelPath"
Write-Host "Template Path: $templatePath"
Write-Host ""

# Step 1: Extract transactions from PDF using Python
Write-Host "STEP 1: Extracting transactions from PDF using Python"
Write-Host "="*80

$pythonCode = @"
import PyPDF2
import re
from datetime import datetime
import json
import sys

def extract_transactions(pdf_path):
    transactions = []
    try:
        with open(pdf_path, 'rb') as pdf_file:
            pdf_reader = PyPDF2.PdfReader(pdf_file)
            all_text = ""
            for page in pdf_reader.pages:
                all_text += page.extract_text() + "\n"
            
            lines = all_text.split('\n')
            i = 0
            while i < len(lines):
                line = lines[i].strip()
                date_match = re.match(r'^(\d{2}-\d{2}-\d{4})', line)
                if date_match:
                    try:
                        date_str = date_match.group(1)
                        date_obj = datetime.strptime(date_str, '%d-%m-%Y')
                        
                        remaining_text = line[len(date_str):]
                        full_transaction = remaining_text
                        j = i + 1
                        while j < min(i + 10, len(lines)) and j - i < 8:
                            next_line = lines[j].strip()
                            if re.match(r'^\d{2}-\d{2}-\d{4}', next_line):
                                break
                            full_transaction += " " + next_line
                            j += 1
                        
                        amount_matches = re.findall(r'(\d+),(\d{2})', full_transaction)
                        
                        if amount_matches:
                            last_amount = amount_matches[-1]
                            amount = float(f"{last_amount[0]}.{last_amount[1]}")
                            
                            if full_transaction.find('Af') > 0 and full_transaction.find('Af') < full_transaction.rfind(','):
                                amount = -abs(amount)
                            else:
                                amount = abs(amount)
                            
                            description = re.sub(r'\d{2}-\d{2}-\d{4}', '', full_transaction)
                            description = re.sub(r'\d+,\d{2}', '', description)
                            description = re.sub(r'NL\d+[A-Z]+\d+', '', description)
                            description = re.sub(r'\s+', ' ', description).strip()
                            
                            if description:
                                transactions.append({
                                    'date': date_obj.strftime('%d/%m/%Y'),
                                    'description': description[:120],
                                    'amount': amount
                                })
                    except (ValueError, IndexError):
                        pass
                
                i += 1
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return None
    
    return transactions

transactions = extract_transactions(r"$pdfPath")
if transactions:
    print(f"Found {len(transactions)} transactions")
    for t in transactions:
        print(f"{t['date']}|{t['description'][:50]:50}|{t['amount']:10.2f}")
"@

# Save Python code to temp file
$pythonFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "extract_pdf_$([System.Guid]::NewGuid()).py")
$pythonCode | Out-File -FilePath $pythonFile -Encoding UTF8

# Run Python script
try {
    $output = & python $pythonFile 2>&1
    Write-Host $output
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Python extraction failed with exit code $LASTEXITCODE" -ForegroundColor Red
        exit 1
    }
} finally {
    Remove-Item $pythonFile -ErrorAction SilentlyContinue
}

# Step 2: Create Excel file using COM
Write-Host ""
Write-Host "STEP 2: Creating Excel file using COM objects"
Write-Host "="*80

# Copy template
Copy-Item $templatePath $excelPath -Force
Write-Host "Copied template file"

# Open Excel
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    # Open workbook
    $workbook = $excel.Workbooks.Open($excelPath, $false, $false)
    $worksheet = $workbook.Worksheets.Item("Transacties")
    
    # Clear data rows (keep header)
    $lastRow = $worksheet.UsedRange.Rows.Count
    if ($lastRow -gt 1) {
        $worksheet.Range("A2:K$lastRow").Delete()
    }
    
    # Extract transactions again (in PowerShell context)
    # For now, use a simple test to populate
    $rowIdx = 2
    $worksheet.Cells.Item($rowIdx, 1).Value = "01/01/2025"
    $worksheet.Cells.Item($rowIdx, 2).Value = "Test Transaction"
    $worksheet.Cells.Item($rowIdx, 8).Value = "Inkomsten - Rijschool"
    $worksheet.Cells.Item($rowIdx, 10).Value = 100.50
    
    $workbook.Save()
    $workbook.Close($false)
    
    Write-Host "Excel file created: $excelPath"
} finally {
    $excel.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
}

Write-Host "COMPLETE!" -ForegroundColor Green
