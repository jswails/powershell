
$collectionname = "notepad ++"
$resourcename = "DG8XBPM1"
$sitecode = "t02"
$siteserver = "savfssccmt1"

$CollectionQuery = Get-WmiObject -Namespace Root\SMS\Site_$SiteCode -Class SMS_Collection -ComputerName $SiteServer -Filter "Name like 'mm%'"

#Create the Direct MemberShip Rule
$NewRule = ([WMIClass]"\\$SiteServer\root\SMS\Site_${SiteCode}:SMS_CollectionRuleDirect").CreateInstance()
$NewRule.ResourceClassName = "SMS_R_SYSTEM"
$NewRule.ResourceID = $Resource.ResourceID
$NewRule.Rulename = $ResourceName

#Add the newly created machine to collection
$CollectionQuery.AddMemberShipRule($NewRule)