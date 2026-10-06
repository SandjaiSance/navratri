Set objExcel = CreateObject("Excel.Application")
objExcel.Visible = False
Set objWorkbook = objExcel.Workbooks.Open("C:\GithubCopilotWS\DhR\Admin_Ritten_2022.xlsx")
WScript.Echo "File opened successfully: " & "C:\GithubCopilotWS\DhR\Admin_Ritten_2022.xlsx"
objWorkbook.Close False
objExcel.Quit
Set objWorkbook = Nothing
Set objExcel = Nothing
