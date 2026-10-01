$ErrorActionPreference = 'Stop'

$files = @(
    'd:\GithubCopilotWS\DhR\Admin_Ritten_2022.xlsx',
    'd:\GithubCopilotWS\DhR\Admin_Ritten_2023.xlsx',
    'd:\GithubCopilotWS\DhR\Admin_Ritten_2024.xlsx'
)

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    foreach ($path in $files) {
        $workbook = $null
        $summarySheet = $null

        try {
            $workbook = $excel.Workbooks.Open($path, 0, $false)
            $summarySheet = $workbook.Worksheets.Item('Maandsamenvatting')

            $summarySheet.Range('B20').Formula = '=C16'
            $summarySheet.Range('B25').Formula = '=B20-B24'
            $summarySheet.Range('C26').Formula = '=B24+B25'
            $summarySheet.Range('B20:C26').NumberFormat = '0.00'

            $workbook.Application.CalculateFullRebuild()
            $workbook.Save()

            Write-Output ($path + ' | B20=' + $summarySheet.Range('B20').Text + ' | B24=' + $summarySheet.Range('B24').Text + ' | B25=' + $summarySheet.Range('B25').Text + ' | C26=' + $summarySheet.Range('C26').Text)
        }
        finally {
            if ($summarySheet) {
                [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($summarySheet)
            }

            if ($workbook) {
                $workbook.Close($true)
                [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
            }
        }
    }
}
finally {
    if ($excel) {
        $excel.Quit()
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
    }
}