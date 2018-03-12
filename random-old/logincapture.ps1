$details1 = (get-eventlog application | where-object {$_.EventID -eq "1085"})[0].TimeGenerated

$y = get-date
$compname = $env:COMPUTERNAME
$username = $env:USERNAME
$osbuild = $win32os.buildnumber
$imgver = $env:imgver
$logsrv = $env:logonserver
$proc = $env:PROCESSOR_ARCHITECTURE

$m = get-wmiobject win32_computersystem

$model = $m.model

$curtime = get-date -format g
$runtime = $y - $details1
$disp = ($compname,$proc,$model,$osbuild,$imgver,$logsrv,$username, $curtime, $runtime ) -join "^"
$disp | Out-File -Append c:\temp\lastuser.txt

$SQLServer = "savfssccmt1" #use Server\Instance for named SQL instances!
 $SQLDBName = "logontime"
$SqlQuery = "INSERT INTO dbo.logindata1 (computername,processor,Model,OSbuild,IMGVER,LogonServer,username,runtime,totaltime) VALUES ('$compname','$proc','$model','$osbuild','$imgver','$logsrv','$username','$curtime','$runtime')"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$sqlconnection.open()
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlCmd.executenonquery()

 $SqlConnection.Close()

