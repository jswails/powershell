# Create web service proxy
$catalogurl = "http://sadc1sccmd1.corp.stateauto.com/CMApplicationCatalog";
$url = $catalogurl+"/ApplicationViewService.asmx?WSDL";
$service = New-WebServiceProxy $url -UseDefaultCredential;

# Retrieve the first 20 applications sorted by name 
# Sample app id: "ScopeId_82A46150-9A71-421A-9645-AD4B92AF1B72/Application_295530ae-5755-48fc-a04b-c01c9631c1f7" 
$total = 0; 
$apps = $service.GetApplications("Name",$null,"Name","",20,0,$true,"PackageProgramName",$false,$null,[ref]$total) 
$appid = $apps[0].ApplicationId;

# Retrieve device id to identify the machine 
$clientsdk = [wmiclass]'root/ccm/clientSDK:CCM_SoftwareCatalogUtilities'; 
$deviceidobj = $clientsdk.GetDeviceID(); 
$deviceid = $deviceidobj.ClientId+","+$deviceidobj.SignedClientId;

# Submit application request to the server 
$reason = "Test request reason"; 
$reqresult = $service.RequestApplicationForUser($reason, $appid, $deviceid, $null);


# Retrieve provider info, assumes one provider 
$siteserver = "sadc1cm12p1.corp.stateauto.com" 
$provider = gwmi -ComputerName $siteserver -namespace "root\sms" -query "SELECT * FROM SMS_ProviderLocation"; 
$prov_machine = $provider.Machine; 
$sitecode = $provider.SiteCode; 
$namespace = "root\sms\site_"+$sitecode;
$wmiquery = "SELECT * FROM SMS_Application";
$adminapp = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 
$wmiquery = "SELECT * FROM SMS_UserApplicationRequest"
$adminrequests = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 

# get the list of pending requests for this application and approve for all users 
$wmiquery = "SELECT * FROM SMS_Application WHERE ModelName = '"+$appid+"' AND IsLatest='TRUE'"; 
$adminapp = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 
$wmiquery = "SELECT * FROM SMS_UserApplicationRequest WHERE ModelName = '"+$appid+"'"; 
$adminrequests = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 
foreach ($request in $adminrequests) 
{        
    $res = $request.Approve("Approved via Windows PowerShell");    
}

$wmiquery = "SELECT * FROM SMS_Application";
$wmiquery = "SELECT * FROM SMS_UserApplicationRequest"