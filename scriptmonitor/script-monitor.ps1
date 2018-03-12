<#
NOTE: If you use this method, do not import the Add-RegKeyMember function and Get-ChildItem proxy function
#>
Add-Type @"
    using System; 
    using System.Text;
    using System.Runtime.InteropServices; 

    namespace CustomNameSpace {
        public class advapi32 {
            [DllImport("advapi32.dll", CharSet = CharSet.Auto)]
            public static extern Int32 RegQueryInfoKey(
                Microsoft.Win32.SafeHandles.SafeRegistryHandle hKey,
                StringBuilder lpClass,
                [In, Out] ref UInt32 lpcbClass,
                UInt32 lpReserved,
                out UInt32 lpcSubKeys,
                out UInt32 lpcbMaxSubKeyLen,
                out UInt32 lpcbMaxClassLen,
                out UInt32 lpcValues,
                out UInt32 lpcbMaxValueNameLen,
                out UInt32 lpcbMaxValueLen,
                out UInt32 lpcbSecurityDescriptor,
                out Int64 lpftLastWriteTime
            );
        }
    }
"@

Update-TypeData -TypeName Microsoft.Win32.RegistryKey -MemberType ScriptProperty -MemberName LastWriteTime -Value {

    $LastWriteTime = $null
            
    $Return = [CustomNameSpace.advapi32]::RegQueryInfoKey(
        $this.Handle,
        $null,       # ClassName
        [ref] 0,     # ClassNameLength
        $null,  # Reserved
        [ref] $null, # SubKeyCount
        [ref] $null, # MaxSubKeyNameLength
        [ref] $null, # MaxClassLength
        [ref] $null, # ValueCount
        [ref] $null, # MaxValueNameLength 
        [ref] $null, # MaxValueValueLength 
        [ref] $null, # SecurityDescriptorSize
        [ref] $LastWriteTime
    )

    if ($Return -ne 0) {
        "[ERROR]"
    }
    else {
        # Return datetime object:
        [datetime]::FromFileTime($LastWriteTime)
    }
}

Update-TypeData -TypeName Microsoft.Win32.RegistryKey -MemberType ScriptProperty -MemberName ClassName -Value {

    $ClassLength = 255 # Buffer size (class name is rarely used, and when it is, I've never seen 
                        # it more than 8 characters. Buffer can be increased here, though. 
    $ClassName = New-Object System.Text.StringBuilder $ClassLength  # Will hold the class name
            
    $Return = [CustomNameSpace.advapi32]::RegQueryInfoKey(
        $this.Handle,
        $ClassName,
        [ref] $ClassLength,
        $null,  # Reserved
        [ref] $null, # SubKeyCount
        [ref] $null, # MaxSubKeyNameLength
        [ref] $null, # MaxClassLength
        [ref] $null, # ValueCount
        [ref] $null, # MaxValueNameLength 
        [ref] $null, # MaxValueValueLength 
        [ref] $null, # SecurityDescriptorSize
        [ref] $null  # LastWriteTime
    )

    if ($Return -ne 0) {
        "[ERROR]"
    }
    else {
        # Return class name
        $ClassName.ToString()
    }
}


# starts with setting variable and config file

# when app deployed via admin3 it creates a config file for that computer for the day and adds the name of the app as it would be searched for in Programs and Features or in Registry 
# create a file with date.deploy, as each app done writes to date.done. starts with count of lines in .deploy and compares to .done to see when done.
# this config file has date and a field for deploy of m for monitor so that local process can read that to see what all it needs to monitor
# when local process starts it sends initial status to website
# process changesF field to D for done when its verified
# then emails desktop and sends status to website
# get name of app install need to have a list that equates name of app install to what appears in ARP
# create sccm collection that machine is put in to deploy the script monitor. it executes the script and cleans up previous runs.
# need to create data collectors on admin3 for management portal
# the installer also sets up the mof program and runs that. copies over the mof from admin3 and runs its locally to setup wmi

