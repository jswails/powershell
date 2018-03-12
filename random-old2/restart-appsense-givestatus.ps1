 Param([string]$computer)
 get-service -displayname "AppSense Client Communications Agent" -computer $computer | stop-service

 $a =  get-service -displayname "AppSense Client Communications Agent" -computer $computer
  $a | select-object status | export-csv -path e:\wamp\www\appsense\$computer-service.csv -NoTypeInformation
 
 get-service -displayname "AppSense Client Communications Agent" -computer $computer | start-service
  $b =  get-service -displayname "AppSense Client Communications Agent" -computer $computer
  $b | select-object status | export-csv -Append -path e:\wamp\www\appsense\$computer-service.csv -NoTypeInformation

  $machine = 'L780YDS1'


   get-service -displayname 'sms agent host' -ComputerName $machine | start-service
  $gs =  get-service -displayname 'sms agent host' | Select-Object status
  $gss = $gs.Status
  if ($gss -eq "stopped") {
  write-host "sms stopped"
  }

