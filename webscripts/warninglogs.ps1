Param([string]$mach)


function Ping-Server {
   Param([string]$mach)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$mach'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

$result = Ping-Server $mach
if($result){
$syslog = get-eventlog -logname System -newest 50 -EntryType warning -computer $mach 
if ($syslog -eq $null){
" No errors found in System Logs"  | out-file e:\wamp\www\eventlog\$mach.warn.system.csv
} else {
$syslog | export-csv e:\wamp\www\eventlog\$mach.warn.system.csv -notypeinformation
}

 $applog = get-eventlog -logname Application -newest 50 -EntryType warning -computer $mach 
 if ($applog -eq $null) {
 " No errors found in Application Logs"  | out-file e:\wamp\www\eventlog\$mach.warn.application.csv
 } else {
 $applog | export-csv e:\wamp\www\eventlog\$mach.warn.application.csv -notypeinformation
 }

 $seclog = get-eventlog -logname security -newest 20 -EntryType warning -Computer $mach 
 if ($seclog -eq $null){
 "No errors found in Security Logs" | out-file e:\wamp\www\eventlog\$mach.warn.security.csv 
 } else {
 $seclog | export-csv e:\wamp\www\eventlog\$mach.warn.security.csv -notypeinformation
 }
 } else {

 "Machine was unreachable. Either WMI is corrupt. Not on Network or Remote Access is Denied." | out-file e:\wamp\www\eventlog\$mach.warn.system.csv 
  "Machine was unreachable. Either WMI is corrupt. Not on Network or Remote Access is Denied." | out-file e:\wamp\www\eventlog\$mach.warn.application.csv 
   "Machine was unreachable. Either WMI is corrupt. Not on Network or Remote Access is Denied." | out-file e:\wamp\www\eventlog\$mach.warn.security.csv 
 }
