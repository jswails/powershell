
Param([string]$computer)
$SQLServer = "sacolsqlp4" #use Server\Instance for named SQL instances!
$SQLDBName = "login tracking"

$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand #setting object to use sql commands

		# Gather logs based on supplied computer names

			$query = "SELECT  pc_name, netid, IP_Address, OS_Stream_Version, convert(varchar(16), login_date, 20) as Login_Date, COUNT(PC_Name) as total
			  FROM LoginLog
			  WHERE PC_Name like '$computer'
			  GROUP BY ROLLUP (PC_Name, netid, IP_Address, OS_Stream_Version, Login_Date)
			  order by Login_Date DESC, total"

			$connection.open()
			$SqlCmd.CommandText = $query
			$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
			$SqlAdapter.SelectCommand = $SqlCmd
			$SqlCmd.Connection = $connection
			$dataset = New-Object System.Data.DataSet
			$SqlAdapter.Fill($dataset)
 $dataset.Tables[0]
 $dataset.Tables[0] | select-object  netid,ip_address -last 20 | export-csv -notypeinformation -path e:\wamp\www\loginlogs\$computer.csv
			$connection.close()
	
		
