
  $SQLServer = "SADC1CMBLNCOP1" #use Server\Instance for named SQL instances!
 $SQLDBName = "blancodb"
 $SqlQuery = "SELECT * from dbo.*"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$sqlconnection.open()
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
$SqlCmd.executenonquery()

 $SqlConnection.Close()