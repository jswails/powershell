## script monitor##

# starts with setting variable and config file

# when app deployed via admin3 it creates a config file for that computer for the day and adds the name of the app as it would be searched for in Programs and Features or in Registry 
# create a file with date.deploy, as each app done writes to date.done. starts with count of lines in .deploy and compares to .done to see when done.
# this config file has date and a field for deploy of m for monitor so that local process can read that to see what all it needs to monitor
# when local process starts it sends initial status to website
# process changes field to D for done when its verified
# then emails desktop and sends status to website
# get name of app install need to have a list that equates name of app install to what appears in ARP
# create sccm collection that machine is put in to deploy the script monitor. it executes the script and cleans up previous runs.
# need to create data collectors on admin3 for management portal
# the installer also sets up the mof program and runs that. copies over the mof from admin3 and runs its locally to setup wmi

# start of program
 $x = 0
 $_ = ''
 $test = ''
 $pattern = ''
 $findcollection = ''
 $mycollection = ''
 $finderrorcode = ''
 $gcsmdirdone = ''
 $gcsmdirdeploy = ''
 $countapps = ''
$smdir =  "C:\Packages\scriptmonitor"
$datetime = Get-Date -Format "yyyyMMdd";
$configroot = "\\admin3\scriptmonitor"

# first thing to do is search for config file on admin3
#test-path \\admin3\pathtosomething\computername\date.deploy
# copy it down locally to $smdir and setup folders

if(!(test-path("$configroot\$env:COMPUTERNAME"))){
"configroot path for computer not created - monitor" | out-file $smdir\$datetime.nocomputer; exit }
if(test-path("$configroot\$env:computername\$datetime.deploy")){
xcopy "$configroot\$env:computername\$datetime.deploy" $smdir\
if(!(Test-Path( "$smdir\$datetime.deploy"))){
"download of config failed but it was found on server" | out-file $smdir\$datetime.downloadfail ; break
} 
ren "$smdir\$datetime.deploy" "$smdir\$datetime.deploy-Active"
$gcsmdirdeploy = Get-Content "$smdir\$datetime.deploy-Active" | Measure-Object –Line
 get-Content "$smdir\$datetime.deploy-Active" | % {
   
        $x = 0
        $test = $_
  

# this finds the most recent writes to the location in registry. this found most recent installs.
dir "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System\" | where { $_.LastWriteTime -gt (Get-Date).AddDays(-1) } | foreach-object -Process { $_.Name | out-file -Append c:\test.txt}
 get-Content "c:\test.txt" | % {
# so now after this you have the most recent program id's that have run on machine 
# check the exec log now and use the original script that checks for package id and exit code.
$go = $_.substring($_.length - 8, 8)

$sccmexeclog = "c:\windows\ccm\logs\execmgr.log"
 $findinstall = Select-String -Pattern "$go" -Path $sccmexeclog 
 if($findinstall){
 $finderrorcode = $findinstall | select-string -Pattern " exit code 0"
      if($finderrorcode -ne $null) { 
       write-host "success found exit code 0"
      $_ | out-file -append $smdir\$datetime.done }

 } else {
 $go | out-file -Append $smdir\$datetime.wait
 }

# this will find a lot if the program has run.
# run through the wait loop and check again

}

Start-Sleep -Seconds 30
# after 30 second wait read wait file

get-Content "$smdir\$datetime.wait" | % {
# so now after this you have the most recent program id's that have run on machine 
# check the exec log now and use the original script that checks for package id and exit code.
$go = $_.substring($_.length - 8, 8)

$sccmexeclog = "c:\windows\ccm\logs\execmgr.log"
 $findinstall = Select-String -Pattern "$go" -Path $sccmexeclog 
 if($findinstall){
 $finderrorcode = $findinstall | select-string -Pattern " exit code 0"
      if($finderrorcode -ne $null) { 
       write-host "success found exit code 0"
      $_ | out-file -append $smdir\$datetime.done }

 } else {
 $go | out-file -Append $smdir\$datetime.late
 }

# this will find a lot if the program has run.
# run through the wait loop and check again

}
  
 }
 }
 

 
 $gcsmdirdone = Get-Content "$smdir\$datetime.done" | Measure-Object –Line

 if ($gcsmdirdeploy.lines -eq $gcsmdirdone.lines) {
 write-host " all deployments done"
 #send status

 $countapps = ""
    $finalgcsmdirdone = Get-Content "$smdir\$datetime.done" | Measure-Object –Line
    $countapps = $finalgcsmdirdone.lines
  $messageparameters = @{
  Subject = "ADMIN3 Notification ## $env:COMPUTERNAME - All Apps Deployed "
  body = "Computer: $env:COMPUTERNAME </br>Date: $datetime </br> Future link here to online report</br> You had $countapps App(s) in your deployment. "
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "outlookdc1.corp.stateauto.com"
  }
  
  send-mailmessage @messageparameters -bodyashtml
  ren "$smdir\$datetime.deploy-Active" "$smdir\$datetime.deploy-Archive"
  write-host " i shouldnt be here; something wrong with script"
 # should exit;
 break;
 } else {
 write-host " in second part of script; looking for late file"
 start-sleep -s 3
 # start again but this time just use contents of late
 #send status that apps are late; retrying
 get-Content "$smdir\$datetime.late" | % {
  $findinstall = Select-String -Pattern "$go" -Path $sccmexeclog 

  if($findinstall){
 $finderrorcode = $findinstall | select-string -Pattern " exit code 0"
      if($finderrorcode -ne $null) { 
       write-host "success found exit code 0"
      $_ | out-file -append $smdir\$datetime.done }

 } else {
 $go | out-file -Append $smdir\$datetime.fail
 }
 }

 $gcsmdirdone = Get-Content "$smdir\$datetime.done" | Measure-Object –Line

  if ($gcsmdirdeploy.lines -eq $gcsmdirdone.lines) {
  write-host "all deploys done"
  } else {
  #send status that these apps failed
  #send status of apps that deployed
    get-Content "$smdir\$datetime.fail" | % {
   

  $messageparameters = @{
  Subject = "ADMIN3 Notification ## $env:COMPUTERNAME - App Failure"
  body = "Computer: $env:COMPUTERNAME </br>Date: $datetime </br> Future link here to online report</br> $_ "
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "outlookdc1.corp.stateauto.com"
  }
  }
  send-mailmessage @messageparameters -bodyashtml
    ren "$smdir\$datetime.deploy-Active" "$smdir\$datetime.deploy-Archive"
  write-host " these deployments failed"
  get-Content "$smdir\$datetime.fail" | % {
  write-host $_ "Failed"
  }
  }
  } else {
  write-host " no config file found"
  "no config found $datetime" | out-file $smdir\$datetime.noconfig
  }