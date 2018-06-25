<#
.SYNOPSIS
queries a number of things about a client in regards to sccm and the OS for
troubleshooting
.DESCRIPTION
this is put in a csv file. you will n eed to open the file with excel then open and
import for it to work correctly. the delimeter is the comma ,
.EXAMPLE
This is for the @get_sccm_patch_last_message function to explain what its looking for
and how you could do more with it.
TopicType State Message ID
State Message Description
500
0
Detection state unknown
500
1
Update is not required
500
2
Update is required
500
3
Update is installed
Functions in the script:
@get-sccmguid - gets the guid from wmi on local client
@get-smscert - gets the cert from the config file on local client
@Get-OS - os information
@pending_reboot - checks for pending reboot flag
@Ping-Host - ping via wmi to check
@get-sccminfo - retrieves the hardware inventory last reported time from the
database for the client.
@get_sccm_patch_last_message -function to explain what its looking for and how you
could do more with it.
.NOTES
Author: John Swails
Date: 5/07/2018
Comments:
#>
$get_start = read-host -Prompt "Do you want Single Machine or list? Type s or l"
if($get_start -eq "s"){
$singlemachine = read-host -Prompt "enter machine name:"
# i am going to try this out and see if single machine is best to just have the
script rewrite the computers.txt file with this arg input.
Remove-Item -Path "c:\logs\machineslist.txt" -Force
$singlemachine | out-file "c:\logs\machineslist.txt"
}
write-host -ForegroundColor DarkRed "The list uses this file
c:\logs\machineslist.txt"
$machineslist = get-content "c:\logs\machineslist.txt"
$output = "c:\logs\machines.csv"
if(!(test-path("$output"))){
# create the file and add headers
#"$computer,$ping,$IP,$osname,$uptime,$lastboot,$show_hwscan,$show_message,$show_cert,
$show_guid,$show_reboot"
"Computer,Ping,IP,OS
Name,Uptime,LastBoot,HWScan,LastPatchMsg,SMSCert,SMSGUID,PendingReboot" | out-file
$output
}
function get-sccmguid {
Set-Location -Path c:
$getguid = get-wmiobject -ComputerName $computer -Namespace
root\ccm -Query "Select ClientID from CCM_Client" | Select ClientID
$getguid = $getguid.clientid
return
$getguid
}
function get-smscert {
Set-Location -Path c:
# this cert is what identifies if its going to be unique or a
dupe.$searchcert = get-content \\$computer\C$\Windows\SMSCFG.INI |
Select-String -SimpleMatch "SMS Certificate Identifier="
$stringsearch = $searchcert.ToString()
$smscert = [string]$stringsearch.Split('=')[1].split(' ')
return $smscert
}
function Get-OS {
Param([string]$computer=$(Throw "You must specify a
computername."))
Write-Debug "In Get-OS Function"
$wmi=Get-WmiObject Win32_OperatingSystem -computername
$computer -ea stop
write $wmi
}
function Ping-Host {
Param([string]$computer=$(Throw "You must specify a
computername."))
Write-Debug "In Ping-Host function"
$query="Select * from Win32_PingStatus where address='$computer'"
$wmi=Get-WmiObject -query $query
write $wmi
}
function get-sccminfo {
$SiteServer = ""
$SiteCode = ""
$SiteDrive = $SiteCode + ":"
Import-Module (Join-Path -Path
(($env:SMS_ADMIN_UI_PATH).Substring(0,$env:SMS_ADMIN_UI_PATH.Length-5)) -ChildPath
"\ConfigurationManager.psd1") -Force
if ((Get-PSDrive $SiteCode -ErrorAction SilentlyContinue |
Measure-Object).Count -ne 1) {
New-PSDrive -Name $SiteCode -PSProvider
"AdminUI.PS.Provider\CMSite" -Root $SiteServer
}
Set-Location $SiteDrive
Write-Debug get-location
$hardwarescan = (get-cmdevice -Name "$computer").lasthardwarescan
if($hardwarescan -eq $null ){
$hardwarescan = "n/a"}
return $hardwarescan
Set-Location c:
Write-Debug get-location
}
function get_sccm_patch_last_message {
set-location c:
# this is looking only for the state id 3 that i s a message that
patches were installed. if you have no last message here then there is a problem or
never been patched.
$namespace = "root\ccm\statemsg"
$get_state = Get-WmiObject -namespace $namespace -class
CCM_StateMsg -computername $computer | Where-Object {$_.TopicType -eq "500" –and
$_.StateID -eq "3"} | Select-Object -last 1
$message_time = $get_state.messagetime
return $message_time
}
function pending_reboot {
$basekey =
[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("LocalMachine",$machinename)$key =
$basekey.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Component Based
Servicing\")
$subkeys = $key.GetsubKeyNames()
$key.Close()
$baseKey.Close()
if ($subkeys | Where {$_ -eq "RebootPending"})
{
$reboot = "needs reboot"
return $reboot
} else {
$reboot = "nopending"
return $reboot
}
}
##### end of functions
############################################################################
foreach ($computer in $machineslist){
#ping the computer
if ($pingResult) {
#clear PingResult if it has a left over value
Clear-Variable pingResult
}
$pingResult=Ping-Host $computer
if ($pingResult.StatusCode -eq 0) {
$ping = "yes"
$IP = $pingResult.ProtocolAddress
#get remaining information via WMI
Trap {
#define a trap to handle any WMI errors
Write-Warning ("There was a problem with {0}" -f $computer.toUpper())
Write-Warning $_.Exception.GetType().FullName
Write-Warning $_.Exception.message
Continue
}
if ($os) {
#clear OS if it has a left over value
Clear-Variable os
}
$os=Get-OS $computer
if ($os) {
$lastboot=$os.ConvertToDateTime($os.lastbootuptime)
Write-Debug "Adding $lastboot"
$uptime=((get-date) -
($os.ConvertToDateTime($os.lastbootuptime))).tostring()
Write-Debug "Adding $uptime"
$osname=$os.Caption
Write-Debug "Adding $osname"
$show_cert = get-smscert
$show_guid = get-sccmguid
$show_hwscan = get-sccminfo
$show_message = get_sccm_patch_last_message
$show_reboot = pending_reboot
"$computer,$ping,$IP,$osname,$uptime,$lastboot,$show_hwscan,$show_message,$show_cert,$
show_guid,$show_reboot" | out-file -Append $output
}
} else { $ping = "no"}
}