
$collectionname = "notepad ++"
$resourcename = ""
$sitecode = ""
$siteserver = ""

$CollectionQuery = Get-WmiObject -Namespace Root\SMS\Site_$SiteCode -Class SMS_Collection -ComputerName $SiteServer -Filter "Name like '%'"

#Create the Direct MemberShip Rule
$NewRule = ([WMIClass]"\\$SiteServer\root\SMS\Site_${SiteCode}:SMS_CollectionRuleDirect").CreateInstance()
$NewRule.ResourceClassName = "SMS_R_SYSTEM"
$NewRule.ResourceID = $Resource.ResourceID
$NewRule.Rulename = $ResourceName

#Add the newly created machine to collection
$CollectionQuery.AddMemberShipRule($NewRule)
