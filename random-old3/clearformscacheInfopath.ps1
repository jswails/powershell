$testoffice = "C:\Program Files\Microsoft Office\Office12\vviewer.dll"
if(Test-Path($testoffice)){
$officeinstalled = "Office 2007 installed"
C:\"Program Files"\"Microsoft Office"\Office12\InfoPath.exe /cache clearall
stop-process -processname infopath*
write-host " killed office 12"
}else{
C:\"Program Files (x86)"\"Microsoft Office"\Office14\InfoPath.exe /cache clearall
stop-process -processname infopath*
write-host "killed office 14"
}

