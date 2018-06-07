# logonscript
# written by John Swails 10/27/2015
#
 $viewtype = ""
 $viewproto = ""
 $logondir =  "C:\Packages\logonscript"
 $datetime = Get-Date -Format "yyyyMMdd";
 $datetimefull = Get-Date -Format "yyyyMMddHHmmss";
 $machinename = $env:COMPUTERNAME
 $wipserver = "\\server\data-in"
 $user = $env:USERNAME
 $os = (Get-CimInstance Win32_OperatingSystem).version
 $proc = $env:PROCESSOR_ARCHITECTURE
 $imgver = [Environment]::GetEnvironmentVariable("imgver","machine")

 $buildts = get-content C:\packages\logonscript\buildts.txt
 $model = (Get-WmiObject Win32_Computersystem).model
 $logonserver = $env:LOGONSERVER
 $logondir =  "C:\Packages\logonscript"

 # networking shenanigans #############################

  $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $machinename |Where{$_.IpEnabled -Match "True"}  
      foreach ($objItem in $colItems) {  
    $objItem |select Description,MACAddress  
    $writemac = $objItem |select Description,MACAddress  
       $ip = $objItem.IPAddress | Select-Object -First 1
   } 
    $mac = $writemac.MACAddress
if($logonserver -eq $null) {
$logonserver = "none"}
######################################################
# check to see if online #
######################################################
if(!(test-path("$wipserver\logon"))){
$networkstatus = " Domain not accessible"
$send = "no"
}else {
$send = "yes"
$networkstatus = "Available"
}

# installed date #######################
$installed = (gwmi win32_operatingsystem).installdate
$iyear = $installed.substring(0,4)
$imonth = $installed.substring(4,6)
$iday = $imonth.substring(2,4)
$iday = $iday.Substring(0,2)
$imonth = $imonth.Substring(0,2)

$finalinstalled = "$imonth/$iday/$iyear"
#########################################

#### get view agent info #########################

 $viewtype = $env:ViewClient_Type
 $viewproto = $env:ViewClient_Protocol

 if ($viewtype -eq $null){
 $viewtype = "n/a"
 $viewproto = "n/a"
 }
 #################################################
 ############# check monitors ###############
 if (!($viewtype -eq $null)){
 $monitor1 = "VMWARE"
 $monitor2 = "VMWARE"
 $monitor3 = "VMWARE"
 $monitor4 = "VMWARE"
 } else {
 $monarray = @()
 Get-Content $logondir\monitor.txt | % {
 $monarray += $_
  }
  $monitor1 = $monarray[0]
   $monitor2 = $monarray[1]
 $monitor3 = $monarray[2]
 $monitor4 = $monarray[3]

 }
 

################## admin rights #################################
$adminrights = $env:adminrights
if($adminrights -eq $null) {
$adminrights = "incomplete"}

###################################################

if ($send -eq "yes"){
"$datetimefull,$machinename,$user,$os,$proc,$imgver,$model,$finalinstalled,$logonserver,$mac,$ip,$networkstatus,$monitor1,$monitor2,$monitor3,$monitor4,$adminrights,$viewtype,$viewproto,$buildts" | out-file -append $logondir\$env:COMPUTERNAME.logon
get-content $logondir\$env:COMPUTERNAME.logon | Set-Content "\\server\data-in\logon\$env:COMPUTERNAME-$datetimefull.logon"
ri $logondir\$env:COMPUTERNAME.logon
} else {
"$datetimefull,$machinename,$user,$os,$proc,$imgver,$model,$finalinstalled,$logonserver,$mac,$ip,$networkstatus,$monitor1,$monitor2,$monitor3,$monitor4,$adminrights,$viewtype,$viewproto,$buildts"  | out-file -append $logondir\$env:COMPUTERNAME.logon
}

