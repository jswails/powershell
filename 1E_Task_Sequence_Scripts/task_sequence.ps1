

$datetime = Get-Date -Format "yyyyMMdd";

# need to put in something to check for location of smsadmin

write-host " Location of scripts is D:\scripts\tsfiles. Change the script for you if it fails."

$smsadmin = ($env:SMS_ADMIN_UI_PATH).Replace("\i386","")

#$smsadmin = "c:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin"

import-module "$smsadmin\configurationmanager.psd1"

 

$SiteCode = Get-PSDrive -PSProvider CMSITE

Set-Location "$($SiteCode.Name):\"

 
$TaskSequenceName = read-host -Prompt "Enter in name of task sequence"

$a = Get-CMTaskSequence -name $TaskSequenceName

 

if(!(test-path("D:\Scripts\tsfiles"))){

mkdir D:\Scripts\tsfiles

 

}

$get = $a.references

foreach($hi in $get){

    foreach($pack in $hi){

        $pack.Package | Out-File -Append "D:\Scripts\tsfiles\$tasksequencename.txt"

    }

}
