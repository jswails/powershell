﻿Param([string]$mach,[string]$collid)
$mach |  out-file -append e:\wamp\logs\vars.log
$collid | out-file -append e:\wamp\logs\vars.log
import-module "e:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\configurationmanager.psd1"
 # Get-PSDrive | out-file e:\wamp\logs\psdrive.log
cd psdrivename:

Add-CMDeviceCollectionDirectMembershipRule -CollectionID "$collid" -ResourceID $(get-cmdevice -name "$mach").ResourceID
