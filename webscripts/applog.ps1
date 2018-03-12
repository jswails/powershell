Param([string]$mach)


function Ping-Server {
   Param([string]$mach)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$mach'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

$result = Ping-Server $mach
if($result){
 $applog = get-eventlog -logname Application -newest 50 -EntryType Error -computer $mach 
 if ($applog -eq $null) {
 " No errors found in Application Logs"  | out-file e:\wamp\www\eventlog\$mach.application.csv
 } else {
 $applog | select-object EventID, MachineName, EntryType, Message, Source, TimeGenerated, TimeWritten, Username | export-csv e:\wamp\www\eventlog\$mach.application.csv -notypeinformation
 }
 } else {
  "Machine was unreachable. Either WMI is corrupt. Not on Network or Remote Access is Denied." | out-file e:\wamp\www\eventlog\$mach.application.csv 
 }