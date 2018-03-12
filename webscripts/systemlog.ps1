Param([string]$mach)


function Ping-Server {
   Param([string]$mach)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$mach'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

$result = Ping-Server $mach
if($result){
$syslog = get-eventlog -logname System -newest 50 -EntryType Error -computer $mach 
if ($syslog -eq $null){
" No errors found in System Logs"  | out-file e:\wamp\www\eventlog\$mach.system.csv
} else {
$syslog | select-object EventID, MachineName, EntryType, Message, Source, TimeGenerated, TimeWritten, Username |export-csv e:\wamp\www\eventlog\$mach.system.csv -notypeinformation
}

 
 } else {

 "Machine was unreachable. Either WMI is corrupt. Not on Network or Remote Access is Denied." | out-file e:\wamp\www\eventlog\$mach.system.csv 

 }
