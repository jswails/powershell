# need to setup flag for first sync

#start date insert into variable

$y = Get-Date 
$a = $y.Ticks
$5dprev = $y.AddDays(-5)
$b = $5dprev.Ticks
#last sync time and date
sleep
$lastsyncvar
if ($lastsyncvar -ieq 0 ) {
# 0 means never ran a sync so need to force a sync
C:\scripts\FreeFileSync\sync.vbs
}
#check current date vs variable date to get up to 5 days
# 
$checktime = $a - $lastsyncvar
$checktime
if ($checktime -igt 4320000000000) {

#if 5 days do check script below
$name = $env:tmp-user

#put in ad script function that gets the real name off of ad from the username to put in body message
$machine = $env:COMPUTERNAME
#put computername in body of email as well

$dir = "C:\temp\sync.log"
$latest = Get-ChildItem -Path $dir | Sort-Object LastAccessTime -Descending | Select-Object -First 1
$synclog = "c:\temp\sync.log\" + $latest.name
$sel =  Select-String -Path $synclog -Pattern "Synchronization completed with errors" 

$sel
 if ($sel -eq $null){
 write-host "no error"
 }
 else
 {
  write-host " error found" 
  # email support script insert here

  $messageparameters = @{
  Subject = "Sync failed after 5 days for $env:COMPUTERNAME.$name"
  body = "Sync failed after 5 days for $env:COMPUTERNAME.$NAME"
  from = "app_appenseinstaller.application@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "OutlookDC1.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml


#send-mailmessage -To john.swails@stateauto.com -from "john.swails@StateAuto.com" -smtpserver OutlookDC1.corp.stateauto.com -Subject "test" -body $body | out-string
 # update start date variable so as to only warn once every 5 days.
 [Environment]::SetEnvironmentVariable("LastSync", $a, "User")
 
   }
  }
  
  # if not 5 days then exit.