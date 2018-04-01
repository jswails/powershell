# this is the script that reads the whole list of task sequences and gets all of the dependencies. the other script is for one off searching.

$datetime = Get-Date -Format "yyyyMMdd";

# need to put in something to check for location of smsadmin

write-host " Location of scripts is D:\scripts\tsfiles. Change the script for you if it fails."

$smsadmin = ($env:SMS_ADMIN_UI_PATH).Replace("\i386","")

#$smsadmin = "c:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin"

import-module "$smsadmin\configurationmanager.psd1"

 

$SiteCode = Get-PSDrive -PSProvider CMSITE

Set-Location "$($SiteCode.Name):\"

 

#$TaskSequenceName = 'RETAIL-OSD-CHICAGO-FMER-BRANCH-WKS-Build-16.10.1'

$taskslist = get-content "D:\Scripts\tsfiles\current_list_task_sequences.txt"

foreach($tasksequencename in $taskslist){

$a = Get-CMTaskSequence -name $TaskSequenceName

if(!(test-path("d:\scripts\tsfiles\$datetime"))){

mkdir "d:\scripts\tsfiles\backup-$datetime"

}

if(test-path("D:\Scripts\tsfiles\$tasksequencename.txt")){

    #backs up the existing and creates the new one.

   ren "D:\Scripts\tsfiles\$tasksequencename.txt" "D:\Scripts\tsfiles\$tasksequencename-$datetime.txt"

  Move-Item -Path "D:\Scripts\tsfiles\$tasksequencename-$datetime.txt" -Destination "d:\scripts\tsfiles\backup-$datetime\"

    }

if(!(test-path("D:\Scripts\tsfiles"))){

mkdir D:\Scripts\tsfiles

}

$get = $a.references

foreach($hi in $get){

    foreach($pack in $hi){

   

        $pack.Package | Out-File -Append "D:\Scripts\tsfiles\$tasksequencename.txt"

    }

}

} # end of reading the tasks list
