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



# get name of app install need to have a list that equates name of app install to what appears in ARP
# create sccm collection that machine is put in to deploy the script monitor. it executes the script and cleans up previous runs.
# need to create data collectors on admin3 for management portal
# the installer also sets up the mof program and runs that. copies over the mof from admin3 and runs its locally to setup wmi

# when admin3 is used have to edit the page to capture each app into a separate config file this file is put on admin3 in a folder for that computer and datetime
# when script monitor starts it searchs for config file on admin3
# write something to have it check for current date and if there is one then add to it if on same day they go back to machine
$rowheaders = "machinename,appname,message,datetime,tech,os,processor,imgver,osmodel,status,location,deploystat,mac,ip"
$smdir =  "C:\Packages\scriptmonitor"
$err = ""
$begin = ""
$wipserver = "\\10.30.164.71\data-in"
$datetime = Get-Date -Format "yyyyMMdd";
$datetimem = Get-Date -Format "yyyyMMddHHmm";
 $datetimefull = Get-Date -Format "yyyyMMddHHmmss";
$prevday = (get-date -Format "yyyyMMdd") -1
$configroot = "\\admin3\scriptmonitor"
$sccmexeclog = "c:\windows\ccm\logs\execmgr.log"
$machinename = $env:computername
$os = (Get-CimInstance Win32_OperatingSystem).version
 $proc = $env:PROCESSOR_ARCHITECTURE
 $imgver = [Environment]::GetEnvironmentVariable("imgver","machine")
 $model = (Get-WmiObject Win32_Computersystem).model
"started wrapper" | Out-File -append $smdir\bug.log
#$datetime | Out-File -append $smdir\bug.log
$datetimem | Out-File -append $smdir\bug.log
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

####################################### setting printer logs to enabled####################3
 
$logName = 'Microsoft-Windows-PrintService/Operational'
# this enables the logging for the local printer
$log = New-Object System.Diagnostics.Eventing.Reader.EventLogConfiguration $logName
if($log.IsEnabled -ieq $false){
"print logging is false. will enable now" | Out-File -Append $smdir\bug.log
$log.IsEnabled=$true
$log.SaveChanges()
}
#############################################################################################
if(test-path("$smdir\printq.flag")){
#if printq.flag exists then run the printer queue audit script to monitor every 15 minutes.
"starting print queue monitor" | Out-File -Append $smdir\bug.log
    start-process powershell.exe -argument ' -file C:\Packages\scriptmonitor\audit-print-queue.ps1 '
    }

if(test-path("$smdir\$datetime.lock")){
exit}

if(test-path("$smdir\*.nocomputer")){
del $smdir\*.nocomputer
}
if(test-path("$smdir\*.noconfig")){
del $smdir\*.noconfig
}
if(test-path("$smdir\*.fail")){
del $smdir\*.fail
}
if(!(Test-Path("$sccmexeclog"))){
if(!(Test-Path("$wipserver\nosccmclient"))){
mkdir $wipserver\nosccmclient
}
"sccm client not installed" | Out-File -Append $smdir\bug.log
$err = " No SCCM Client Installed"
"$machinename,n\a,$err,$datetimefull,n\a,$os,$proc,$imgver,$model,n/a,$logonserver,n/a,$mac,$ip" | out-file $smdir\$datetime.nosccmclient
Get-Content $smdir\$datetime.nosccmclient | Set-Content \\10.30.164.71\data-in\nosccmclient\$env:COMPUTERNAME-$datetime.nosccmclient
exit}
# insert code here to check for last send.
# if last send of machine is greater than last send on server then send over archives
# have to setup a method of keeping last send on server. could have file on server for machinename with latest last send. wipe out and replace each new
#$glastsend = Get-Content "\\10.30.164.71\data-in\clients\$machinename.lastsend"
#$gcurlastsend = Get-Content "$smdir\$datetime.lastsend"
#if($glastsend -le $gcurlastsend) {
#"last send is less than current" | Out-File -append $smdir\bug.log
#}

