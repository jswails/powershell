 Param([string]$computer)
 $a = get-service -displayname "AppSense Client Communications Agent" -computer $computer
  $a | select-object name | export-csv -path e:\wamp\www\appsense\$computer-service.csv -NoTypeInformation
 get-service -displayname "AppSense Client Communications Agent" -computer $computer | stop-service

 $c = get-service -displayname "AppSense Client Communications Agent" -computer $computer

  $c | select-object status | export-csv -Append -path e:\wamp\www\appsense\$computer-service.csv -NoTypeInformation
 
 get-service -displayname "AppSense Client Communications Agent" -computer $computer | start-service
  $b = get-service -displayname "AppSense Client Communications Agent" -computer $computer
  $b | select-object status | export-csv -Append -path e:\wamp\www\appsense\$computer-service.csv -NoTypeInformation

