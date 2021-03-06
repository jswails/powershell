﻿# Load proxy DLL
Add-Type -Path "${Env:ProgramFiles}\AppSense\Management Center\Console\ManagementConsole.WebServices.dll"
# Management Server URL
$url = "http://server/ManagementServer"
# Get NetworkCredential instance
$credentials = [System.Net.CredentialCache]::DefaultCredentials
$credential = $credentials.GetCredential($url, "Basic")
# Create connection to the Management Server
[ManagementConsole.WebServices]::Connect($url, $credential)

# Get GroupsWebService reference
$GroupsWebService = [ManagementConsole.WebServices]::Groups
$GroupsDataSet = $GroupsWebService.GetGroups($True)
$Groups = $GroupsDataSet.Groups
$groups.Name

# Get DiscoveredMachinesWebService reference
$DiscoveredMachinesWebService = [ManagementConsole.WebServices]:: DiscoveredMachines

# Get MachinesWebService reference
$MachinesWebService = [ManagementConsole.WebServices]:: Machines

# Set up a Boolean to get the machines with or without summary
# machines with a summary detail the number of alerts counted
$withSummary = $true

# Get list of machines
$MachinesDataSet = $MachinesWebService.GetMachines($withSummary)
$Machines = $MachinesDataSet.Machines

$Machines

# find machine
$MachinesDataSet = $MachinesWebService.FindMachines("%")
$Machines = $MachinesDataSet.Machines
$group = "No Performance Manager"
$machines | where-object -filterscript {$_.Groupname -eq "$group"} | select-object Netbiosname,Groupname | export-csv -path c:\wamp\www\appsense\"$group".csv -NoTypeInformation

foreach($check in $machines) {
 
$a = $check.Netbiosname
$b = $check.GroupName
if ($b = "(Default)") {
write-host " Machine moved to Dev"
}


$reports = [ManagementConsole.WebServices]::Reports
$reports | Get-Member -type Method
$a = $reports.GetVisibleReportDefinitions($true)
foreach($b in $a){
$b.ReportDefinitions
}
$reportdata = 
$reportresult = $reportdata.Reports
$reportresult


# Get AlertsWebService reference
$AlertsWebService = [ManagementConsole.WebServices]::Alerts

# Get list of alerts
$AlertsDataSet = $AlertsWebService.GetAlerts()
$Alerts = $AlertsDataSet.Alerts
$Alerts



ManagementConsole.MachinesWebService.MachinesDataSet FindMachines(String)
