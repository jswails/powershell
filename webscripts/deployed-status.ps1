Add-Type -Path "e:\Program Files\AppSense\Management Center\Console\ManagementConsole.WebServices.dll"
# Management Server URL
$url = "http://10.30.188.108/ManagementServer"
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
$MachinesDataSet = $MachinesWebService.FindMachines("%")
$Machines = $MachinesDataSet.Machines
$machines.count
$machines | select-object Deployed | export-csv -path e:\deployed.csv -NoTypeInformation