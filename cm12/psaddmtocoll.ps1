$CollectionName = "notepad ++"

$DeviceName = "dg8xbpm1"

Add-CMDeviceCollectionDirectMembershipRule -CollectionName "$CollectionName" -ResourceID $(get-cmdevice -name "$DeviceName").ResourceID