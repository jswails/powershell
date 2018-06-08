$siteserver = "" 
$provider = gwmi -ComputerName $siteserver -namespace "root\sms" -query "SELECT * FROM SMS_ProviderLocation"; 
$prov_machine = $provider.Machine; 
$sitecode = $provider.SiteCode; 
$namespace = "root\sms\site_"+$sitecode;
#$wmiquery = "SELECT * FROM SMS_Application";
$wmiquery = "SELECT * from SMS_R_User where username = '' "

#lists all application apps
$adminapp = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 
$adminapp.ResourceID

# checks for requests
$wmiquery = "SELECT * FROM SMS_UserApplicationRequest"
$adminrequests = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 

#this part will do wholesale approvals for an app

# get the list of pending requests for this application and approve for all users 
$wmiquery = "SELECT * FROM SMS_Application WHERE ModelName = '"+$appid+"' AND IsLatest='TRUE'"; 
$adminapp = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 
$wmiquery = "SELECT * FROM SMS_UserApplicationRequest WHERE ModelName = '"+$appid+"'"; 
$adminrequests = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 
foreach ($request in $adminrequests) 
{        
    $res = $request.Approve("Approved via Windows PowerShell");    
}
