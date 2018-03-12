

$details1 = (get-eventlog application | where-object {$_.EventID -eq "1085"})[0].TimeGenerated

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
# grabs nics and gets the default gateway
if($os -match "Windows XP Professional")
{ $Nics = Get-wmiobject win32_NetworkAdapter -comp $ENV:COMPUTERNAME |where {$_.deviceid -eq "12"}

} 
foreach ($Nic in $Nics)
{
$Config = Get-Wmiobject win32_NetworkAdapterConfiguration | where {$_.index -eq $Nic.index}
if ($config.IPAddress -ne "$null")
{$VGateway = $config.DefaultIPGateway }

$vgatefix = "$($config.DefaultIPGateway)"

}


if($os -match "Windows Windows 7 Enterprise")
{$Nics = Get-wmiobject win32_NetworkAdapter -comp $compname 
}
foreach ($Nic in $Nics)
{
$Config = Get-Wmiobject win32_NetworkAdapterConfiguration | where {$_.index -eq $Nic.index}
if ($config.IPAddress -ne "$null")
{$VGateway = $config.DefaultIPGateway}
$vgatefix = "$($config.DefaultIPGateway)"
}


$curtime = get-date -format MM/dd/yyyy-HH:mm:ss
$runtime = $y - $details1
$disp = ($compname,$proc,$model,$osbuild,$imgver,$logsrv,$vgatefix,$username, $curtime, $runtime ) -join "^"
$disp | Out-File -Append c:\temp\lastuser.txt

#$SQLServer = "savfssccmt1" #use Server\Instance for named SQL instances!
# $SQLDBName = "logontime"
#$SqlQuery = "INSERT INTO dbo.logindata1 (computername,processor,Model,OSbuild,IMGVER,LogonServer,defaultgw1,username,runtime,totaltime) VALUES ('$compname','$proc','$model','$osbuild','$imgver','$logsrv','$Vgateway','$username','$curtime','$runtime')"
#$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
#$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
#$sqlconnection.open()
#$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
#$SqlCmd.CommandText = $SqlQuery
#$SqlCmd.Connection = $SqlConnection
#$SqlCmd.executenonquery()

 #$SqlConnection.Close()

