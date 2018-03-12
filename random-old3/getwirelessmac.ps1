# after machine is imaged and before the bios disables the wireless mac this script has to be run

$curtime = get-date -format MM/dd/yyyy-HH:mm:ss

$compname = $env:COMPUTERNAME

$getdriver = gwmi win32_networkadapter -filter "Name like '%centrino%'"

$wmac = $getdriver.macaddress

$messageparameters = @{
  Subject = "New Computer for wireless"
  body = "Computer: $env:COMPUTERNAME </br> $wmac "
  from = "app_appenseinstaller.application@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "OutlookDC1.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml
