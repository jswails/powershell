# after machine is imaged and before the bios disables the wireless mac this script has to be run

# insert variable to state its a new image. check for this variable and if exists then run the script and send the email

$curtime = get-date -format MM/dd/yyyy-HH:mm:ss

$compname = $env:COMPUTERNAME

$getdriver = gwmi win32_networkadapter -filter "Name like '%centrino%'"

if ($getdriver -eq $null) {
$getdriver = gwmi win32_networkadapter -filter "Name like '%wifi%'"
 if ($getdriver -eq $null) { 
 # this is for surface pro
  gwmi win32_networkadapter -filter "ServiceName like '%WifiClass%'"
  }
}
$wmac = $getdriver.macaddress

if ($wmac -eq $null) {
$wmac = "Not Enabled"
 " $compname and $wmac " | out-file c:\temp\wirelessmac-$compname.txt
 exit
}
$wmac = $wmac.Replace(":", "-")
# app_appenseinstaller.application@stateauto.com
 " $compname and $wmac " | out-file c:\temp\wirelessmac-$compname.txt

$newimagevar = [Environment]::GetEnvironmentVariable("imagestate","machine")
# imagestate = 0 means it needs to run script to send email

$messageparameters = @{
  Subject = "MAC Automation – New computer for wireless"
  body = "Computer: $env:COMPUTERNAME </br> Wireless Mac = $wmac </br></br> This is an automated script that checks a machine after it's been imaged to see what the wireless mac is and send this to NIS. "
  from = "app_appenseinstaller.application@stateauto.com"
  to = "SUPPORT@STATEAUTO.COM"
  smtpserver = "smtprelay.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml
  
  " $compname and $wmac " | out-file c:\temp\wirelessmac-$compname.txt
   [Environment]::SetEnvironmentVariable("imagestate", 1 , "machine")
  
 

 
  

