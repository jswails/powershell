$curtime = get-date -format MM/dd/yyyy-HH:mm:ss

$compname = $env:COMPUTERNAME

$getdriver = gwmi win32_networkadapter -filter "Name like '%centrino%'"

$wirelessmac = $getdriver.macaddress





$SQLServer = "savfssccmt1" #use Server\Instance for named SQL instances!
 $SQLDBName = "logontime"
$SqlQuery = "INSERT INTO dbo.wirelessmac (computername,MAC,Date) VALUES ('$compname','$wirelessmac','$curtime')"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$sqlconnection.open()
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlCmd.executenonquery()

 $SqlConnection.Close()