# retrieve the data from the SQL db.



$SQLServer = "savfssccmt1" #use Server\Instance for named SQL instances!
 $SQLDBName = "logontime"
#$SqlQuery = "SELECT Distinct imgver from dbo.logindata1"
#$SqlQuery = "SELECT Distinct boottime from dbo.logindata1"
#$sqlquery = "Select distinct logonserver from dbo.logindata1"
#$sqlquery = " select distinct model from dbo.logindata1"
#$sqlquery = " select distinct computername from dbo.logindata1"
#$sqlquery = " select distinct processor from dbo.logindata1"
#$sqlquery = " select distinct osbuild from dbo.logindata1"
#$sqlquery = " select distinct runtime from dbo.logindata1"
#$sqlquery = " select distinct username from dbo.logindata1"
#$sqlquery = " select distinct totaltime from dbo.logindata1 where totaltime > '00:01:00' "
#$sqlquery = " select distinct totaltime,username,computername from dbo.logindata1 where totaltime > '00:05:00' "
#$sqlquery = " select distinct computername,totaltime from dbo.logindata1 where totaltime > '00:01:00' "
#$sqlquery = " select computername,username,totaltime,runtime from dbo.logindata1 where computername like 'v%' and runtime like '05/2%'order by runtime ASC "
#$sqlquery = " select distinct computername,totaltime,runtime,logonserver from dbo.logindata1 where logonserver like '%sadc1ad1%' and runtime like '05/01/2012%' "
#$sqlquery = " select distinct computername,totaltime,runtime,logonserver from dbo.logindata1 where logonserver like '%sacolad1%' and runtime like '06/26/2012-07%' "
#$sqlquery = " select distinct computername,totaltime,runtime,logonserver from dbo.logindata1 where logonserver like '%sacolad2%' and runtime like '06/25/2012-07%' order by runtime ASC "
#$sqlquery = " select distinct computername,totaltime,runtime,logonserver from dbo.logindata1 where logonserver like '%saeroad3%' and runtime like '05/%' "
#$sqlquery = " select distinct computername,totaltime,runtime,logonserver from dbo.logindata1 where logonserver like '%SAMROAD2%' and runtime like '05/%' "
#$sqlquery = " select distinct computername,totaltime,runtime,logonserver from dbo.logindata1 where logonserver like '%sacolad1%' and runtime like '05/01/2012-08%' "
#$sqlquery = " select distinct computername,totaltime,runtime,logonserver from dbo.logindata1 where runtime like '05/01/2012-08%' "
#$sqlquery = " select distinct computername,totaltime,runtime,logonserver from dbo.logindata1 where runtime like '05/01/2012-09%' "
#$sqlquery = " select distinct computername,totaltime,runtime,logonserver from dbo.logindata1 where runtime like '05/%' and computername like 'W7JAVA%' order by runtime ASC "
#$sqlquery = " select distinct runtime,username from dbo.logindata1 where imgver like '2.3%' order by runtime ASC"
#$sqlquery = " select distinct username,computername,boottime from dbo.logindata1 where username like 'swa4444' "
$sqlquery = " select distinct username,computername,imgver from dbo.logindata1 where imgver < '2.1' "
#$sqlquery = " select distinct computername,username  from dbo.logindata1 where computername like 'W7%' order by computername
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
 #$dataset.Tables[0] | export-csv c:\temp\imgver1.csv
 $SqlConnection.Close()