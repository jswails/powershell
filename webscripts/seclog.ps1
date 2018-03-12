Param([string]$mach)


function Ping-Server {
   Param([string]$mach)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$mach'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

$result = Ping-Server $mach
if($result){
 $seclog = get-eventlog -logname security -newest 20 -EntryType Error -Computer $mach 
 if ($seclog -eq $null){
 "No errors found in Security Logs" | out-file e:\wamp\www\eventlog\$mach.security.csv 
 } else {
 $seclog | select-object EventID, MachineName, EntryType, Message, Source, TimeGenerated, TimeWritten, Username | export-csv e:\wamp\www\eventlog\$mach.security.csv -notypeinformation
 }
 } else {
   "Machine was unreachable. Either WMI is corrupt. Not on Network or Remote Access is Denied." | out-file e:\wamp\www\eventlog\$mach.security.csv 
 }