$ErrorActionPreference = 'Stop'

$newHourRate  = [decimal]37.5
$uren2023     = 23
$uren2024     = 24
$vord2023     = [double]($uren2023 * $newHourRate)   # 862.50
$vord2024     = [double]($uren2024 * $newHourRate)   # 900.00

$files = @(
    'd:\GithubCopilotWS\DhR\Admin_Ritten_2023.xlsx',
    'd:\GithubCopilotWS\DhR\Admin_Ritten_2024.xlsx'
)

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    foreach ($path in $files) {
        $workbook = $null
        $ws = $null
        try {
            $workbook = $excel.Workbooks.Open($path, 0, $false)
            $ws = $workbook.Worksheets.Item('Maandsamenvatting')
            $yr = [int]([System.IO.Path]::GetFileNameWithoutExtension($path).Split('_')[-1])

            # 1. Uurtarief E3:E16 → 37.50
            for ($r = 3; $r -le 16; $r++) {
                $ws.Range('E' + $r).Value2 = [double]$newHourRate
            }

            # 2. Maandinkomen C3:C14 omzetten naar formule =Br*Er
            for ($r = 3; $r -le 14; $r++) {
                $ws.Range('C' + $r).Formula = '=B' + $r + '*E' + $r
            }

            # 3. Overige vorderingen
            if ($yr -eq 2023) {
                # J10 = closing 2023 = 23 × 37.50 = 862.50 (breek =K10 formule, K10 blijft historisch)
                $ws.Range('J10').Value2 = $vord2023
            }
            elseif ($yr -eq 2024) {
                # Label
                $ws.Range('I10').Value = 'Overige vorderingen'
                # K10 = opening 2024 = afsluiting 2023 = 862.50
                $ws.Range('K10').Value2 = $vord2023
                # K11 = =K10
                $ws.Range('K11').Formula = '=K10'
                # J10 = closing 2024 = 24 × 37.50 = 900 (breek =K10 formule)
                $ws.Range('J10').Value2 = $vord2024
            }

            $workbook.Application.CalculateFullRebuild()
            $workbook.Save()

            Write-Output ("YEAR=$yr | E3=$($ws.Range('E3').Text) | C16=$($ws.Range('C16').Text) | B20=$($ws.Range('B20').Text) | B25=$($ws.Range('B25').Text) | I10='$($ws.Range('I10').Text)' | J10=$($ws.Range('J10').Text) | K10=$($ws.Range('K10').Text)")
        }
        finally {
            if ($ws)       { [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($ws) }
            if ($workbook) { $workbook.Close($true); [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook) }
        }
    }
}
finally {
    if ($excel) { $excel.Quit(); [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) }
    [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}