if(!(test-path("$configroot\$datetime\$env:computername\$datetime.deploy"))){
"no config today yet" | out-file $smdir\$datetime.noconfig; exit }
#run the script if locally something found in past day this wrapper runs every 15 minutes. once it finds the local registry change then the config files come into play
# took this out it was redundant #dir "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System\" | where { $_.LastWriteTime -gt (Get-Date).AddDays(-1) } | foreach-object -Process { $_.Name | out-file $smdir\ccmregcheck.unus}
$begin = dir "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System\" | where { $_.LastWriteTime -gt (Get-Date).AddDays(-1) } 
$begin = "1"
 if($begin){
 "lets begin" | Out-File -append $smdir\bug.log
 # compare this day run of regcheck with archive regcheck to make sure its what we really want. if whats in previous days done exists in this current reg check then we dont want to assume its ready to use
 # need to get it to a state where another entry exists in reg keys
 #$prevcontent = get-content "$smdir\archive\$prevday\$prevday.done"
 #$prevcontent  | Out-File -append $smdir\bug.log
 #$duplicityprogramcheck =  $begin | Select-String -Pattern $prevcontent
 #if($duplicityprogramcheck){
 #"found duplicate program from previous day in done file" | Out-File -append $smdir\bug.log
 #exit }

if(!(test-path("$smdir\script-monitor.ps1"))) {
xcopy "\\sadc1cm12pkgp1\Packages\stateauto\scriptmonitor\script-monitor.ps1" "$smdir\"
}
# checking to see if active still around. if it is add to it.if not around that means that it should have become archived and can proceed with new run.
if(test-path("$smdir\$datetime.deploy-Active")) {
#read server deploy config and insert its config into current active config
if(!(test-path("$configroot\$datetime\$env:COMPUTERNAME"))){
if(!(test-path("$wipserver\nocomputer"))){
" wip server folders not set " | Out-File -append $smdir\bug.log
mkdir $wipserver\nocomputer}
$err = "configroot path for computer not created - wrapper" 
"$machinename,n\a,$err,$datetimefull,n\a,$os,$proc,$imgver,$model,n/a,$logonserver,n/a,$mac,$ip" | out-file $smdir\$datetime.nocomputer
Get-Content $smdir\$datetime.nocomputer | Set-Content \\10.30.164.71\data-in\nocomputer\$env:COMPUTERNAME-$datetime.nocomputer
exit }
if(test-path("$configroot\$datetime\$env:computername\$datetime.deploy")){
    if(Test-Path("$smdir\$datetime.lock")){
        "found lock. exiting." | Out-File -append $smdir\bug.log
        exit
        }
   
}
 } #else {
 # need to check at this point to see if its already run since all this checks for is has something run today and every 15 min it will say yes now unless stopped.
    #if(test-path("$smdir\archive\$datetime\ccmregcheck.unus")){
    #"wrapper found regcheck" | Out-File -append $smdir\bug.log
    #Get-Content $smdir\archive\$datetime\$datetime.deploy-Archive | % {
    #"wrapper found deploy archive" | Out-File -append $smdir\bug.log
    #$resultsfromserver = get-Content "$configroot\$datetime\$env:computername\$datetime.deploy" 
    #"wrapper writing results" | Out-File -append $smdir\bug.log
    #$resultsfromserver  | Out-File -append $smdir\bug.log
    #need to compare this content of archive to content of new run to see if already run
   #$duplicitycheck =  $_ | Select-String -Pattern $resultsfromserver
   #"wrapper writing duplicity check" | Out-File -append $smdir\bug.log
   #$duplicitycheck  | Out-File -append $smdir\bug.log
   #}
   #if($duplicitycheck){ "found dup" | Out-File -append $smdir\bug.log
   #$duplicitycheck | out-file "$smdir\duplicate.log"
   #} else { $_ | out-file "$smdir\process.log"}
   
  # }
 #  }


# run the file monitor
" about to run script monitor" | Out-File -append $smdir\bug.log

 start-process powershell.exe -argument ' -file c:\packages\scriptmonitor\script-monitor.ps1'
    "script-monitor end of script call finished" | Out-File -append $smdir\bug.log
    exit
    } else {
    " went to sms error part. no sms reg changes but did find deploy" | Out-File -append $smdir\bug.log
    if(test-path("$configroot\$datetime\$env:computername\$datetime.deploy")){
    #forcing machine policy here to speed things up for next check.
    $forcemachinepolicy = Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}"
"forced machine policy" | Out-File -append $smdir\bug.log

   [int]$checksms =  Get-content "$smdir\$datetime.smserr" 
   if(!(Test-Path("$smdir\$datetime.smserr"))){
        $x = 1
     [int]$x | out-file "$smdir\$datetime.smserr"
     } else {    $updatechk = [int]$checksms+1
    $updatechk | out-file "$smdir\$datetime.smserr"
    }

  
   if ($checksms -eq 5){
    $deploycontent = get-content $configroot\$datetime\$env:computername\$datetime.deploy
      $err = "possible problem with local sms client. no reg changes found for $deploycontent software push" 
      "$machinename,n\a,$err,$datetimefull,n\a,$os,$proc,$imgver,$model,n/a,$logonserver,n/a,$mac,$ip" | out-file "$smdir\$datetime.badsmspackage"
      if(!(test-path("$wipserver\badsmspackage"))){
" wip server folders not set " | Out-File -append $smdir\bug.log
mkdir $wipserver\badsmspackage}
      Get-Content $smdir\$datetime.badsmspackage | Set-Content \\10.30.164.71\data-in\badsmspackage\$env:COMPUTERNAME-$datetime.badsmspackage
      ri -path $smdir\$datetime.badsmspackage -Force
      ri -path $smdir\$datetime.smserr -force
            $x = 0
      exit} else {
          $updatechk = [int]$checksms+1
    $updatechk | out-file "$smdir\$datetime.smserr"
    }
      
      
      # this closes out the checksms


    } else {
   
    "nothing to process" | out-file "$smdir\nil.nil"
    exit}
     # this goes to the testpath of configroot

    #this close goes up to the  else at line 137 right below powershell.exe
    }
