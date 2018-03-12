Param([string]$users,[string]$collid)


$users|  out-file -append e:\wamp\logs\uservars.log
$collid | out-file -append e:\wamp\logs\uservars.log
import-module "e:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\configurationmanager.psd1"
 
cd C05:

Add-CMUserCollectionQueryMembershipRule -CollectionID $collid -QueryExpression "select SMS_R_USER.ResourceID,SMS_R_USER.ResourceType,SMS_R_USER.Name,SMS_R_USER.UniqueUserName,SMS_R_USER.WindowsNTDomain from SMS_R_User where SMS_R_User.UserGroupName = '$users'" -RuleName "$users"