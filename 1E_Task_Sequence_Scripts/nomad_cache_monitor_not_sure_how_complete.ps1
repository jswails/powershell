

# script completed 12/20/2016

# john swails

$datetime = Get-Date -Format "yyyyMMdd";

$datetimefull = Get-Date -Format "yyyyMMddHHmmss";

#ncm = nomad cache monitor

if(test-path("c:\temp\ncm.path")){

$ncmdir = get-content c:\temp\ncm.path

}

if(!(test-path("c:\temp\ncmsetup.done"))){

$ncmdir = read-host "Where do you want to setup this Monitoring tool? e.g C: or d: dont use trailing slash"

$ncmdir | out-file c:\temp\ncm.path

"setup ran" | out-file -append c:\temp\debug-ncm.txt

}

if(!(test-path("$ncmdir\ncm"))){

mkdir $ncmdir\ncm;cd $ncmdir\ncm;mkdir found;mkdir good;mkdir bad;

# create the  css file if it doesnt exist.

if(!(test-path("$ncmdir\ncm\1.css"))){

$cssfile = "$ncmdir\ncm\1.css"

"body {" | out-file -Append $cssfile

"font-family:Calibri; " | out-file -Append $cssfile

"font-size:10pt; " | out-file -Append $cssfile

"}" | out-file -Append $cssfile

"th {  " | out-file -Append $cssfile

"background-color:blue; " | out-file -Append $cssfile

"color:white; " | out-file -Append $cssfile

"} " | out-file -Append $cssfile

"td { " | out-file -Append $cssfile

" background-color:light-blue; " | out-file -Append $cssfile

"color:black; " | out-file -Append $cssfile

"} " | out-file -Append $cssfile

}

# end of css file creation

"$datetimefull + Nomad Cache Monitoring tool setup" | out-file c:\temp\ncmsetup.done

}

$ncmdir = get-content c:\temp\ncm.path

write-host -ForegroundColor Red " REMINDER: You need a Serverlist.txt in tool path"

write-host -ForegroundColor Green " Your current tool path is" + "$ncmdir\ncm"

 

$ncm = "$ncmdir\ncm"

$ncm | out-file -append c:\temp\debug-ncm.txt

$serverlist = "$ncm\serverlist.txt"

$foundlog = "$ncm\found"

$foundlog | out-file -append c:\temp\debug-ncm.txt

$goodlog = "$ncm\good"

$badlog = "$ncm\bad"

[string]$pkgid = read-host "Enter a packageID for the package e.g pr1004af, automatically checks boot wim each time in addition:"

 

$servers2 = Get-Content $serverlist

 


$server_count = $servers2.length

$i = 0

foreach( $server in $servers2){

$server_progress = [int][Math]::Ceiling((($i / $server_count) * 100 ))

write-progress -activity "Checking Servers" -percentComplete $server_progress -status "Processing Servers - $server_progress%" -id 1

sleep(1)

$ifupconnection = Test-Connection -Count 1 -ComputerName $server

 

if($ifupconnection){

$server | out-file -Append $foundlog\$datetime-found-server-$pkgid.log

} else {

$server | out-file -Append $badlog\$datetime-noping-server-$pkgid.log

}

}

$serverstocheck = get-content $foundlog\$datetime-found-server-$pkgid.log

