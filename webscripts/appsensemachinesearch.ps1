
Param([string]$computer)
# Load proxy DLL
Add-Type -Path "e:\Program Files\AppSense\Management Center\Console\ManagementConsole.WebServices.dll"
# Management Server URL
$url = "http://server/ManagementServer"
# Get NetworkCredential instance
$credentials = [System.Net.CredentialCache]::DefaultCredentials
$credential = $credentials.GetCredential($url, "Basic")
# Create connection to the Management Server
[ManagementConsole.WebServices]::Connect($url, $credential)

# Get DiscoveredMachinesWebService reference
$DiscoveredMachinesWebService = [ManagementConsole.WebServices]:: DiscoveredMachines

# Get MachinesWebService reference
$MachinesWebService = [ManagementConsole.WebServices]:: Machines

# find machine
$MachinesDataSet = $MachinesWebService.FindMachines("%$computer%")
$Machines = $MachinesDataSet.Machines



$machines | select-object GroupName,Netbiosname,Deployed,lastpolltime,creationtime,modifiedtime,lastresponseseconds | export-csv -path e:\wamp\www\appsense\$computer.csv -NoTypeInformation
