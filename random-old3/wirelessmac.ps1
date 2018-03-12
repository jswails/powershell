# after machine is imaged and before the bios disables the wireless mac this script has to be run

# insert variable to state its a new image. check for this variable and if exists then run the script and send the email

$curtime = get-date -format MM/dd/yyyy-HH:mm:ss

$compname = $env:COMPUTERNAME

$getdriver = gwmi win32_networkadapter -filter "Name like '%centrino%'"
if ($getdriver -eq $null) {
$getdriver = gwmi win32_networkadapter -filter "Name like '%wifi%'"
}
$wmac = $getdriver.macaddress
# app_appenseinstaller.application@stateauto.com

$wmac = $wmac.Replace(":", "-")
$wmac

$newimagevar = [Environment]::GetEnvironmentVariable("imagestate","machine")
# imagestate = 0 means it needs to run script to send email

 $SQLServer = "savfssccmt1" #use Server\Instance for named SQL instances!
 $SQLDBName = "logontime"
 $SqlQuery = "INSERT INTO dbo.wirelessmac (computername,MAC,date) VALUES ('$compname','$WMAC','$curtime)"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$sqlconnection.open()
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlCmd.executenonquery()

 $SqlConnection.Close()



$messageparameters = @{
  Subject = "MAC Automation – New computer for wireless"
  body = "Computer: $env:COMPUTERNAME </br> Wireless Mac = $wmac </br></br> This is an automated script that checks a machine after it's been imaged to see what the wireless mac is and send this to NIS. "
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "outlookdc1.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml
  
   [Environment]::SetEnvironmentVariable("imagestate", 1 , "machine")
  
 
 
 
  