foreach($upserver in $serverstocheck){

$path = "\\$upserver\d$\NomadCache\NomadBranch\$pkgid" + "_Cache"

write-host $path

if(test-path("$path")){

"$path" | out-file -append $foundlog\$datetime-$pkgid.log

if(!(test-path("$ncmdir\workstations"))){

mkdir $ncmdir\workstations

}

if(!(test-path("$ncmdir\workstations\$upserver"))){

mkdir $ncmdir\workstations\$upserver

}

if(!(test-path("$ncmdir\workstations\$upserver\$datetime"))){

mkdir "$ncmdir\workstations\$upserver\$datetime"}

 

 

dir \\$upserver\C$\ProgramData\1E\PXELite\TftpRoot\Images\PR100311 > $ncmdir\workstations\$upserver\$datetime\bootwim_keys.txt

if(!(test-path("\\$upserver\d$\NomadCache\NomadBranch\skpswi.dat"))){

$upserver | out-file -Append $badlog\$datetime-skpswi-missing.log

}

# checking services here.

 

"<h1> $upserver </h1>" | out-file -append "$foundlog\$datetime-services.html"

 

$smsagent = Get-wmiobject win32_service -computername $upserver -filter "displayname = 'SMS Agent Host'" | select-object -property DisplayName,StartMode,State,Status

 

$EmptyArray = @()

 

if(!($smsagent)){

$serviceobject = New-Object psobject

$serviceobject | Add-Member -MemberType noteproperty -name "Server" -value $($upserver)

$serviceobject | Add-Member -MemberType noteproperty -name "CurrentStatus" -value "Down"

$EmptyArray += $serviceobject

}

 

foreach($unus in $smsagent)

{

    $serviceobject = New-Object psobject

 

$serviceobject | Add-Member -MemberType noteproperty -name "DisplayName" -value $($unus.displayname)

$serviceobject | Add-Member -MemberType noteproperty -name "StartMode" -value $($unus.startmode)

$serviceobject | Add-Member -MemberType noteproperty -name "CurrentState" -value $($unus.state)

$serviceobject | Add-Member -MemberType noteproperty -name "CurrentStatus" -value $($unus.status)

 

$EmptyArray += $serviceobject

}

$EmptyArray  | convertto-html  | out-file -append "$foundlog\$datetime-services.html"

 

 

$nomadagent = Get-wmiobject win32_service -computername $upserver -filter "name = 'NomadBranch'" | select-object -property DisplayName,StartMode,State,Status

 

$EmptyArray = @()

 

if(!($nomadagent)){

$serviceobject = New-Object psobject

$serviceobject | Add-Member -MemberType noteproperty -name "Server" -value $($upserver)

$serviceobject | Add-Member -MemberType noteproperty -name "CurrentStatus" -value "Down"

$EmptyArray += $serviceobject

}

 

foreach($duo in $nomadagent)

{

    $serviceobject = New-Object psobject

 

$serviceobject | Add-Member -MemberType noteproperty -name "DisplayName" -value $($duo.displayname)

$serviceobject | Add-Member -MemberType noteproperty -name "StartMode" -value $($duo.startmode)

$serviceobject | Add-Member -MemberType noteproperty -name "CurrentState" -value $($duo.state)

$serviceobject | Add-Member -MemberType noteproperty -name "CurrentStatus" -value $($duo.status)

 

$EmptyArray += $serviceobject

}

$EmptyArray  | convertto-html  | out-file -append "$foundlog\$datetime-services.html"

 

 

 

$pxeagent = Get-wmiobject win32_service -computername $upserver -filter "name = 'PXELiteServer'" | select-object -property DisplayName,StartMode,State,Status

 

$EmptyArray = @()

 

if(!($pxeagent)){

$serviceobject = New-Object psobject

$serviceobject | Add-Member -MemberType noteproperty -name "Server" -value $($upserver)

$serviceobject | Add-Member -MemberType noteproperty -name "CurrentStatus" -value "Down"

$EmptyArray += $serviceobject

}

foreach($tres in $pxeagent)

{

    $serviceobject = New-Object psobject

 

$serviceobject | Add-Member -MemberType noteproperty -name "DisplayName" -value $($tres.displayname)

$serviceobject | Add-Member -MemberType noteproperty -name "StartMode" -value $($tres.startmode)

$serviceobject | Add-Member -MemberType noteproperty -name "CurrentState" -value $($tres.state)

$serviceobject | Add-Member -MemberType noteproperty -name "CurrentStatus" -value $($tres.status)

 

$EmptyArray += $serviceobject

}

$EmptyArray  | convertto-html | out-file -append "$foundlog\$datetime-services.html"

 

 

 

#check boot wim date

$checkbootwim = Select-String -SimpleMatch "11/8/2016" -Path $ncmdir\workstations\$upserver\$datetime\bootwim_keys.txt

$checkbootwim1 = Select-String -SimpleMatch "11/4/2016" -Path $ncmdir\workstations\$upserver\$datetime\bootwim_keys.txt

 

if($checkbootwim -eq $null){

    if($checkbootwim1 -eq $null){

"$upserver"  | out-file -append $badlog\$datetime-badbootwim.log

write-host -ForegroundColor Red "Boot wim is not most current. Check file for details. It might not exist"

}

}

 

 

$upserver | out-file -Append $foundlog\$datetime-found-path-$pkgid.log

} else {

# path not found so goes to bad log

"$path" | out-file -append $badlog\$datetime-$pkgid.log

}

}

$i++

 

$foundservers = get-content $foundlog\$datetime-found-path-$pkgid.log

$x = 0

if(!(test-path("$foundlog\$datetime-found-path-$pkgid.log"))){

write-host " no correct paths found due to either permissions or lack of content or mistyped package path"

write-progress -activity "Failed to check all servers" -percentcomplete 100 -status "Failed " -id 1

sleep(1)

pause

}

foreach($fserver in $foundservers){

$file_progress = [int][Math]::Ceiling((($x / $server_count) * 100 ))

write-progress -activity "Checking Found Server" -percentComplete $file_progress -status "Creating the Batch File for Servers - $file_progress%" -id 2

sleep(1)

##### old way before wmi code####

#$fpath = "\\$fserver\d$\NomadCache\NomadBranch\$pkgid" + "_Cache"

#$countfound = (gci -Recurse $fpath).count

#"$countfound,$fserver" | out-file -append $foundlog\$datetime-counts.log

#if($countfound -eq $expectedcount){

#write-host $countfound

#"$countfound,$fserver" | out-file -append $goodlog\$datetime-counts.log

#} else {

#"$countfound,$fserver" | out-file -append $badlog\$datetime-counts.log

######end section old way left for now #####

 

#$nomadpackages = Get-WmiObject nomadpackages | Where-Object {$_.packageid -eq "$pkgid"}

#$pkgdisksize = $nomadpackages.diskusagekb

#$pkgelapsed = $nomadpackages.elapsedseconds

#$pkgreturnstate = $nomadpackages.returnstatus

#$pkgbytespeer = $nomadpackages.bytesfrompeer

#$pkgbytesdp = $nomadpackages.bytesfromdp

#$pkgstarttime = $nomadpackages.starttimeutc

#$pkgpercent = $nomadpackages.percent

 

#$nomadpackages = Get-WmiObject nomadpackages -computername $fserver | Where-Object {$_.packageid -eq "$pkgid"} | select-object -Property PSComputerName,diskusagekb,elapsedseconds,returnstatus,bytesfrompeer,bytesfromdp,starttimeutc,percent | ConvertTo-HTML -Fragment |

 

#convertto-html -body "$nomadpackages" -title " Reporting for $pkgid" -CssUri $ncmdir\ncm\1.css | out-file -append $ncm\$pkgid-$datetime.html

#if(!($nomadpackages)){

#$fserver | out-file -append $badlog\$datetime.log

# due to security lockdown with remote wmi have to write the script local to the machine and then execute it locally and get the results remotely back to script

 

if(!(test-path("\\$fserver\c$\temp"))){

mkdir \\$fserver\c$\temp

}

# this silly step had to be created due to a formatting issue whereas if i created the script with an outfile only it was corrupt but this get/set and xcopy worked fine

"powershell.exe -file c:\temp\ncm.ps1 $pkgid" | out-file c:\temp\ncm.bat

get-content c:\temp\ncm.bat | set-content \\$fserver\c$\temp\ncm.bat

get-content $ncm\nomad_keys_batch.bat | set-content \\$fserver\c$\temp\nomad_keys_batch.bat

if(test-path("\\$fserver\c$\temp\ncm.ps1")){

remove-item \\$fserver\c$\temp\ncm.ps1

}

# create the ps file to run locally on the remote server ##########################################

'param([string]$pkgid)' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$machinename = $env:COMPUTERNAME' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$datetime = Get-Date -Format "yyyyMMdd";' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$nomadpackages = Get-WmiObject nomadpackages | Where-Object {$_.packageid -eq "$pkgid"}' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$pkgdisksize = $nomadpackages.diskusagekb' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$pkgelapsed = $nomadpackages.elapsedseconds' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$pkgreturnstate = $nomadpackages.returnstatus' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$pkgbytespeer = $nomadpackages.bytesfrompeer' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$pkgbytesdp = $nomadpackages.bytesfromdp' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$pkgstarttime = $nomadpackages.starttimeutc' | out-file -append \\$fserver\c$\temp\ncm.ps1

'$pkgpercent = $nomadpackages.percent' | out-file -append \\$fserver\c$\temp\ncm.ps1

 

'"$machinename,$pkgdisksize,$pkgelapsed,$pkgreturnstate,$pkgbytespeer,$pkgbytesdp,$pkgstarttime,$pkgpercent" | out-file c:\temp\$machinename-$pkgid-$datetime.csv' | out-file -append \\$fserver\c$\temp\ncm.ps1

##################################################################################################

# end of creation of ps file for remote execution

# had to create a batch file that can be run after fact outside of powershell as psexec cannot be run inside of powershell.

"######### $x ##########" | out-file -append $ncm\RUN_THIS_BATCH_$datetime.txt

'c:\windows\system32\psexec.exe' + " " +  "\\$fserver" + " " + '-d -n 15 c:\temp\ncm.bat' | out-file -append $ncm\RUN_THIS_BATCH_$datetime.txt

'c:\windows\system32\psexec.exe' + " " +  "\\$fserver" + " " + '-d -n 15 c:\temp\nomad_keys_batch.bat' | out-file -append $ncm\RUN_THIS_BATCH_$datetime.txt

"######### $x ##########" | out-file -append $ncm\RUN_THIS_BATCH_$datetime.txt

get-content $ncm\RUN_THIS_BATCH_$datetime.txt | set-content $ncm\RUN_THIS_BATCH_$datetime.bat

 

$x++

#}

#write-progress -activity "Finished Confirming Files Size" -percentcomplete 100 -status "Done - 100%"-id 2

#sleep(1)

 

}

