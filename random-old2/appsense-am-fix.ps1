# rebuild appsense am

#1. make sure that the gpo is set for 8.3
# 1a.apply russells fix
#2. uninstall the am agent 
#3. reinstall the am agent 8.8 
#4 uninstall am config
#5 install new 8.8 am config

# put events in event log for each step
# write an install log for each step
# create a done status event with pertinent info


# this needs to be set to anything other than 1. 0 or 2 are fine
#HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\NtfsDisable8dot3NameCreation

# or check this one
#HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisable8dot3NameCreation

###################begin variables################################
 $alert = "$machinename,$err,$datetimefull"
 $machinename = $env:COMPUTERNAME
 $err = ""
 $wipserver = "\\server\data-in"
 $log = "C:\Packages\appsense_am_fix.log"
 $datetime = Get-Date -Format "yyyyMMdd";
 $datetimefull = Get-Date -Format "yyyyMMddHHmmss";
 $os = (Get-CimInstance Win32_OperatingSystem).version
 $proc = $env:PROCESSOR_ARCHITECTURE
 $imgver = [Environment]::GetEnvironmentVariable("imgver","machine")
 $model = (Get-WmiObject Win32_Computersystem).model
 $amsource = "C:\Packages\amfix"
#################end of variables#################################
if(!(Test-Path("$wipserver\amfix"))){
mkdir "$wipserver\amfix" }

$unus = Get-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Policies\"
if($unus.GetValue("NtfsDisable8dot3NameCreation") -eq $null) {
$checkkey = "failed"
} else {
$checkkey = "true"
if($unus.GetValue("NtfsDisable8dot3NameCreation") -eq "1"){
$checkkey = "failed"}

}
if($checkkey -eq "true"){ break;} else {
    $duo = Get-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem\"
    if($unus.GetValue("NtfsDisable8dot3NameCreation") -eq $null) {
    $checkkey = "failed"
} else {
$checkkey = "true"
if($duo.GetValue("NtfsDisable8dot3NameCreation") -eq "1"){
$checkkey = "failed"}
}
}
if($checkkey -eq "true"){ break;} else {

"GPO not applied to machine" | out-file -append $log
$err = "GPO not applied to machine"
$alert | set-content $wipserver\amfix\$machinename-$datetime-amfix.csv
}
"GPO applied to machine" | Out-File -Append $log
$datetimefull | out-file -Append $log
"start with Appinit portion" | out-file -Append $log

##################################################################
### Appinit fix by Russell #######################################
##################################################################

$appkeys32 = @("c:\progra~1\appsense\applic~1\agent\amldra~1.dll","c:\progra~1\appsense\applic~1\agent\amapphook.dll")
$badkeys32 = @("c:\progra~1\appsense\application manager\agent\amapphook.dll ","c:\progra~1\appsense\application manager\agent\amapphook.dll","c:\progra~1\appsense\application ","c:\progra~1\appsense\application","manager\agent\amapphook.dll ","manager\agent\amapphook.dll")

$appkeys64 = @("c:\progra~2\appsense\applic~1\agent\amldra~1.dll","c:\progra~2\appsense\applic~1\agent\amapphook.dll")
$badkeys64 = @("c:\progra~2\appsense\application manager\agent\amapphook.dll ","c:\progra~2\appsense\application manager\agent\amapphook.dll","c:\progra~2\appsense\application ","c:\progra~2\appsense\application","manager\agent\amapphook.dll ","manager\agent\amapphook.dll")


$arch = Get-ItemProperty "hklm:\system\currentcontrolset\control\session manager\environment" | select -expandproperty Processor_Architecture


$origKey = Get-ItemProperty "hklm:\software\microsoft\windows nt\currentversion\windows" -name AppInit_Dlls | select -expandproperty AppInit_Dlls
$splitKey = $origKey.split(",")
$currentKey = $appkeys32

write-output $origKey | out-file c:\temp\appinit.bak -append

foreach ($key in $splitKey){
if (!($badkeys32 -contains $key)){
	if (!($appkeys32 -contains $key)){
		foreach ($bkey in $badkeys32){$key = $key -replace [Regex]::Escape($bkey), ""}
		$currentKey+=$key
		}
	}
}

$setKey = $currentKey -join ','

Set-ItemProperty "hklm:\software\microsoft\windows nt\currentversion\windows" -name AppInit_Dlls -value $setKey


if($arch -eq "AMD64"){

$origKey = Get-ItemProperty "hklm:\software\wow6432node\microsoft\windows nt\currentversion\windows" -name AppInit_Dlls | select -expandproperty AppInit_Dlls
$splitKey = $origKey.split(",")
$currentKey = $appkeys64

write-output $origKey | out-file c:\temp\appinit.bak -append

foreach ($key in $splitKey){
if (!($badkeys64 -contains $key)){
	if (!($appkeys64 -contains $key)){
		foreach ($bkey in $badkeys64){$key = $key -replace [Regex]::Escape($bkey), ""}
		$currentKey+=$key
		}
	}
}

$setKey = $currentKey -join ','

Set-ItemProperty "hklm:\software\wow6432node\microsoft\windows nt\currentversion\windows" -name AppInit_Dlls -value $setKey
}
"Done with Appinit portion" | out-file -Append $log
$datetimefull | out-file -Append $log

########### uninstall the AM agent ###################
"begin Am agent uninstall portion" | out-file -Append $log
if($proc -eq "AMD64"){
"Machine is 64 bit" | out-file -append $log
} else {
"Machine is 32 bit" | out-file -Append $log
}
if(!(test-path($amsource))){
mkdir $amsource
"made C:\Packages\amfix folder" | out-file -append $log
}
$datetimefull | Out-File -Append $log
"start uninstall of am msi" | out-file -Append $log

msiexec.exe /x /quiet "C:\Packages\amfix\ApplicationManagerAgent64.msi"

$datetimefull | Out-File -Append $log
"finished uninstall of am msi" | out-file -Append $log
#####################################################################
#reboot # 
#put in run once reg key to start again or just put this all in a task sequence.




