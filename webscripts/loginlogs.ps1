
Param([string]$computer)
$SQLServer = "server" #use Server\Instance for named SQL instances!
$SQLDBName = "login tracking"
$timeframe = -1
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand #setting object to use sql commands

		# Gather logs based on supplied computer names

			$query = "SELECT  *
			  FROM LoginLog
			  WHERE PC_Name like '$computer'  order by Login_Date DESC"

			$connection.open()
			$SqlCmd.CommandText = $query
			$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
			$SqlAdapter.SelectCommand = $SqlCmd
			$SqlCmd.Connection = $connection
			$dataset = New-Object System.Data.DataSet
			$SqlAdapter.Fill($dataset)
 $dataset.Tables[0]
 $dataset.Tables[0] | export-csv -notypeinformation -path e:\wamp\www\loginlogs\$computer.csv
			$connection.close()
	
		
