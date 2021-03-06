$getnamefile = "c:\temp\user.txt"
$tada = get-content $getnamefile
$username = $tada
$getrealnamefile = "c:\temp\realname.txt"
$rn = get-content $getrealnamefile
$realname = $rn
#start date insert into variable
 $y = Get-Date 
$a = $y.Ticks
$5dprev = $y.AddDays(-5)
$b = $5dprev.Ticks
#last sync time and date
$lastsyncvar = [Environment]::GetEnvironmentVariable("LastSync","machine")
if ($lastsyncvar -ieq 0 ) {
 # 0 means never ran a sync so need to force a sync
C:\scripts\FreeFileSync\sync.vbs
[Environment]::SetEnvironmentVariable("LastSync", $a, "machine")
}
#check current date vs variable date to get up to 5 days
 #$checktime = $a - $lastsyncvar
 $checktime = 43200000000000
if ($checktime -igt 4320000000000) {
#if 5 days do check script below
#put in ad script function that gets the real name off of ad from the username to put in body message
$machine = $env:COMPUTERNAME
#put computername in body of email as well
$dir = "C:\temp\sync.log"
$latest = Get-ChildItem -Path $dir | Sort-Object LastAccessTime -Descending | Select-Object -First 1
$synclog = "c:\temp\sync.log\" + $latest.name
$sel =  Select-String -Path $synclog -Pattern "Synchronization completed with errors" 
$emailerror = get-content $synclog
$finalerror = 0
$sel
 if ($sel -eq $null){
 "no error found  no email will be sent" | out-file -append "c:\temp1\noerror-debugging.log"
  exit
 }
 else {
 $checkge = Select-String -Path $synclog -Pattern "ge_support"
  if ($checkge -eq $null) {
  write-host " ge_support not there"
  } else {
  $finalerror = 2
  }
  $checkASuser =   select-string -path $synclog -pattern "app_appenseinstaller"
  if ($checkASuser -eq $null) {
  write-host "appsenseinstaller not there"
    } else {
    $finalerror = 2
    }
  $checkUNC = select-string -path $synclog -pattern "\\\\"
  if ($checkUNC -eq $null) {
  write-host "folder redirect not there"
  } else {
$reporterror = " This machine has folder redirection"
$finalerror = 1
  }
  $checkerr3 = select-string -path $synclog -pattern "error code 3"
  if ($checkerr3 -eq $null) {
 write-host "error 3 not found"
  
  } else {
   "error 3 ; not on network at time of run; no email will be sent" | out-file -append "c:\temp1\error3-noemail.log"
   }
  $checkerr5 = select-string -path $synclog -pattern "error code 5"
  if ($checkerr5 -eq $null) {
write-host " error 5 not found"
  } else {
    $reporterror = " MyDoc duplicates issue or unknown access error"
    $finalerror = 1
    }
  $checkwarningdifferent = select-string -path $synclog -pattern "Warning: The following folders are significantly different"
  if ($checkwarningdifferent -eq $null) {
 write-host " megdiff not found"
  
  } else {
     "mega diff issue; no email will be sent" | out-file -append "c:\temp1\megadiff-noemail.log"
     }
  
    $checkfirstsync = select-string -path $synclog -pattern "You can ignore this error to consider each folder as empty"
  if ($checkfirstsync -eq $null) {
write-host "first sync not found"
  
  } else {
      "first time or full sync; no email will be sent" | out-file -append "c:\temp1\firstorfull-noemail.log"
      }
      
      $finalerror
      $reporterror
  
  if ($finalerror -eq 1) {
   # email support script insert here
  $messageparameters = @{
  Subject = "Sync failed  for $realname"
  body = "Sync failed after 5 days for $env:COMPUTERNAME and $username : $realname </br> $reporterror </br> $emailerror"
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "outlookdc1.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml
#send-mailmessage -To john.swails@stateauto.com -from "john.swails@StateAuto.com" -smtpserver OutlookDC1.corp.stateauto.com -Subject "test" -body $body | out-string
 # update start date variable so as to only warn once every 5 days.
  [Environment]::SetEnvironmentVariable("LastSync", $a, "machine")
    }
  }
  } else{
  exit 
  }
  
  
  
  
    # if not 5 days then exit.