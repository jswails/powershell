﻿$CollectionName = "notepad ++"

$DeviceName = ""

Add-CMDeviceCollectionDirectMembershipRule -CollectionName "$CollectionName" -ResourceID $(get-cmdevice -name "$DeviceName").ResourceID
