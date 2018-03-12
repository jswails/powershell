$computername = "E9YPLXV1"
$a = Get-EventLog -log AppSense -InstanceId 9104,9105 -ComputerName $computername 
if ($a -eq $null) {
write-host " no match found"
} else {
$a | Select-Object  eventid,machinename,timegenerated | export-csv c:\batchjobs\pm\9104\$computername.csv -NoTypeInformation
}

(Get-winevent -listprovider microsoft-windows-Diagnostics-Performance).events | Format-Table id,description -AutoSize

(Get-WinEvent -ListProvider Microsoft-Windows-GroupPolicy).Events | Format-Table ID, Description -AutoSize
Get-WinEvent -LogName *performance*
| Where-Object {$_.logfilename -eq $logFileName}
 | Select-Object timecreated,message

Get-WinEvent -computername $computername -ProviderName microsoft-windows-Diagnostics-Performance  | Where-Object {$_.id -eq "203"}  | Select-Object timecreated,message | export-csv c:\batchjobs\pm\9104\$computername.csv -NoTypeInformation

$uno = Get-WinEvent -ProviderName microsoft-windows-Diagnostics-Performance  | Where-Object {$_.id -eq "101"}  | Select-Object timecreated,message | select-string -Pattern "File Name"
$uno = Get-WinEvent -ProviderName microsoft-windows-Diagnostics-Performance  | Where-Object {$_.id -eq "101"}  | Select-object message 


http://blogs.technet.com/b/heyscriptingguy/archive/2014/06/04/data-mine-the-windows-event-log-by-using-powershell-and-xml.aspx