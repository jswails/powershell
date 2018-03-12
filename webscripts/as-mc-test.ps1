
# Load proxy DLL
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
$DiscoveredMachinesWebService.DeleteMachine("f45b1a5f-8a51-4717-a4ff-ae562053dacf")
# Get MachinesWebService reference
$MachinesWebService = [ManagementConsole.WebServices]:: Machines

# find machine
$MachinesDataSet = $MachinesWebService.FindMachines("%EDCH7RW1%")
$Machines = $MachinesDataSet.Machines

$MachinesDataSet = $MachinesWebService.DeleteMachine("f45b1a5f-8a51-4717-a4ff-ae562053dacf","10/14/2014 7:34:32 PM")
$Machines = $MachinesDataSet.Machines


#$machines | where-object -FilterScript {$_.LastPollTime -le "9/11/2014"} | select-object GroupName,Netbiosname,Deployed,lastpolltime,creationtime,modifiedtime,lastresponseseconds | export-csv -path e:\wamp\www\appsense\3month.csv -NoTypeInformation
#$machines | where-object -filterscript {$_.Groupname -eq "$groupname"} | select-object Netbiosname,Groupname | export-csv -path e:\wamp\www\appsense\"$groupname".csv -NoTypeInformation

#$machines | where-object -FilterScript {$_.LastPollTime -le "10/11/2014"} | select-object GroupName,Netbiosname,Deployed,lastpolltime,creationtime,modifiedtime,lastresponseseconds | export-csv -path e:\wamp\www\appsense\2month.csv -NoTypeInformation

#$machines | where-object -FilterScript {$_.LastPollTime -le "11/11/2014"} | select-object GroupName,Netbiosname,Deployed,lastpolltime,creationtime,modifiedtime,lastresponseseconds | export-csv -path e:\wamp\www\appsense\1month.csv -NoTypeInformation