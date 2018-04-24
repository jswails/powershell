[cmdletbinding()]
Param
([switch]$debugger)
if($PSBoundParameters['Debugger'])
{
$DebugPreference = "Continue"
} #endif $psboundparameters
Begin {
<#
Note: if you use this method, do not import the add-regkeymember function and get-
childitem proxy function
#>
Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
namespace CustomNameSpace {
public class advapi32 {
[DLLImport("advapi32.dll", Charset = Charset.Auto)]
public static extern Int32 ReqQueryInfoKey(
Microsoft.Win32.SafeHandles.SafeRegistryHandle hKey,
StringBuild lpClass,
[In, Out] ref UInt32 lpcbClass,
UInt32 lpReserved,
out UInt32 lpcSubKeys,
out UInt32 lpcbMaxSubKeyLen,
out UInt32 lpcbMaxClassLen,
out UInt32 lpcValues,
out UInt32 lpcbMaxValueNameLen,
out UInt32 lpcbMaxValueLen,
out UInt32 lpcbSecurityDescriptor,
out Int64 lpftLastWriteTIme
);
}
}
"@
Update-TypeData -TypeName Microsoft.Win32.RegistryKey -MemberType ScriptProperty -
MemberName LastWriteTime -Value {
$LastWriteTime = $null
$Return = [CustomNameSpace.advapi32]::RegQueryInfoKey(
$this.Handle,
$null, #classname
[ref] 0, #classnamelength
$null, #Reserved
[ref] $null, #SubKeyCount
[ref] $null, #MaxSubKeyLength
[ref] $null, #MaxClassLength
[ref] $null, #MaxValueLength
[ref] $null, #SecurityDescriptorSize
[ref] $LastWriteTime
)
If ($return -ne 0) {
"[ERROR]"
}
else {
# Return datetime object:
[datetime]::FromFileTime($LastWriteTime)
}
}
Update-TypeData -TypeName Microsoft.Win32.RegistryKey -MemberType ScriptProperty -
MemberName Classname -Value {
$ClassLength = 255 # buffer size (class name is rarely used, and when it is,
I've never seen it more than 8 characters. Buffer can be increased here, though.$classname = New-Object System.Text.StringBuilder $classlength # will hold the
class name
$Return = [CustomNameSpace.advapi32]::RegQueryInfoKey(
$Return = [CustomNameSpace.advapi32]::RegQueryInfoKey(
$this.Handle,
$null, #classname
[ref] 0, #classnamelength
$null, #Reserved
[ref] $null, #SubKeyCount
[ref] $null, #MaxSubKeyLength
[ref] $null, #MaxClassLength
[ref] $null, #MaxValueLength
[ref] $null, #SecurityDescriptorSize
[ref] $LastWriteTime
)
If ($return -ne 0) {
"[ERROR]"
}
else {
# Return class name
$classname.ToString()
}
}
}
Process {
<#
.SYNOPSIS
.DESCRIPTION
#When app is deployed via appdeploy site it creates a config file for that computer
under the folder for that day and adds the name of the app as it would be found in
add/remove programs
or the Registry.
#Create a file with the date.deploy, as each app done writes to date.done. sta rts with
count of lines in .deploy and compares to .done to see when done.
#File has date and a field for deploy of machine for monitor so that local process can
read that to see what all it needs to monitor
#when local process starts it sends initial stat us to website
#puts machine in sccm collection and executes script and cleans up previous runs of
script
.EXAMPLE
Functions in the script:
.NOTES
Author: John Swails
Date:
Comments:
#>
}
$_ = ''
$test = ''
$finderrorcode = ''
$gcsmdirdone = ''
$gcsmdirdeploy = ''
$countapps = ''
$smdir = "c:\packages\scriptmonitor"
$datetime = get-date -Format "yyyyMMdd"
$datetimefull = get-date -format "yyyyMMddHHmmss"
$configroot = "admin server"
$machinename = $env:COMPUTERNAME
$err = ''
#wip means workstation information portal
$wipserver = "server\data-in"
$trimtest = ''
$sccmexeclog = "c:\windows\ccm\logs\execmgr.log"
$os = (gwmi win32_operatingsystem).version$proc = $env:PROCESSOR_ARCHITECTURE
$imgver = [Enviroment]::GetEnvironmentVariable("imgver", "machine")
$model = (gwmi win32_computersystem).model
$logonserver = $env:LOGONSERVER
$buglog = "$smdir\bug.log"
$colItems = gwmi -Class "win32_networkAdapterconfiguration" -ComputerName $machinename
| Where-Object {$_.IpEnabled -match "true"}
foreach ($objItem in $colItems) {
$objItem | Select-Object Description, MACAddress
$writemac = $objItem | Select-Object Description, MACAddress
$ip = $objItem.IPAddress | select-object -First 1
}
$mac = $writemac.MACAddress
if ($logonserver -eq $null) {
$logonserver = $ip
}
function copy_and_remove_flags {
$archive = "$smdir\archive\$datetime\$trimtest\*"
mkdir "$smdir\archive\$datetime\$trimtest"
xcopy $smdir\*.d* $archive /y
xcopy $smdir\*.sm* $archive y
xcopy $smdir\ccmregcheck.unus $archive /y
xcopy $smdir\*.fail $archive /y
xcopy $smdir\*.wait $archive /y
xcopy $smdir\*.late $archive /y
xcopy $smdir\*.reportwait $archive /y
xcopy $smdir\*.recheck $archive /y
ri $smdir\*.d*
ri $smdir\*.sm*
ri $smdir\*.wait
ri $smdir\*.reportwait
ri $smdir\*.late
ri $smdir\*.fail
ri $smdir\*.recheck
ri $smdir\$datetime.lock
ri $smdir\$datetime.tech
}
function get_content_flags {
param([string]$flagname )
get-content $smdir\$datetime.$flagname | set-content \\wipserver\data-
in\nosccmclient\$machinename-$datetime.$flagname
}
function status_report {
params([string]$deploystat, [string]$flagname, $appname, $tech, $status)
#rowheaders#
#machinename,appname,message,datetime,tech,os,processor,imgver,osmodel,status,location
,deploystat,mac,ip
"$machinename,$appname,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,$status,$logo
nserver,$deploystat,$mac,$ip" | out-file $smdir\$datetime.$flagname
}
function call_package_check {
$package = gwmi -Namespace root\ccm\clientsdk -Class ccm_softwarebase | Where-
Object {$_.Packagename -match "^$trimtest"}
$package.Packagename | out-file -append $buglog
}
#search for config file on appserver
# copy it down locally and setup folders
if (!(test-path("$configroot\$datetime\$machinename"))) {
$err = "configroot path for computer not created - monitor"status_report -deploystat "n/a" -flagname "nocomputer" -appname "n/a" -tech "n/a" -
status "n/a"
if (!(test-path("$wipserver\nocomputer"))) {
mkdir $wipserver\nocomputer
get_content_flags -flagname "nocomputer"
exit
}
}
$deploypath = "$configroot\$datetime\$machinename\"
if (test-path("$deploypath\$datetime.deploy")) {
xcopy $deploypath\$datetime.deploy $smdir\
xcopy $deploypath\$datetime.tech $smdir\
ri $deploypath\$datetime.tech
}
if (!(test-path("$deploypath\daily.deploy"))) {
rename-item -path "$deploypath\$datetime.deploy" -NewName $deploypath\daily.deploy
}
else {
get-content $deploypath\$datetime.deploy | for-each object { $_ | Out-File -append
$deploypath\daily.deploy }
ri $deploypath\$datetime.deploy
}
if (!(test-path("$smdir\$datetime.deploy"))) {
$err = "download of config failed but it was found on server" | out-file
$smdir\$datetime.downloadfail
if (!(test-path("$wipserver\downloadfail"))) {
mkdir $wipserver\downloadfail
status_report -deploystat "n/a" -appname "n/a" -tech "n/a" -status
"n/a" -flagname "downloadfail"
get_content_flags -flagname "downloadfail" ; break
}
}
# check to see if wmi if working on local client before proceeding
$forcemachinepolicy = Invoke-WmiMethod -Namespace root\ccm -Class SMS_CLIENT -Name
TriggerSchedule "{00000000-0000-0000-000000000021}"
$forcemachinepolicy
"forced machine policy" | out-file -append $buglog
if (!($forcemachinepolicy)) {
$err = "Either WMI Corruption or broken SCCM Client. Failed WMI class call of
machine policy"
status_report -appname "n/a" -tech "n/a" -status "n/a" -deploystat "n/a" -flagname
"wmierror"
if (!(test-path("$wipserver\wmierror"))) {
"wip server folders not set" | out-file -append $buglog
mkdir $wipserver\wmierror
}
get_content_flags -flagname "wmierror"
exit
}
$tech = get-content $smdir\$datetime.tech
"got name of tech" | out-file -append $buglog
$tech | out-file -append $buglog
################################################### check disk drive space to
alert if its too full ##############################
$disks = gwmi -Class win32_logicaldisk -filter "drivetype = 3"
foreach ($disk in $disks) {
$deviceid = $disk.Deviceid
[float]$size = $disk.size
[float]$freespace = $disk.Freespace
$freespaceGB = [math]::Round($freespace / 1073741824, 2)$err = "$deviceID percentage free space in GB = $freespaceGB"
status_report -appname "diskspace" -tech $tech -status "n/a" -deploystat "n/a"
-flagname "diskspace"
}
######################################################################################
###############################################
# giving the forced machine policy about 2 minutes so it can process the sccm
requests without us having to hit the 1 hour timeout
# put the lock in early so that it keeps it clean. lock is removed at either end of
the done or end of the fail
"lock" | out-file "$smdir\$datetime.lock"
Start-Sleep -Seconds 120
Rename-Item -Path "$smdir\$datetime.deploy" -NewName "$smdir\$datetime.deploy-
Active"
"monitor renamed deploy to active at top of script" | out-file -Append $buglog
$gcsmdirdeploy = get-content "$smdir\$datetime.deploy-Active" | Measure-Object -
line "$gcsmdirdeploy value" | out-file -Append $buglog
$gcsmdirdeploy.lines | out-file -append $buglog
# this is the registry check to see if sccm is processing anything package wise at
the moment
dir "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution
History\System\" | where {$_.LastWriteTime -gt (Get-Date).AddDays(-1) } | foreach-
object -process { $_.Name | out-file -Append "$smdir\ccmregcheck.unus"}
if ([int]$gcsmdirdeploy.lines -ge 1) {
'inside if $gcsmdirdeploy.lines -ge 1' | out-file -Append $buglog
$test = $_
"this is whats in the active deploy file" | out-file -append $buglog
$test | out-file -Append $buglog
# change this to whatever you may have as prepending for this or you may have to
adjust and remove this depending on what you do. when i first wrote this all packages
were started with SWDC
$trimtest = $test.Trimstart("SWDC")
$trimtest | out-file -append $buglog
"checking package for the first time" | out-file -Append $buglog
call_package_check
if($package -eq $null) {
#sleep 2 minutes
Start-Sleep 120
}
#run again
"checking package for second time" | out-file -append $buglog
call_package_check
if ($package -eq $null) {
"needs to recheck. not enough time" | out-file -append $buglog
}
else {
call_package_check
}
if ($package) {
$finderrorcode = $package.lastexitcode | Select-String -Pattern "0"
$finderrorcode | out-file -append $buglog
if ($finderrorcode -ne $null) {
"success found exit code 0" | out-file -Append $buglog
$success | out-file -append $smdir\$datetime.done
$err = "success"
status_report -deploystat "Installed" -flagname "done" -appname $appname -
tech $tech -status "n/a"if (!(test-path("$wipserver\done"))) {
"wip server folders not set" | out-file -append $buglog
mkdir "$wipserver\done"
}
get_content_flags -flagname "done"
#going to wait here for 2 minutes to see if this can help
catch a new install and not have to wait around for full hour
start-sleep -Seconds 120
}
else {
"package found but 0 exit code not found" | out-file -
append $buglog
$finderrorcode = $package.lastexitcode
$finderrorcode | out-file -Append $buglog
$err = "$finderrorcode is the exit code"
status_report -deploystat "Installed" -flagname "done" -
appname $appname -tech $tech -status "n/a"
get_content_flags -flagname "done"
}
}
else {
"package not found yet, going to recheck" | out-file -append
$buglog
"recheck" | out-file -append "$smdir\$datetime.recheck"
$trimtest | out-file -append "$smdir\$datetime.wait"
}
}
else {
"stop" | out-file -append $buglog; exit
}
#skipped above" | out-file -append $buglog; exit
if (test-path("$smdir\$datetime.recheck")) {
get-content "$smdir\$datetime.wait" | ForEach-Object {
$err = "waiting for an hour. didnt find ccm log activity on app yet"
# this grabs each app and then writes it out to reportwait. its why the get-
content has the array creation on this one and I end the loop right after reportwait
status_report -deploystat "waiting" -flagname "reportwait" -appname $appname -
tech $tech -status "n/a"
}
if (!(test-path("$wipserver\wait"))) {
"wip server folders not set" | out-file -append $buglog
mkdir "$wipserver\wait"
}
get_content_flags -flagname "reportwait"
"starting to sleep for 1 hour to recheck sccm log" | out-file append
$buglog
start-sleep -seconds 3600
"back after running 60 minutes sleep due to wait file being created" |
out-file -append $buglog
# after 60 minute wait read file
$checkwait = get-content "$smdir\$datetime.recheck"
"got content of wait" | out-file -Append $buglog
if ($checkwait -eq "recheck") {
"recheck done on wait file" | out-file -Append $buglog
get-content "$smdir\$datetime.wait" | ForEach-Object {
$test = $_
$trimtest = $test.Trimstart("SWDC")
$trimtest | out-file -Append $buglog
call_package_check
$compareadddeployToCCMLog = select-string -Pattern $trimtest -path
C:\windows\ccm\logs\AppEnforce.log -Context 1,1
if ( $compareappdeploytoCCMLog) {
$err = "Success. Program was found"
status_report -deploystat "Installed" -flagname "done" -appname
$appname -tech $tech -status "n/a"get_content_flags -flagname "done"
"skip" | out-file -Append $smdir\skip.done
"wrote skip.done" | out-file -append $buglog
}
if (!(test-path("$smdir\skip.done"))) {
"skip.done not found" | out-file -Append $buglog
if ($package) {
"deploy name equaled in wmi query" | out-file -append $buglog
"get exit code" | out-file -append $buglog
$getexitcode = $package.lastexitcode
$getexitcode | out-file -append $buglog
$err = "Success. Program was found"
status_report -deploystat "Installed" -flagname "done" -
appname $appname -tech $tech -status "n/a"
if (!(test-path("$wipserver\done"))) {
"wip server folders not set" | out-file append $buglog
mkdir "$wipserver\done"
}
else {
$compareDeployToCCMLog = select-string -Pattern $trimtest
-path $sccmexeclog -Context 1,1
if ($compareDeploytoCCMLog) {
"deploy name equaled in ccm log name" | out-file -
append $buglog
"get exit code" | out-file -Append $buglog
$getexitcode = $compareDeploytoCCMLog | select-string
-Pattern "exit code"
$getexitcode | out-file -append $buglog
if($exitcode) {
$err = "Success. Program was found"
status_report -deploystat "Installed" -flagname "done"
-appname $appname -tech $tech -status "n/a"
"skip" | out-file -Append $smdir\skip.done
"wrote skip.done" | out-file -append $buglog
}
$alreadyrun = $getexitcode | select-string -Pattern " will not
run because"
}
if (!(test-path("$smdir\skip.done"))) {
if ($alreadyrun) { $err = "Failed. wont run again" }
$package.Packagename + "Failed" | out-file -append
$buglog
status_report -deploystat "Failed Install" -flagname
"fail-report" -appname $appname -tech $tech -status "n/a"
}
}
}
}
}
}
$gcsmdirdone = get-content "$smdir\$datetime.done" | Measure-Object -line "output
of gcsmdirdone" | out-file -append $buglog
$gcsmdirdone.lines | out-file -append $buglog
if ($gcsmdirdone.lines -ge $gcsmdirdeploy.lines) {
" all deployments done" | out-file -append $buglog
#send status
#get tech id from a process that gathers up the techs id. its not included
here. you could go about that a number of ways. originally on the app website i had a
script that grabbed
# out the techs id that was submitting the form and then it created this
file along with the config file that has to be created as well from the app deploy
site
$gettech = get-content $smdir\$datetime.tech
$countapps = ""$finalgcsmdirdone = get-content "$smdir\$datetime.done" | Measure-Object -
Line
$countapps = $finalgcsmdirdone.lines
$countapps | out-file -append $buglog
$messageparameters = @{
Subject = "ADMIN3 Notification ## $env:Computername - All Apps
Deployed"
body = "Computer: $env:computername </br>Date: $datetime </br> <a
href='http://$wipserver/dashboard'>Dashboard</a><br> You had $countapps App(s) in
your deployment."
from = $gettech
to = $gettech
smtpserver = ""
}
if (!(test-path("$wipserver\fail"))) {
"wip server folders not set " | out-file -append $buglog
mkdir "$wipserver\fail"
}
get_content_flags -flagname "fail"
Send-MailMessage @messageparameters -BodyAsHtml
Rename-Item -Path "$smdir\$datetime.deploy-Active" -NewName
"$smdir\$datetime.deploy-Archive"
"renamed active to archive after completing done" | out-file -append
$buglog
copy_and_remove_flags
"removed $smdir stuff" | Out-File -append $buglog
remove-item $smdir\ccmregcheck.unus
"running productslistmof" | out-file -Append $buglog
C:\Windows\system32\wbem\mofcomp.exe
"c:\packages\scriptmonitor\productslist.mof"
$datetimefull | out-file -append $buglog
get_content_flags -flagname "lastsend"
exit
}
else {
$gcsmdirdone = get-content "$smdir\$datetime.done" | Measure-Object -
Line
if ($gcsmdirdone.lines -ge $gcsmdirdeploy.lines) {
"all deploys done" | out-file -Append $buglog
}
else {
$gettech = get-content $smdir\$datetime.tech
Rename-Item -Path "$smdir\$datetime.deploy-Active" -NewName
"$smdir\$datetime.deploy-Archive"
"renamed active to archive in the failed section" | out-file -append
$buglog
$messageparameters = @{
Subject = "ADMIN3 Notification ## $env:Computername – App Deployed
Failed"
body = "Computer: $env:computername </br>Date: $datetime </br> <a
href='http://$wipserver/dashboard'>Dashboard</a><br> You had $countapps App(s) in
your deployment."
from = $gettech
to = $gettech
smtpserver = ""
}
Send-MailMessage @messageparameters -BodyAsHtml
if (!(test-path("$wipserver\fail"))) {
"wip server folders not set " | out-file -append $buglog
mkdir "$wipserver\fail"
}get_content_flags -flagname "fail"
copy_and_remove_flags
"removed $smdir stuff" | Out-File -append $buglog
remove-item $smdir\ccmregcheck.unus
$datetimefull | out-file -append $buglog
get_content_flags -flagname "lastsend"
}
}