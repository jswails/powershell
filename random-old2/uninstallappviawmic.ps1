Param([string]$mach,[string]$app)

#wmic /failfast:on /node:$mach product get name
#wmic /failfast:on /node:$mach product where name="PowerGREP" call uninstall /nointeractive

wmic /failfast:on /node:$mach product where "name like '%$app%'" call uninstall /nointeractive

