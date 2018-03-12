$computer = "dg8xbpm1"
#Param([string]$computer)
# Load proxy DLL
Add-Type -Path "${Env:ProgramFiles}\AppSense\Management Center\Console\ManagementConsole.WebServices.dll"
# Management Server URL
$url = "http://10.30.188.108/ManagementServer"
# Get NetworkCredential instance
$credentials = [System.Net.CredentialCache]::DefaultCredentials
$credential = $credentials.GetCredential($url, "Basic")
# Create connection to the Management Server
[ManagementConsole.WebServices]::Connect($url, $credential)


# Get AlertsWebService reference
$AlertsWebService = [ManagementConsole.WebServices]::Alerts

# Get list of alerts
$AlertsDataSet = $AlertsWebService.GetAlerts()
$Alerts = $AlertsDataSet.Alerts



$a = "<style>"
$a = $a + "BODY{background-color:silver;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:PaleGoldenrod}"
$a = $a + "</style>"


$alerts | select-object  groupname,machinename,  | export-csv -notypeinformation c:\temp\$machine.csv
