Param([string]$computer)
# retrieve the data from the SQL db.

$SQLServer = "savfssccmt1" #use Server\Instance for named SQL instances!
 $SQLDBName = "logontime"

$sqlquery = " delete from dbo.syncerror where computername like '$computer'"

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$sqlconnection.open()
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = $SqlQuery
$SqlCmd.Connection = $SqlConnection
#$SqlCmd.executenonquery()
 
 $dataAdapter = new-object System.data.sqlclient.sqldataadapter $sqlcmd
 $dataset = new-object system.data.dataset
 $dataAdapter.Fill($dataset)
 $dataset.Tables[0]
 $dataset.Tables[0] 
 $SqlConnection.Close()