# start of program
$rowheaders = "machinename,appname,message,datetime,tech,os,processor,imgver,osmodel,status,location,deploystat,mac,ip"
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
 $datetimefull = Get-Date -Format "yyyyMMddHHmmss";
 $configroot = "\\admin3\scriptmonitor"
 $datetime | Out-File -append $smdir\bug.log
 $machinename = $env:COMPUTERNAME
 $err = ""
 $wipserver = "\\10.30.164.71\data-in"
 $trimtest = ''
 $sccmexeclog = "c:\windows\ccm\logs\execmgr.log"
 $os = (Get-CimInstance Win32_OperatingSystem).version
 $proc = $env:PROCESSOR_ARCHITECTURE
 $imgver = [Environment]::GetEnvironmentVariable("imgver","machine")
 $model = (Get-WmiObject Win32_Computersystem).model
 $logonserver = $env:LOGONSERVER

  $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $machinename |Where{$_.IpEnabled -Match "True"}  
      foreach ($objItem in $colItems) {  
    $objItem |select Description,MACAddress  
    $writemac = $objItem |select Description,MACAddress  
       $ip = $objItem.IPAddress | Select-Object -First 1
   } 
    $mac = $writemac.MACAddress
if($logonserver -eq $null) {
$logonserver = $ip}

# first thing to do is search for config file on admin3
#test-path \\admin3\pathtosomething\computername\date.deploy
# copy it down locally to $smdir and setup folders

if(!(test-path("$configroot\$datetime\$env:COMPUTERNAME"))){
# this below fixes the confusion of the config deploy keeping names in it so that the duplication find part doesnt keep seeing it and will actually process

$err = "configroot path for computer not created - monitor" 
"$machinename,$err,$datetimefull,$os,$proc,$imgver,$model,n/a,$logonserver,n/a,$mac,$ip" | out-file $smdir\$datetime.nocomputer
if(!(test-path("$wipserver\nocomputer"))){
mkdir $wipserver\nocomputer
Get-Content $smdir\$datetime.nocomputer | Set-Content \\10.30.164.71\data-in\nocomputer\$env:COMPUTERNAME-$datetime.nocomputer
 exit }}
if(test-path("$configroot\$datetime\$env:computername\$datetime.deploy")){
xcopy "$configroot\$datetime\$env:computername\$datetime.deploy" $smdir\
xcopy "$configroot\$datetime\$env:computername\$datetime.tech" $smdir\
ri "$configroot\$datetime\$env:computername\$datetime.tech"
}
if(!(Test-Path("$configroot\$datetime\$env:computername\daily.deploy"))){
ren "$configroot\$datetime\$env:computername\$datetime.deploy" "$configroot\$datetime\$env:computername\daily.deploy"
} else {
Get-Content "$configroot\$datetime\$env:computername\$datetime.deploy" | % {
$_ | out-file -Append "$configroot\$datetime\$env:computername\daily.deploy"
} 
ri "$configroot\$datetime\$env:computername\$datetime.deploy"
}
if(!(Test-Path( "$smdir\$datetime.deploy"))){
$err = "download of config failed but it was found on server" | out-file $smdir\$datetime.downloadfail 
if(!(test-path("$wipserver\downloadfail"))){
mkdir $wipserver\downloadfail 
"$machinename,n\a,$err,$datetimefull,n\a,$os,$proc,$imgver,$model,n/a,$logonserver,n/a,$mac,$ip" | out-file $smdir\$datetime.downloadfail 

Get-Content $smdir\$datetime.downloadfail | Set-Content "\\10.30.164.71\data-in\downloadfail\$env:COMPUTERNAME-$datetime.downloadfail"
; break
} }
### check to see if wmi is working on local client before proceeding ##
# force machine policy check#
$forcemachinepolicy = Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}"
"forced machine policy" | Out-File -append $smdir\bug.log
if(!($forcemachinepolicy)){
$err = "Either WMI corruption of broken SMS client. failed wmi class call of machine policy"
"$machinename,n\a,$err,$datetimefull,n\a,$os,$proc,$imgver,$model,n/a,$logonserver,n/a,$mac,$ip"| out-file $smdir\$datetime.wmierror
if(!(test-path("$wipserver\wmierror"))){
" wip server folders not set " | Out-File -append $smdir\bug.log
mkdir $wipserver\wmierror}
Get-Content $smdir\$datetime.wmierror | Set-Content "\\10.30.164.71\data-in\wmierror\$env:COMPUTERNAME-$datetime.wmierror"
exit
}
$tech = get-content $smdir\$datetime.tech
"got name of tech" | Out-File -append $smdir\bug.log
$tech | Out-File -append $smdir\bug.log
########################## check disk drive space to alert if its too full ##################

$disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType = 3";
 
 	
	foreach($disk in $disks)
	{
		
		$disk_name = $disk.Name;
		
		$deviceID = $disk.DeviceID;
		[float]$size = $disk.Size;
		[float]$freespace = $disk.FreeSpace;
 
	
		$sizeGB = [Math]::Round($size / 1073741824, 2);
		$freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);

	
		$err =  "$deviceID percentage free space in GB = $freespaceGB";
		"$machinename,diskspace,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,n/a,$logonserver,n/a,$mac,$ip" | out-file $smdir\$datetime.diskspace 
	}
#########################################################################################################################################



# giving the forced machine policy about 2 minutes to start working so that we can maybe succeed the first go around instead of waiting an hour or more.
#put the lock in early so that it keeps it clean. lock is removed at either end of done or end of fail
"lock" | out-file "$smdir\$datetime.lock"
start-sleep -Seconds 120

ren "$smdir\$datetime.deploy" "$smdir\$datetime.deploy-Active"

"monitor renamed deploy to active at top of script" | Out-File -append $smdir\bug.log
$gcsmdirdeploy = Get-Content "$smdir\$datetime.deploy-Active" | Measure-Object –Line
"gcsmdirdeploy value" | Out-File -append $smdir\bug.log
$gcsmdirdeploy.Lines | Out-File -append $smdir\bug.log

#moved the regkey check to here to get it out of the loop so that it only ran once instead of constantly for each point in array as it was not necessary
#dir "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System\" | where { $_.LastWriteTime -gt (Get-Date).AddDays(-1) } | foreach-object -Process { $_.Name | out-file -Append "$smdir\ccmregcheck.unus"}
 
 if([int]$gcsmdirdeploy.Lines -ge 1){
 "hi"  | Out-File -append $smdir\bug.log
 $testthis =  Get-Content "$smdir\$datetime.deploy-Active"
 $testthis | Out-File -append $smdir\bug.log
 Get-Content "$smdir\$datetime.deploy-Active" | % {
   "get content of deploy active" | Out-File -append $smdir\bug.log
          $x = 0
        $test = $_
  "this is whats in the deploy active file" | Out-File -append $smdir\bug.log
  $test |  Out-File -append $smdir\bug.log

$trimtest = $test.TrimStart("SWDC")
$trimtest | Out-File -append $smdir\bug.log
" checking package for first time" | out-file -Append $smdir\bug.log
$package = gwmi -Namespace root\ccm\clientsdk -Class ccm_softwarebase | Where-Object {$_.Packagename -match "^$trimtest"}
if($package -eq $null){
#sleep 2 minutes
start-sleep -Seconds 120
}
# run again.
" checking package for second time" | out-file -Append $smdir\bug.log
$package = gwmi -Namespace root\ccm\clientsdk -Class ccm_softwarebase | Where-Object {$_.Packagename -match "^$trimtest"}
if($package -eq $null){
"needs to recheck.not enough time"  | Out-File -append $smdir\bug.log }
else{
$package = gwmi -Namespace root\ccm\clientsdk -Class ccm_softwarebase | Where-Object {$_.Packagename -match "^$trimtest"}
"writing out package variable" | Out-File -append $smdir\bug.log
$package.PackageName | Out-File -append $smdir\bug.log
}

 if($package){
 $finderrorcode =  $package.lastexitcode | select-string -Pattern " 0" 
 $finderrorcode | Out-File -append $smdir\bug.log

      if($finderrorcode -ne $null) { 
       "success found exit code 0" | Out-File -append $smdir\bug.log
       
         $success | out-file -append $smdir\$datetime.done;
         $err = " Success"
         "$machinename,$trimtest,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,n/a,$logonserver,Installed,$mac,$ip" | out-file -append $smdir\$datetime.done
         if(!(test-path("$wipserver\done"))){
" wip server folders not set " | Out-File -append $smdir\bug.log
mkdir "$wipserver\done"}
         Get-Content $smdir\$datetime.done | Set-Content "\\10.30.164.71\data-in\done\$env:COMPUTERNAME-$datetime.done"
         # going to wait here for 2 minutes to see if this can help catch a new install and not have to waste time with the full hour wait.
         start-sleep -Seconds 120
         } else { 
         "package found but 0 exit code not found"  | Out-File -append $smdir\bug.log;
          $finderrorcode =  $package.lastexitcode 
          $finderrorcode | Out-File -append $smdir\bug.log
          $err = "$finderrorcode  is the exit code"
          "$machinename,$trimtest,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,n/a,$logonserver,Installed,$mac,$ip" | out-file -append $smdir\$datetime.done
           Get-Content $smdir\$datetime.done | Set-Content "\\10.30.164.71\data-in\done\$env:COMPUTERNAME-$datetime.done"
          }
      
       } else { "package not found yet, going to recheck." | Out-File -append $smdir\bug.log; "recheck" | out-file "$smdir\$datetime.recheck" ; $trimtest | out-file -append "$smdir\$datetime.wait"  }

 } 
 
 } else { "stop" | Out-File -append $smdir\bug.log; exit}
 
 #"skipped above" | Out-File -append $smdir\bug.log; exit

