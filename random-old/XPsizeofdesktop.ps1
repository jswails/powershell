
$User = Read-Host “Enter the Users’ Logon Name”
$machine = Read-host " Enter Machines Name"
$colItems = (gci "\\$machine\c$\Documents and Settings\"$User"\Desktop\" | Measure-Object -property length -sum)
"{0:N2}" -f ($colItems.sum / 1MB) + " MB"

