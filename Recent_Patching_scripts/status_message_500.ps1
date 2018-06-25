<#
.SYNOPSIS
.DESCRIPTION
query non compliant list to get all of the machines with error code zero
.EXAMPLE
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
it also gets the unique id now and adds that so we can know what patch the status
is associated with.
.NOTES
Author: John Swails
Date: 5/03/2018
Comments:
#>
$machineslist = "~\Documents\machineslist.txt"
$machines = get-content -Path $machineslist
function get_patch_name {
$SiteServer = ""
$SiteCode = ""
$SiteDrive = $SiteCode + ":"
Import-Module (Join-Path -Path
(($env:SMS_ADMIN_UI_PATH).Substring(0,$env:SMS_ADMIN_UI_PATH.Length-5)) -ChildPath
"\ConfigurationManager.psd1") -Force
if ((Get-PSDrive $SiteCode -ErrorAction SilentlyContinue | Measure-Object).Count -ne
1) {
New-PSDrive -Name $SiteCode -PSProvider "AdminUI.PS.Provider\CMSite" -Root
$SiteServer
}
Set-Location $SiteDrive
$findupdate = Get-CMSoftwareUpdate -fast | where {$_.CI_UniqueID -like "*$id*"}
$updatename = $findupdate.LocalizedDisplayName
$global:show_updatename = $updatename
}
foreach ($computer in $machines){
function get_status {
param([string]$state)
set-location c:
# check status messages
$namespace = "root\ccm\statemsg"
$get_state = Get-WmiObject -namespace $namespace -class CCM_StateMsg -computername
$computer | Where-Object {$_.TopicType -eq "500" –and $_.StateID -eq "$state"} |
Select-Object -last 1
if($get_state){
$message_time = $get_state.messagetime
$id = $get_state.topicid
#call function to query sccm to get the patch name to put into report for each unique
id
get_patch_name
$show_updatename
write-host " this is show_updatename $show_updatename"
#change location back to C so that report can be written as the function call above
this changes set-location to the config man drive
Set-Location c:
"$computer,$message_time,$id,$show_updatename" | out-file -append "~\Documents
status-$state.txt”}
}
get_status -state 0
get_status -state 2
get_status -state 3
}