if(Test-Path("$smdir\$datetime.recheck")){
Get-Content "$smdir\$datetime.wait" | % {
    $err = " waiting for an hour.didnt find ccm log activity on app yet."
    # this grabs each app and then writes it out to reportwait. its why the get-content has the array creation on this one and i end the loop right after reportwait
    "$machinename,$_,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,n/a,$logonserver,waiting,$mac,$ip"  | out-file -append "$smdir\$datetime.reportwait"
   
    }
if(!(test-path("$wipserver\wait"))){
" wip server folders not set " | Out-File -append $smdir\bug.log
mkdir "$wipserver\wait"}
 Get-Content "$smdir\$datetime.reportwait" | Set-Content "\\10.30.164.71\data-in\wait\$env:COMPUTERNAME-$datetime.wait"
"starting to sleep for 1 hour to recheck sccm log" | Out-File -append $smdir\bug.log
Start-Sleep -seconds 3600
"back after running 60 min sleep due to wait file being created" | Out-File -append $smdir\bug.log
# after 60 minute wait read wait file


$checkwait = get-Content "$smdir\$datetime.recheck" 
" got content of wait" | Out-File -append $smdir\bug.log
if($checkwait -eq "recheck"){
"recheck done on wait file" | Out-File -append $smdir\bug.log
Get-Content "$smdir\$datetime.wait" | % {
$test = $_
$trimtest = $test.TrimStart("SWDC")
$trimtest | Out-File -append $smdir\bug.log

 $package = gwmi -Namespace root\ccm\clientsdk -Class ccm_softwarebase | Where-Object {$_.Packagename -match "^$trimtest"}
"writing out package variable" | Out-File -append $smdir\bug.log
$package.PackageName | Out-File -append $smdir\bug.log


$compareappDeployToCCMLog = select-string -Pattern $trimtest -Path C:\Windows\CCM\Logs\AppEnforce.log -Context 1,1
 if( $compareappDeployToCCMLog) {
 $err = "Success. Program was found."
 "$machinename,$trimtest,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,n/a,$logonserver,Installed,$mac,$ip" | out-file -append $smdir\$datetime.done
  Get-Content $smdir\$datetime.done | Set-Content "\\10.30.164.71\data-in\done\$env:COMPUTERNAME-$datetime.done"
  "skip" | Out-File -Append $smdir\skip.done
  "wrote skip.done" | Out-File -append $smdir\bug.log
 }
 if(!(test-path("$smdir\skip.done"))){
 "skip.done not found" | Out-File -append $smdir\bug.log
  if( $package ){
  "deploy name equaled in wmi query" | Out-File -append $smdir\bug.log
  "get exit code" | Out-File -append $smdir\bug.log
 $getexitcode = $package.lastexitcode
 $getexitcode | Out-File -append $smdir\bug.log
  $err = "Success. Program was found."
 "$machinename,$trimtest,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,n/a,$logonserver,Installed,$mac,$ip" | out-file -append $smdir\$datetime.done
 if(!(test-path("$wipserver\done"))){
" wip server folders not set " | Out-File -append $smdir\bug.log
mkdir "$wipserver\done"}
 Get-Content $smdir\$datetime.done | Set-Content "\\10.30.164.71\data-in\done\$env:COMPUTERNAME-$datetime.done"

 } else {

 $compareDeployToCCMLog = select-string -Pattern $trimtest -Path $sccmexeclog -Context 1,1
 
if($compareDeployToCCMLog){
  "deploy name equaled in ccm log name" | Out-File -append $smdir\bug.log
  "get exit code" | Out-File -append $smdir\bug.log
 $getexitcode = $compareDeployToCCMLog | Select-String -Pattern "exit code" 
 $getexitcode | Out-File -append $smdir\bug.log
 if ($getexitcode){
   $err = "Success. Program was found."
 "$machinename,$trimtest,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,n/a,$logonserver,Installed,$mac,$ip" | out-file -append $smdir\$datetime.done
   "skip" | Out-File -Append $smdir\skip.done
  "wrote skip.done" | Out-File -append $smdir\bug.log
 }

 $alreadyrun = $getexitcode | select-string -Pattern " will not run because"
 }
 if(!(test-path("$smdir\skip.done"))){
 if($alreadyrun) { $err = "Failed. Wont run again."} 
  $package.PackageName + "Failed" | Out-File -append $smdir\bug.log
   
 "$machinename,$trimtest,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,n/a,$logonserver,failed install,$mac,$ip" | out-file -append $smdir\$datetime.fail-report
 }
 }
 }
 }
  }
 }
 $gcsmdirdone = Get-Content "$smdir\$datetime.done" | Measure-Object –Line
 "output of gcsmdirdone" | Out-File -append $smdir\bug.log
 $gcsmdirdone.lines | Out-File -append $smdir\bug.log
 
 if ($gcsmdirdone.lines -ge $gcsmdirdeploy.lines) {
 " all deployments done" | Out-File -append $smdir\bug.log

 #send status
 #get tech id
 $gettech = Get-Content $smdir\$datetime.tech
 #$emailtech = $gettech + "@stateauto.com"
 $countapps = ""
    $finalgcsmdirdone = Get-Content "$smdir\$datetime.done" | Measure-Object –Line
    $countapps = $finalgcsmdirdone.lines
    $countapps  | Out-File -append $smdir\bug.log
  $messageparameters = @{
  Subject = "ADMIN3 Notification ## $env:COMPUTERNAME - All Apps Deployed "
  body = "Computer: $env:COMPUTERNAME </br>Date: $datetime </br> <a href='http://10.30.164.71:3000/dashboard'>Dashboard</a></br> You had $countapps App(s) in your deployment."
  from = $gettech
  to = $gettech
  smtpserver = "outlookdc1.corp.stateauto.com"
  }
  if(!(test-path("$wipserver\fail"))){
" wip server folders not set " | Out-File -append $smdir\bug.log
mkdir "$wipserver\fail"}
 Get-Content $smdir\$datetime.fail-report | Set-Content "\\10.30.164.71\data-in\fail\$env:COMPUTERNAME-$datetime.fail"
  send-mailmessage @messageparameters -bodyashtml
  ren "$smdir\$datetime.deploy-Active" "$smdir\$datetime.deploy-Archive"
  "renamed active to archive after completing done" | Out-File -append $smdir\bug.log
  mkdir "$smdir\archive\$datetime\$trimtest"
   xcopy $smdir\*.d* "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\*.sm* "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\ccmregcheck.unus "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\*.fail "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\*.wait "$smdir\archive\$datetime\*" /y
   xcopy $smdir\*.late "$smdir\archive\$datetime\*" /y
   xcopy $smdir\*.reportwait "$smdir\archive\$datetime\*" \y
   xcopy $smdir\*.recheck "$smdir\archive\$datetime\$trimtest\*" \y
    xcopy $smdir\*.fail-report "$smdir\archive\$datetime\*" \y
   Remove-Item $smdir\*.d*
   Remove-Item $smdir\*.sm*
   Remove-Item $smdir\*.sm*
   ri $smdir\*.wait 
   ri $smdir\*.reportwait
   ri $smdir\*.late 
   ri $smdir\*.fail
   ri $smdir\*.recheck
   ri "$smdir\$datetime.lock"
   ri  $smdir\$datetime.tech
   ri $smdir\$datetime.fail-report
   "removed smdir stuff" | Out-File -append $smdir\bug.log
   ri $smdir\ccmregcheck.unus
   "running productslistmof" | Out-File -append $smdir\bug.log
   c:\Windows\System32\wbem\mofcomp.exe "c:\packages\scriptmonitor\productslist.mof"
   $datetimefull | out-file "$smdir\$datetime.lastsend"
   get-content "$smdir\$datetime.lastsend" | Set-Content "\\10.30.164.71\data-in\clients\$machinename.lastsend"
exit
 } else {


 $gcsmdirdone = Get-Content "$smdir\$datetime.done" | Measure-Object –Line

  if ($gcsmdirdone.lines -ge $gcsmdirdeploy.lines) {
   "all deploys done" | Out-File -append $smdir\bug.log
  } else {
    #get tech id
 $gettech = Get-Content $smdir\$datetime.tech
    ren "$smdir\$datetime.deploy-Active" "$smdir\$datetime.deploy-Archive"
    "renamed active to archive in the failed section" | Out-File -append $smdir\bug.log
 $messageparameters = @{
  Subject = "ADMIN3 Notification ## $env:COMPUTERNAME - App Failure"
  body = "Computer: $env:COMPUTERNAME </br>Date: $datetime </br><a href='http://10.30.164.71:3000/fail'>Dashboard</a></br>"
  from = $gettech
  to = $gettech
  smtpserver = "outlookdc1.corp.stateauto.com"
  }
  
  send-mailmessage @messageparameters -bodyashtml

 if(!(test-path("$wipserver\fail"))){
" wip server folders not set " | Out-File -append $smdir\bug.log
mkdir "$wipserver\fail"}
 Get-Content $smdir\$datetime.fail-report | Set-Content "\\10.30.164.71\data-in\fail\$env:COMPUTERNAME-$datetime.fail"
   mkdir "$smdir\archive\$datetime\$trimtest"
   xcopy $smdir\*.d* "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\*.sm* "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\ccmregcheck.unus "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\*.fail "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\*.wait "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\*.late "$smdir\archive\$datetime\$trimtest\*" /y
   xcopy $smdir\*.reportwait "$smdir\archive\$datetime\$trimtest\*" \y
   xcopy $smdir\*.recheck "$smdir\archive\$datetime\$trimtest\*" \y
   Remove-Item $smdir\*.d*
   Remove-Item $smdir\*.sm*
   Remove-Item $smdir\*.sm*
   ri $smdir\*.wait 
   ri $smdir\*.reportwait
   ri $smdir\*.late 
   ri $smdir\*.fail
   ri $smdir\*.recheck
   ri "$smdir\$datetime.lock"
   ri  $smdir\$datetime.tech
   "removed smdir stuff failed portion" | Out-File -append $smdir\bug.log
   ri $smdir\ccmregcheck.unus
      $datetimefull | out-file "$smdir\$datetime.lastsend"
   get-content "$smdir\$datetime.lastsend" | Set-Content "\\10.30.164.71\data-in\clients\$machinename.lastsend"
  
  }
  }
  # else {
  #write-host " no config file found"
  #"no config found $datetimefull" | out-file $smdir\$datetime.noconfig
  #}