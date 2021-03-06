Param([string]$users,[string]$collid)

$siteserver = "sadc1cm12p1.corp.stateauto.com" 
$provider = gwmi -ComputerName $siteserver -namespace "root\sms" -query "SELECT * FROM SMS_ProviderLocation"; 
$prov_machine = $provider.Machine; 
$sitecode = $provider.SiteCode; 
$namespace = "root\sms\site_"+$sitecode;
#$wmiquery = "SELECT * FROM SMS_Application";
$wmiquery = "SELECT * from SMS_R_User where username = '$users' "

#lists all application apps
$findusers = gwmi -ComputerName $prov_machine -namespace $namespace -query $wmiquery; 
$usersid = $findusers.ResourceID


$users|  out-file -append e:\wamp\logs\uservars.log
$collid | out-file -append e:\wamp\logs\uservars.log
import-module "e:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\configurationmanager.psd1"
 
cd C05:

Add-CMUserCollectionDirectMembershipRule -CollectionID "$collid" -ResourceID "$usersid"