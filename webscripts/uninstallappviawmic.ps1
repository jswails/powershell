Param([string]$mach,[string]$app)

#wmic /failfast:on /node:$mach product get name
#wmic /failfast:on /node:$mach product where name="PowerGREP" call uninstall /nointeractive
$mach = "dg8xbpm1"
$app = "7-zip"
wmic /failfast:on /node:$mach product where "name like '%$app%'" call uninstall /nointeractive | out-file c:\temp\uninstall.txt

