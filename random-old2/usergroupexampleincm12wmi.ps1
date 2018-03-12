$users = "clientengineering"
$siteserver = "sadc1sccmd1.corp.stateauto.com" 
$provider = gwmi -ComputerName $siteserver -namespace "root\sms" -query "SELECT * FROM SMS_ProviderLocation"; 
$prov_machine = $provider.Machine; 
$sitecode = $provider.SiteCode; 
$namespace = "root\sms\site_"+$sitecode;
#$wmiquery = "SELECT * FROM SMS_Application";
$wmiquery = "SELECT * from SMS_R_User where usergroupname like '%$users%' "

#lists all application apps
$findusers = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 
$findusers