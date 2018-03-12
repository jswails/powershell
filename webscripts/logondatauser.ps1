# retrieve the data from the SQL db.
Param([string]$username)
$SQLServer = "savfssccmt1" #use Server\Instance for named SQL instances!
 $SQLDBName = "logontime"

$sqlquery = " select * from dbo.logindata1  where username like '$username'"

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
 $dataset.Tables[0] | select-object  computername,Processor,Model,Imgver,Logonserver,Runtime -last 1 | export-csv -notypeinformation  -path e:\wamp\www\logondata\$username.csv
 $SqlConnection.Close()