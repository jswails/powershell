# Get server list
$servers = Get-Content "h:\powershell\sccmservers.txt";
$datetime = Get-Date -Format "yyyyMMddHHmmss";

foreach($server in $servers)
{
#get service status
    $service = get-service ccmexec -computername $server
    $servicestatus = $service.status
    write-host $server  $servicestatus
    }