write-progress -activity "Checked all servers" -percentcomplete 90 -status "Done with initial part. Now you need to run batch file that was created in the ncm directory to finish up. Come back here - 90%" -id 1

sleep(1)

write-host -backgroundcolor DarkMagenta "Alert. Response needed here after you finish running the batch file"

write-host -BackgroundColor white -ForegroundColor Red " Run the batch file now if you want to collect the reported files. Otherwise kill the script."

[string]$batchdone = read-host  "Type done here when done or exit to leave and get reporting end:"

# this pause is put in to wait till the batch file is done.

 

 

if($batchdone -eq "done"){

write-progress -activity "Starting gathering of Reporting" -percentcomplete 0 -status "Starting - 0%"-id 3

sleep(1)

# setup the csv header

"ServerName,DiskUsage,ElapsedTime,ReturnStatus,BytesfromPeer,BytesfromDP,StartTimeUTC,PercentDone" | out-file -append $ncm\good\$pkgid-$datetime-cachereport.csv

foreach($rserver in $foundservers){

xcopy /y \\$rserver\c$\temp\*_keys.txt "$ncmdir\workstations\$rserver\$datetime"

 

#check active efficiency key

$checkae = select-string -simplematch "PlatformUrl"  -path $ncmdir\workstations\$rserver\$datetime\ae_keys.txt

$checkae | select-string -SimpleMatch "pdwcmnomad01"

if($checkae -eq $null){

write-host -ForegroundColor Red " $rserver Active Efficiency Key is not set correctly. Check it."

" $rserver" | out-file -append $badlog\AEbad-$datetime.log

}

 

if(test-path("\\$rserver\c$\temp\$rserver-$pkgid-$datetime.csv")){

get-content \\$rserver\c$\temp\$rserver-$pkgid-$datetime.csv | out-file -append $ncm\good\$pkgid-$datetime-cachereport.csv

} else {

write-host " psexec failed on $rserver"

" psexec failed on $rserver or powershell failed" | out-file -append $ncm\bad\$pkgid-$datetime-failedpsexec.log

}

}

write-progress -activity "Done gathering of Reporting" -percentcomplete 100 -status "Done - 100%"-id 3

sleep(1)

}

write-host -BackgroundColor black -ForegroundColor green "Your report is ready at $ncm\good ->$pkgid-$datetime-cachereport.csv"

write-host -ForegroundColor red -BackgroundColor white "check the captured settings and logs here ->  $ncmdir\$server\$datetime"

xcopy $ncm\good\$pkgid-$datetime-cachereport.csv '\\lcnu324b2f3\c$\temp\ncm_logs'

 

 

if($batchdone -eq "exit"){

write-host "check folders for the initial data that was gathered before batch run was not done"

 

}

# immediate reporting

$getfailedpsexec = (get-content $ncm\bad\$pkgid-$datetime-failedpsexec.log).count

write-host " $getfailedpsexec failed to connect via psexec or powershell failed"

 

$getbadbootwim = (get-content $badlog\$datetime-badbootwim.log).count

write-host " count of machines with bad boot wim = $getbadbootwim "

 

$getnopackageid = (get-content $badlog\$datetime-$pkgid.log).count

write-host " count of machines with no pkgid found = $getnopackageid "

 

$getnoping = (get-content $ncm\bad\$datetime-noping-server-$pkgid.log).count

write-host " count that did not ping from total count = $getnoping"

 

$gettotalcount = (Get-Content $serverlist).count

write-host " total count that was started with = $gettotalcount"

 

" total count that was started with = $gettotalcount" | out-file $ncm\$datetime-counts.txt

" count that did not ping from total count = $getnoping" | out-file $ncm\$datetime-counts.txt

" count of machines with no pkgid found = $getnopackageid " | out-file $ncm\$datetime-counts.txt

" count of machines with bad boot wim = $getbadbootwim " | out-file $ncm\$datetime-counts.txt

" $getfailedpsexec failed to connect via psexec or powershell failed" | out-file $ncm\$datetime-counts.txt

