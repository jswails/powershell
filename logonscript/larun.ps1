# local admin process
# this runs as appsense installer account on logon. this assumes the logonscript has run the checkuser ps1.
$datetime = Get-Date -Format "yyyyMMddHHmm"; 
$log = "c:\temp\adminscriptdebug.txt"
$dir = "\\server\LocalAdmin\admin-sudofile.33"
$latest = Get-ChildItem -Path $dir 
$search = $env:COMPUTERNAME + ":" + $env:USERNAME
#$search
if (!(test-path("c:\packages\logonscript\allow.flag"))){
exit
}
$sel =  Select-String -Path $latest -Pattern "$search" 
$sel 
$testpath = test-path $dir
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
 $logondir =  "C:\Packages\logonscript"

 $getrights = [Environment]::GetEnvironmentVariable("adminrights","user")

 if ($getrights = "no") {
powershell.exe -file $logondir\removeuserla.ps1
 } 
  if ($getrights = "yes") {
powershell.exe -file $logondir\addla.ps1
 } 
