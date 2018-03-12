$getcc = get-service -displayname "AppSense Client Communications Agent"  | Select-Object status
$getccs = $getcc.status
if ($getccs -eq "stopped" ){
write-host "cca stopped"
}
if ($getccs -eq "running" ){
write-host "cca running"
}