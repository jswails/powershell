#monitor local print queues
#%windir%\system32\printing_admin_scripts
#https://technet.microsoft.com/en-us/library/cc753980(WS.10).aspx
#Cscript Prnjobs  -l -p printer name
 $machinename = $env:COMPUTERNAME
 $err = ""
 $wipserver = "\\10.30.164.71\data-in"
  $datetime = Get-Date -Format "yyyyMMdd";
   $datetimefull = Get-Date -Format "yyyyMMddHHmmss";
 $prettydate = get-date
 $printername = (get-wmiobject Win32_Printer -filter "Default=TRUE").Name
 $user = $env:USERNAME

  $os = (Get-CimInstance Win32_OperatingSystem).version
 $proc = $env:PROCESSOR_ARCHITECTURE
 $imgver = [Environment]::GetEnvironmentVariable("imgver","machine")

 
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
           $messageparameters = @{
  Subject = "Printer Queue error found for $env:COMPUTERNAME "
  body = "Error found for $env:COMPUTERNAME on $prettydate  with logged on user: $user"
  from = "app_appenseinstaller.Application@StateAuto.com"
  to = "john.swails@stateauto.com"

  smtpserver = "smtprelay.corp.stateauto.com"
  }
  
 send-mailmessage @messageparameters -bodyashtml
     "$machinename,$err,$datetimefull,$user,$os,$proc,$imgver,$printername,$status" | set-content $wipserver\printerq\$machinename-$datetime.csv
     
     
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
           $messageparameters = @{
  Subject = "Printer Queue error found for $env:COMPUTERNAME "
  body = "Error found for $env:COMPUTERNAME on $prettydate  with logged on user: $user"
  from = "app_appenseinstaller.Application@StateAuto.com"
  to = "john.swails@stateauto.com"

  smtpserver = "smtprelay.corp.stateauto.com"
  }
  
 send-mailmessage @messageparameters -bodyashtml
     "$machinename,$err,$datetimefull,$user,$os,$proc,$imgver,$printername,$status" | set-content $wipserver\printerq\$machinename-$datetime.csv
     
     
     } else {
     # error was found for previous days
     }

  }


  }
