﻿$getnamefile = "c:\temp\user.txt"
$tada = get-content $getnamefile
$name = $tada

$getrealname = "c:\temp\realname.txt"
$moretada = get-content $getrealname
$realname = $moretada
$realname | out-file -append c:\temp\scriptdebug.txt
#start date insert into variable
 $env:COMPUTERNAME | out-file -append c:\temp\scriptdebug.txt 
$y = Get-Date 
$a = $y.Ticks
#$5dprev = $y.AddDays(-5)
#$b = $5dprev.Ticks
#last sync time and date
$lastsyncvar = [Environment]::GetEnvironmentVariable("LastSync","machine")
$lastsyncvar | out-file -append c:\temp\scriptdebug.txt 
if ($lastsyncvar -ieq 0 ) {
# 0 means never ran a sync so need to force a sync
"running sync" | out-file -append c:\temp\scriptdebug.txt 
C:\scripts\FreeFileSync\sync.vbs
[Environment]::SetEnvironmentVariable("LastSync", $a, "machine")
}
#check current date vs variable date to get up to 5 days
# 
$checktime = $a - $lastsyncvar
$checktime | out-file -append c:\temp\scriptdebug.txt 
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
$sel
 if ($sel -eq $null){
 write-host "no error" | out-file -append c:\temp\scriptdebug.txt 
 }
 else
 {
  write-host " error found" | out-file -append c:\temp\scriptdebug.txt 
  # email support script insert here

  $messageparameters = @{
  Subject = "$realname"
  body = "Sync failed after 5 days for Computer: $env:COMPUTERNAME </br>$emailerror "
  from = "app_.com"
  to = "a.com"
  smtpserver = ""
  }
  send-mailmessage @messageparameters -bodyashtml



  [Environment]::SetEnvironmentVariable("LastSync", $a, "machine")
 [Environment]::SetEnvironmentVariable("LastSync", $a, "machine") | out-file -append c:\scriptdebug.txt 
 
   }
  }
  
  # if not 5 days then exit.
