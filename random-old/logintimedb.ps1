$data = @()

$NetLogs = Get-WmiObject Win32_NetworkLoginProfile

foreach ($NetLog in $NetLogs) {
    if ($NetLog.LastLogon -match "(\d{14})") {
        $row = "" | Select Name,LogonTime
        $row.Name = $NetLog.Name
        $row.LogonTime=[datetime]::ParseExact($matches[0], "yyyyMMddHHmmss", $null)
        $data += $row
    }
}

$details1 = $data | Sort LogonTime -Descending | where-object {$_.Name -eq "sai\" + $ENV:Username} $details2 = Get-Date$compname = $env:COMPUTERNAME
$username = $details1.Name
$lastlogon = $details1.logontime
$details3 = get-date -format g
$time = $details2 - $details1.logontime

$disp = ($compname, $username, $lastlogon, $details3, $time) -join "^"
$disp | Out-File -Append c:\temp\lastuser.txt
$dbconn = New-Object System.Data.SqlClient.SqlConnection
$dbconn.ConnectionString = "Data Source=XP_J0PGJQ1\SQLEXPRESS;Initial Catalog=LoginInfo;Integrated Security=SSPI;"
$dbconn.open()
$dbwrite = $dbconn.CreateCommand()
$dbwrite.commandtext = "INSERT INTO dbo.LoginTime (computername,username,logontime,runtime,totaltime) VALUES ('$compname','$username','$lastlogon','$details3','$time')"
$dbwrite.executenonquery()
$dbconn.close()

$details1 = " "
$details2 = " "
$details3 = " "

