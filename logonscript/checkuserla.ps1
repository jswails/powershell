$datetime = Get-Date -Format "yyyyMMddHHmm"; 
$log = "c:\temp\adminscriptdebug.txt"
$dir = "\\server\LocalAdmin\admin-sudofile.33"
$env:USERNAME | out-file c:\packages\logonscript\user.txt
$latest = Get-ChildItem -Path $dir 
$search = $env:COMPUTERNAME + ":" + $env:USERNAME
#$search
if (!(test-path("c:\packages\logonscript\allow.flag"))){
exit
}
$sel =  Select-String -Path $latest -Pattern "$search" 
$sel 
$testpath = test-path $dir
$adminrights = [Environment]::GetEnvironmentVariable("adminrights")
 $datetime | out-file -append $log
$adminrights | out-file -append $log
if ($testpath -eq $false)
{ "Testpath = false; stopping script" | out-file -append $log
exit}
if ($dir -eq $null) {
 $datetime | out-file -append $log
"unable to reach sudo file but script made it to execution so that means machine thinks its in the domain" | out-file -append $log 
"exiting script now" | out-file -append $log 
exit
}
 if ($sel -eq $null){
 $datetime | out-file -append $log
 "user not allowed"  | out-file -append $log
 " user and machine pairing was not found in the sudo file" | out-file -append $log
 [Environment]::SetEnvironmentVariable("adminrights", "no", "user")
 #check to see if user is part of local admin group. if it is remove it.
 $u = "domainname\" + "$env:USERNAME" 
 $n = net localgroup administrators | Where {$_ -like $u}

if ($n -eq $null){
$datetime | out-file -append c:\temp\adminscriptdebug.txt
 "user not there lets exit" | out-file -append $log
 " user was not found in the local administrators group locally on the machine" | out-file -append $log

 }
 else
 {
 $datetime | out-file -append $log
  " user needs to be removed" | out-file -append $log
  " User is part of local admin group but its not been allowed so now its been marked for deletion by the rest of the appsense node that follows" | out-file -append $log
   #check to see if user is part of local admin group. if it is remove it.
if ( $n -ieq $u ) {
write-host " n eq u" 
[Environment]::SetEnvironmentVariable("adminrights", "no", "user")
   }
}
 }
 else
 {
 $datetime | out-file -append $log
  " user allowed" | out-file -append $log
  " User was found in the sudo file and was not found in the local admin group locally on the machine so it is now set to be added by rest of appsense node that follows" | out-file -append $log

[Environment]::SetEnvironmentVariable("adminrights", "yes", "user")

  }

