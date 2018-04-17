function wrapper {
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
#region STAGE 0
########################################
# Start STAGE 0: Prepare Environment #
########################################
Write-Debug "Stage 0: Prepare Environment"
##### initial variables ################
$smdir = "c:\temp\scriptmonitor"
$err = ""
$begin = ""
$wipserver = "servername"
$datetime = get-date -Format "yyyyMMdd"
$datetimem = Get-Date -Format "yyyyMMddHHmm"
$datetimefull = Get-Date -Format "yyyyMMddHHmmss"
$configroot = "server unc path to configuration files root"
$sccmexeclog = "c:\windows\ccm\logs\execmgr.log"
$machinename = $env:COMPUTERNAME
$os = (Get-CimInstance win32_OperatingSystem).Version
$proc = $env:PROCESSOR_ARCHITECTURE
$imgver = [Environment]::GetEnvironmentVariable("imgver", "machine")
$model = (Get-WmiObject win32_computersystem).model
$logonserver = $env:LOGONSERVER
######################################################### end of initial variables
####################################
Write-Debug "started wrapper"
Write-Debug $datetimem
function get_networking {
$colitems = Get-WmiObject -Class "win32_networkadapterconfiguration" -
ComputerName $machinename | Where-Object{$_.IpEnabled -match "True"}
foreach ($objitem in $colitems) {
$objitem | Select-Object Description,MACAddress
$writemac = $objitem | Select-Object Description,MACAddress
$ip = $objitem.IpAddress | Select-Object -First 1
}
$mac = $writemac.MACAddress
if($logonserver -eq $null) {
$logonserver = $ip }
}
get_networking
function set_printer_logs {
# setting printer logs to enabled$logname = 'Microsoft-Windows-PrintService/Operational'
# this enables the logging for the local printer
$log = New-Object System.Diagnostics.Eventing.Reader.EventLogConfiguration
$logname
if($log.IsEnabled -ieq $false){
"print logging is false. will enable now" | out-file -Append $smdir\bug.log
$log.IsEnabled=$true
$log.SaveChanges()
}
}
function get_content_flags {
param([string]$flagname )
get-content $smdir\$datetime.$flagname | set-content
\\fileprocessingserver\data-in\nosccmclient\$env:computername-$datetime.$flagname
}
if(test-path("$smdir\printq.flag")){
#if printq.flag exists then run the printer queue audit script to monitor
every 15 minutes
Write-Debug " starting print queue monitor"
# this is calling a file that would need to be recreated as Its not part of
this bundle.
Start-Process powershell.exe -Argument ' -file
c:\packages\scriptmonitor\audit\print-queue.ps1'
}
if(test-path("$smdir\$datetime.lock")){
exit
}
if(test-path("$smdir\*.nocomputer")){
Remove-Item $smdir\*.nocomputer
}
if(test-path("$smdir\*.noconfig")){
Remove-Item $smdir\*.noconfig
}
if(test-path("$smdir\*.fail")){
Remove-Item $smdir\*.fail
}
if(!(Test-Path("$sccmexeclog"))){
if(!(test-path("$wipserver\nosccmclient"))){
mkdir $wipserver\nosccmclient
}
Write-Debug "sccm client not installed"
$err = " No SCCM Client Installed"
"$machinename,n/a,$err,$datetimefull,n/a,$os,$proc,$imgver,$model,n/a,$logonserver,n/a
,$mac,$ip" | out-file $smdir\$datetime.nosccmclient
get_content_flags -flagname "nosccmclient"
exit
}
#region Stage 1
##################################################################
# Start STAGE 1: enter environment #
##################################################################
Write-Debug "Stage 1: Enter Environment"
if(!(test-path("$configroot\$datetime\$machinename\$datetime.deploy"))){
"no config today yet" | out-file $smdir\$datetime.noconfig; exit}
#run the script if locally something found in past day. this wrapper runs every 15
minutes. if it finds a local registry change then it goes to see if there is a config
file on server.
$begin = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software
Distribution\Execution History\System\" | Where-Object { $_.LastWriteTime -gt (Get-
Date).AddDays(-1) }
if($begin){
Write-Debug "lets begin"if(!(test-path("$smdir\script-monitor.ps1"))) {
xcopy "\\path of script-monitor.ps1" "$smdir\"
}
# checking to see if active still around. if it exits then add to it. if not
around that means that it should have become archived and can proceed with new run.
if(test-path("$smdir\$datetime.deploy-Active")) {
# read server deploy config and insert its config into the current active config
if(!(test-path("$configroot\$datetime\$machinename"))){
if(!(test-path("$wipserver\nocomputer"))){
Write-Debug " wip server folders not set"
mkdir $wipserver\nocomputer
}
$err = "configroot path for computer not created - wrapper"
"$machinename,n/a,$err,$datetimefull,n/a,$os,$proc,$imgver,$model,n/a,$logonserver,n/a
,$mac,$ip" | out-file $smdir\$datetime.nocomputer
get_content_flags -flagname "nocomputer"
exit
}
if(test-path("$configroot\$datetime\$machinename\$datetime.deploy")){
if(Test-Path("$smdir\$datetime.lock")){
"found lock.exiting" | out-file -append $smdir\bug.log
exit
}
}
}
#region
STAGE 2
#########################################################
# Start Stage 2: Run Environment #
#########################################################
write-debug "Stage 2: Run Environment"
# run the file monitor
Write-Debug " about to run the script monitor"
Start-Process powershell.exe -Argument ' -file
c:\packages\scriptmonitor\script-monitor.ps1'
Write-Debug " script monitor end of script call finished"
exit
} else {
Write-Debug "went to sms error part. no sms reg changes but did find deploy"
if(test-path("$configroot\$datetime\$machinename\$datetime.deploy")) {
#forcing machine policy here to speed things up for the next check.
$forcemachinepolicy = Invoke-WmiMethod -Namespace root\ccm -Class SMS_CLIENT -Name
TriggerSchedule "{00000000-0000-0000-000000000021}"
Write-Debug "forced machine policy"
$forcemachinepolicy
[int]$checksms = Get-Content "$smdir\$datetime.smserr"
if(!(test-path("$smsdir\$datetime.smserr"))){
$x = 1
[int]$x | out-file "$smdir\$datetime.smserr"
} else {
$updatechk = [int]$checksms+1
Write-Debug "updatecheck variable $updatechk"
}
#region
STAGE 3
############################################################
# Start STAGE 3: End Environment #
############################################################
Write-Debug "STAGE 3: End Environment"
if($checksms -eq 5) {
$deploycontent = get-content
$configroot\$datetime\$machinename\$datetime.deploy
$err = "possible problem with local sms client. no reg changes found for
$deploycontent software push""$machinename,n/a,$err,$datetimefull,n/a,$os,$proc,$imgver,$model,n/a,$logonserver,n/a
,$mac,$ip" | out-file "$smdir\$datetime.badsmspackage"
if(!(test-path("$wipserver\badsmspackage"))){
Write-Debug "wip server folders not set"
mkdir $wipserver\badsmspackage
}
get_content_flags -flagname "badsmspackage"
remove-item -Path $smdir\$datetime.badsmspackage -Force
remove-item -Path $smdir\$datetime.smserr -Force
$x = 0
exit
} else {
$updatechk = [int]$checksms+1
$updatechk | out-file "$smdir\$datetime.smserr"
}
# end of checksms
} else {
"nothing to process" | out-file "$smdir\nil.nil"
exit
}
#this goes to the testpath of configroot
} # this close goes up to the else at line 235
} # this closes out Process
END{}
} # end of wrapper function
# finally we call the wrapper function
wrapper