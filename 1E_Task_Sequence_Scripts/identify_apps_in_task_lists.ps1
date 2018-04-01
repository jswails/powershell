$datetime = Get-Date -Format "yyyyMMdd";

# need to put in something to check for location of smsadmin

write-host " Location of scripts is D:\scripts\tsfiles. Change the script for you if it fails."

$smsadmin = ($env:SMS_ADMIN_UI_PATH).Replace("\i386","")

#$smsadmin = "c:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin"

if(!(test-path("d:\scripts\tsfiles\output"))){

mkdir d:\scripts\tsfiles\output

}

import-module "$smsadmin\configurationmanager.psd1"

 

$SiteCode = Get-PSDrive -PSProvider CMSITE

Set-Location "$($SiteCode.Name):\"

Set-CMQueryResultMaximum -Maximum 50000

$list = get-content "D:\scripts\tsfiles\tasklist.txt"

foreach($id in $list){

$ts = get-content d:\scripts\tsfiles\"$id".txt

foreach($packageid in $ts){

 

$packageid | out-file -append d:\scripts\tsfiles\debug.log

 

 

if ($packageid.StartsWith("ScopeId")){

$a = ""

$a = Get-CMApplication | where-object {$_.modelname -eq "$packageid"}

$appname = $a.LocalizedDisplayName

 

$applicationxml = [Microsoft.ConfigurationManagement.ApplicationManagement.Serialization.SccmSerializer]::DeserializeFromString($A.SDMPackageXML,$True)

foreach ($DeploymentType in $applicationxml.DeploymentTypes) { $installer = $deploymenttype.installer; $contentid = $installer.installcontent}

 

$contentid.id | out-file -append d:\scripts\tsfiles\output\$id-$datetime.txt

$contentidID = $contentid.id

"$contentidID,$appname" | out-file -append D:\scripts\tsfiles\output\id2name-"$id".txt

 

} else {

"$packageid" | out-file -append d:\scripts\tsfiles\output\$id-$datetime.txt

$packagename = Get-CMPackage | where-object {$_.packageid -eq "$packageid"}

$packagenameName = $packagename.name

"$packagenameName,$packageid" | out-file -append D:\scripts\tsfiles\output\id2name-"$id".txt

         }

 

 

}

}

 