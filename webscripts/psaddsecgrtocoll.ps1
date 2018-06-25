Param([string]$users,[string]$collid)


$users|  out-file -append e:\wamp\logs\uservars.log
$collid | out-file -append e:\wamp\logs\uservars.log
import-module "e:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\configurationmanager.psd1"
 
cd psdrivename:

Add-CMUserCollectionQueryMembershipRule -CollectionID $collid -QueryExpression "select *  from  SMS_R_UserGroup where SMS_R_UserGroup.Name = '$users'" -RuleName "$users"
