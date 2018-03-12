
 
$logName = 'Microsoft-Windows-PrintService/Operational'
# this enables the logging for the local printer
$log = New-Object System.Diagnostics.Eventing.Reader.EventLogConfiguration $logName
$log.IsEnabled=$true
$log.SaveChanges()
   $Events = Get-WinEvent $logName 
  # put in this count just to confirm things are processing
  $events.count

  foreach ($log in $events){
 
 #$printer = gwmi win32_printer
   # looks for errors in here
  #write-host $log.Message
  If ($Log.Message.Contains("will not print")){
    $date = get-date -Format "MM/dd/yyyy"
    $cotidie = $log.TimeCreated | select-string -Pattern "$date" 
    if($cotidie -ne $null){
    # if day matches error then it wont be null. proceed
    #alert there is an error
    write-host " error"
     $err = "error"
     $status = "na"
        if( $user -eq $null){
   $user = "na"
   }
    $emailerror = "yes"
   $lerrtime = $log.TimeCreated.Ticks | out-file  $smdir\printq.flag
     } else {
     # error was found for previous days
     }

  }
  If ($Log.Message.Contains("error")){
    $date = get-date -Format "MM/dd/yyyy"
    $cotidie = $log.TimeCreated | select-string -Pattern "$date"
    if($cotidie -ne $null){
    # if day matches error then it wont be null. proceed
    #alert there is an error
    write-host " error"
     $err = "error"
     $status = "na"
           if( $user -eq $null){
   $user = "na"
   }
 $emailerror = "yes"
     $lerrtime = $log.TimeCreated.Ticks | out-file  $smdir\printq.flag
     } else {
     # error was found for previous days
     }
      }
       }
 
  If($emailerror -eq "yes"){
  
           $messageparameters = @{
  Subject = "Printer Queue error found for $env:COMPUTERNAME "
  body = "Error found for $env:COMPUTERNAME on $prettydate  with logged on user: $user. </br> Please clear the errors in the print event logs so that the script wont keep reporting."
  from = "app_appenseinstaller.Application@StateAuto.com"
  to = "clientengineering@stateauto.com"

  smtpserver = "smtprelay.corp.stateauto.com"
  }
    if( $printername -eq $null){
   $printername = "na"
   }
 send-mailmessage @messageparameters -bodyashtml
     "$machinename,printq,$err,$datetimefull,$user,$os,$proc,$imgver,$printername,$status" | set-content $wipserver\printerq\$machinename-$datetime.csv
     }
     
