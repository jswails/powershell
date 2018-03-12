
$servers = Get-Content ".\servers.txt";

$i = 0;
foreach($server in $servers)
{
function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   Write-Progress -Activity "ping result" $pingresult.statuscode
   if($pingresult.statuscode -ne 0) {stop-process -processname xde* ; $i++
} else { $i=0
}
ping-server $server
Write-Progress $i
}
if ($i=0) {
ping-server $server
}
$i++
}



