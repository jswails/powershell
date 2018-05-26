#monitor local print queues
#%windir%\system32\printing_admin_scripts
#https://technet.microsoft.com/en-us/library/cc753980(WS.10).aspx
#Cscript Prnjobs  -l -p printer name
 $machinename = $env:COMPUTERNAME
 $err = ""
 $wipserver = "\\server\data-in"
  $datetime = Get-Date -Format "yyyyMMdd";
   $datetimefull = Get-Date -Format "yyyyMMddHHmmss";
 $prettydate = get-date
 $printername = (get-wmiobject Win32_Printer -filter "Default=TRUE").Name
 $user = get-content C:\temp\user.txt
    if( $user -eq $null){
   $user = "na"
   }
 $smdir =  "C:\Packages\scriptmonitor"
  $os = (Get-CimInstance Win32_OperatingSystem).version
 $proc = $env:PROCESSOR_ARCHITECTURE
 $imgver = [Environment]::GetEnvironmentVariable("imgver","machine")
 $logName = 'Microsoft-Windows-PrintService/Operational'
# this enables the logging for the local printer
$log = New-Object System.Diagnostics.Eventing.Reader.EventLogConfiguration $logName
$log.IsEnabled=$true
$log.SaveChanges()

   if(test-path("c:\temp\printererror.log")){
   "print job log found " | Out-File -Append $smdir\bug.log
    xcopy c:\temp\printererror.log c:\temp\printererror.log-backup /y
       ri -Force c:\temp\printererror.log
       cscript C:\Windows\System32\Printing_Admin_Scripts\en-US\prnjobs.vbs -l > c:\temp\printererror.log
  $pronjob = Get-Content c:\temp\printererror.log | Select-String -Pattern "error"
    if ($pronjob -ne $null) {
    "found error in print job log" | Out-File -Append $smdir\bug.log
    $emailerror = "yes"
    $err = " prnjob found error"
    $status = "na"
    $pronjob = "true"
    xcopy c:\temp\printererror.log c:\temp\printererror.log-backup /y
    ri -Force c:\temp\printererror.log
                            }

   } else {
   cscript C:\Windows\System32\Printing_Admin_Scripts\en-US\prnjobs.vbs -l > c:\temp\printererror.log
   "created print job log" | Out-File -Append $smdir\bug.log
   " set email error to no and should exit" | Out-File -Append $smdir\bug.log
   $emailerror = "no" ; exit
   }
   if($pronjob -eq "true"){
   $err = " prnjob found error"
   "pronjob set to true" | Out-File -Append $smdir\bug.log

             $messageparameters = @{
  Subject = "Printer Queue error found for $env:COMPUTERNAME "
  body = "Error found for $env:COMPUTERNAME on $prettydate  with logged on user: $user. </br> Check the users machine for errors."
  from = "app_appenseinstaller.Application@StateAuto.com"
  to = "clientengineering@stateauto.com"

  smtpserver = "smtprelay.corp.stateauto.com"
  }
    if( $printername -eq $null){
   $printername = "na"
   }
 send-mailmessage @messageparameters -bodyashtml
     "$machinename,printq,$err,$datetimefull,$user,$os,$proc,$imgver,$printername,$status" | set-content $wipserver\printerq\$machinename-$datetime.csv
     exit
     }
