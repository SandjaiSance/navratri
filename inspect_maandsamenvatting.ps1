$ErrorActionPreference = 'Stop'
$outFile = 'DhR\maandsamenvatting_inspect.txt'
function Dump-Range {
    param($Sheet,[int]$RowStart,[int]$RowEnd,[int]$ColStart,[int]$ColEnd)
    for($r=$RowStart; $r -le $RowEnd; $r++){
        for($c=$ColStart; $c -le $ColEnd; $c++){
            $cell = $Sheet.Cells.Item($r,$c)
            $text = [string]$cell.Text
            $formula = [string]$cell.Formula
            if(-not [string]::IsNullOrWhiteSpace($text) -or $formula.StartsWith('=')){
                $addr = $cell.Address($false,$false)
                "{0}`tText={1}`tFormula={2}" -f $addr,$text,($(if($formula.StartsWith('=')){$formula}else{''}))
            }
        }
    }
}
$lines = New-Object System.Collections.Generic.List[string]
$excel = $null
try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $files = @(
        @{Year=2021; Path='DhR\Admin_Ritten_2021.xlsx'; IncludeTotal=$false},
        @{Year=2022; Path='DhR\Admin_Ritten_2022.xlsx'; IncludeTotal=$true},
        @{Year=2023; Path='DhR\Admin_Ritten_2023.xlsx'; IncludeTotal=$true},
        @{Year=2024; Path='DhR\Admin_Ritten_2024.xlsx'; IncludeTotal=$true}
    )
    foreach($file in $files){
        $wb = $null
        $sheet = $null
        try {
            $wb = $excel.Workbooks.Open((Join-Path (Get-Location) $file.Path),0,$true)
            $sheet = $wb.Worksheets.Item('Maandsamenvatting')
            $lines.Add(("===== {0} =====" -f $file.Path))
            foreach($line in (Dump-Range -Sheet $sheet -RowStart 19 -RowEnd 26 -ColStart 1 -ColEnd 3)){ $lines.Add($line) }
            if($file.IncludeTotal){
                $lines.Add('-- Row16 A:E --')
                foreach($line in (Dump-Range -Sheet $sheet -RowStart 16 -RowEnd 16 -ColStart 1 -ColEnd 5)){ $lines.Add($line) }
            }
            $b25Formula = [string]$sheet.Range('B25').Formula
            $b25FormulaR1C1 = [string]$sheet.Range('B25').FormulaR1C1
            $dependsOnB20 = $false
            if($b25Formula.StartsWith('=')){
                if($b25Formula -match '(^|[^A-Z0-9_])B20([^0-9]|$)' -or $b25FormulaR1C1 -match 'R20C2'){
                    $dependsOnB20 = $true
                }
            }
            $lines.Add(("B20`tText={0}`tFormula={1}" -f ([string]$sheet.Range('B20').Text), ([string]$sheet.Range('B20').Formula)))
            $lines.Add(("B25`tText={0}`tFormula={1}`tFormulaR1C1={2}`tDependsOnB20={3}" -f ([string]$sheet.Range('B25').Text), $b25Formula, $b25FormulaR1C1, $dependsOnB20))
            $lines.Add('')
        }
        finally {
            if($sheet){ [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($sheet) }
            if($wb){ $wb.Close($false) | Out-Null; [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($wb) }
        }
    }
    $lines | Set-Content -Path $outFile -Encoding UTF8
    Get-Content $outFile
}
finally {
    if($excel){ $excel.Quit(); [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) }
    [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}
