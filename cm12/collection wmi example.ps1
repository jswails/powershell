{
[CmdletBinding()]
Param(
[Parameter(Mandatory=$True,HelpMessage="Please Enter Primary Server Site Server")]
$SiteServer,
[Parameter(Mandatory=$True,HelpMessage="Please Enter Primary Server Site code")]
$SiteCode,
[Parameter(Mandatory=$True,HelpMessage="Please Enter the Account name")]
$ResourceName,
[Parameter(Mandatory=$True,HelpMessage="Please Enter the Account MAC Address")]
$MACAddress,
[Parameter(Mandatory=$True,HelpMessage="Please Enter the collecton name")]
$CollectionName
)

#Collection query
$CollectionQuery = Get-WmiObject -Namespace Root\SMS\Site_$SiteCode -Class SMS_Collection -ComputerName $SiteServer -Filter "Name='$CollectionName'"

#New computer account information
$WMIConnection = ([WMIClass]"\\$SiteServer\root\SMS\Site_${SiteCode}:SMS_Site") "Name
$NewEntry = $WMIConnection.psbase.GetMethodParameters("ImportMachineEntry")
$NewEntry.MACAddress = $MACAddress
$NewEntry.NetbiosName = $ResourceName
$NewEntry.OverwriteExistingRecord = $True
$Resource = $WMIConnection.psbase.InvokeMethod("ImportMachineEntry",$NewEntry,$null)

#Create the Direct MemberShip Rule
$NewRule = ([WMIClass]"\\$SiteServer\root\SMS\Site_${SiteCode}:SMS_CollectionRuleDirect").CreateInstance()
$NewRule.ResourceClassName = "SMS_R_SYSTEM"
$NewRule.ResourceID = $Resource.ResourceID
$NewRule.Rulename = $ResourceName

#Add the newly created machine to collection
$CollectionQuery.AddMemberShipRule($NewRule)
}