$erroractionpreference = "SilentlyContinue"

$a = New-Object -comobject Excel.Application
$a.visible = $True 

$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

$c.Cells.Item(1,1) = "Machine Name"
$c.Cells.Item(1,2) = "Network Adapter"
$c.Cells.Item(1,3) = "Driver Provider"
$c.Cells.Item(1,4) = "Driver Date"
$c.Cells.Item(1,5) = "Driver Version"
$c.Cells.Item(1,6) = "Digital Signer"
$c.Cells.Item(1,7) = "Report Time Stamp"

$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True

$intRow = 2

Foreach ($strComputer in get-content C:\MachineList.Txt)
{
$c.Cells.Item($intRow,1) = $strComputer
$PnP = Get-WMIObject Win32_PnPSignedDriver -computer $strcomputer |where {$_.Devicename -like "intel*"}
Foreach ($Nic in $PnP)
{
$c.Cells.Item($intRow,2) = $Nic.Devicename
$c.Cells.Item($intRow,3) = $Nic.DriverProviderName

$strDate = $Nic.DriverDate
$z = $strDate.substring(0,8)
$dtyear = $z.substring(0,4)
$dtmonth = $z.substring(4,2)
$dtday = $z.substring(6,2)

$driverdate = "$dtmonth" + "/"+ "$dtday" + "/" + "$dtyear"

$c.Cells.Item($intRow,4) = [DateTime]$DriverDate
$c.Cells.Item($intRow,5) = $Nic.DriverVersion
$c.Cells.Item($intRow,6) = $Nic.Signer
$c.Cells.Item($intRow,7) = Get-Date
$intRow = $intRow + 1
}
}
$d.EntireColumn.AutoFit()
cls
