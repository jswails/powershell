$y = get-date

$compname = $env:COMPUTERNAME
$username = $env:USERNAME
$imgver = $env:imgver
$logsrv = $env:logonserver
$proc = $env:PROCESSOR_ARCHITECTURE

$m = get-wmiobject win32_computersystem
$win32_os = gwmi win32_operatingsystem 
$os = $win32_os.Caption
$osbuild = $win32_os.buildnumber

$model = $m.model
$trimmodel = $model.Trim()
# grabs nics and gets the default gateway

$Nics = Get-wmiobject win32_NetworkAdapter -comp $compname 

foreach ($Nic in $Nics)
{
$Config = Get-Wmiobject win32_NetworkAdapterConfiguration | where {$_.index -eq $Nic.index}
if ($config.IPAddress -ne "$null")
{$VGateway = $config.DefaultIPGateway}
$vgatefix = "$($config.DefaultIPGateway)"
}

$curtime = get-date -format MM/dd/yyyy-HH:mm:ss

############ start functions for logon times from appsense tool #################



#logon function
$logonfind = findstr /B Logon C:\temp\logon.log | select-object  -Last 1
$logonsplit = $logonfind.Split(" ")
 # logon 
 # 3 is time. 4 is date. 5 is time to logon.

$timeoflogon = $split[3]
$dateoflogon = $split[4]
$logonspeed = $split[5]

 # had to trim off the ( from the number.
$trimlogon = $logonspeed.TrimStart("(")

#######################
#boot function

# boot capture doesnt have the error of an extra space so its split is different.

$bootfind = findstr /B Boot C:\temp\logon.log | select-object  -Last 1

$bootsplit = $bootfind.Split(" ")
$timeofboot = $bootsplit[2]
$dateofboot = $bootsplit[3]
$bootspeed = $bootsplit[4]

  # had to trim off the ( from the number.
$trimboot = $bootspeed.TrimStart("(")


####### end appsense log tool grab ####################################################

$disp = ($compname,$proc,$trimmodel,$osbuild,$imgver,$logsrv,$vgatefix,$username, $curtime, $trimboot, $trimlogon) -join "^"
$disp | Out-File -Append c:\temp\lastuser.txt

$SQLServer = "savfssccmt1" 
 $SQLDBName = "logontime"
$SqlQuery = "INSERT INTO dbo.logindata1 (computername,processor,Model,OSbuild,IMGVER,LogonServer,defaultgw1,username,runtime,boottime,logontime) VALUES ('$compname','$proc','$model','$osbuild','$imgver','$logsrv','$vgatefix','$username','$curtime','$trimboot','$trimlogon')"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$sqlconnection.open()
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlCmd.executenonquery()

$SqlConnection.Close()


#logon function
$logonfind = findstr /B Logon C:\temp\logon.log | select-object  -Last 3
$logonfind

# need to compare the time of the logon vs the current time and see if they match in hours and minutes. if they do thats the logon thats used. others discarded.



$logonsplit = $logonfind.Split(" ")
 # logon 
 # 3 is time. 4 is date. 5 is time to logon.

$timeoflogon = $logonsplit[3]
$dateoflogon = $logonsplit[4]
$logonspeed = $logonsplit[5]

 # had to trim off the ( from the number.
$trimlogon = $logonspeed.TrimStart("(")
$trimlogon