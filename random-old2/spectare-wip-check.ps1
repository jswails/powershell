

$smdir =  "C:\Packages\scriptmonitor"
$err = ""
$begin = ""
$wipserver = "\\10.30.164.71\data-in"
$datetime = Get-Date -Format "yyyyMMdd";
$datetimem = Get-Date -Format "yyyyMMddmm";
$prevday = (get-date -Format "yyyyMMdd") -1
$configroot = "\\admin3\scriptmonitor"
$sccmexeclog = "c:\windows\ccm\logs\execmgr.log"
$machinename = $env:computername


$latest = Get-ChildItem -Path $smdir\wmierror\$datetime
foreach ($path in $latest){
Get-Content "$smdir\wmierror\$datetime\$path" | Set-Content $smdir\wmierror\$datetime\wmierror.csv
ri -Path "$smdir\wmierror\$datetime\$path" -Force
}

$latest = Get-ChildItem -Path $smdir\downloadfail\$datetime
foreach ($path in $latest){
Get-Content "$smdir\downloadfail\$datetime\$path" | Set-Content $smdir\downloadfail\$datetime\downloadfail.csv
ri -Path "$smdir\downloadfail\$datetime\$path" -Force
}

$latest = Get-ChildItem -Path $smdir\badsmspackage\$datetime
foreach ($path in $latest){
Get-Content "$smdir\badsmspackage\$datetime\$path" | Set-Content $smdir\badsmspackage\$datetime\badsmspackage.csv
ri -Path "$smdir\badsmspackage\$datetime\$path" -Force
}

$latest = Get-ChildItem -Path $smdir\nocomputer\$datetime
foreach ($path in $latest){
Get-Content "$smdir\nocomputer\$datetime\$path" | Set-Content $smdir\nocomputer\$datetime\nocomputer.csv
ri -Path "$smdir\nocomputer\$datetime\$path" -Force
}

$latest = Get-ChildItem -Path $smdir\nosccmclient\$datetime
foreach ($path in $latest){
Get-Content "$smdir\nosccmclient\$datetime\$path" | Set-Content $smdir\nosccmclient\$datetime\nosccmclient.csv
ri -Path "$smdir\nosccmclient\$datetime\$path" -Force
}

$latest = Get-ChildItem -Path $smdir\fail\$datetime
foreach ($path in $latest){
Get-Content "$smdir\fail\$datetime\$path" | Set-Content $smdir\fail\$datetime\fail.csv
ri -Path "$smdir\fail\$datetime\$path" -Force
}

$latest = Get-ChildItem -Path $smdir\done\$datetime
foreach ($path in $latest){
Get-Content "$smdir\done\$datetime\$path" | Set-Content $smdir\done\$datetime\done.csv
ri -Path "$smdir\done\$datetime\$path" -Force
}

$latest = Get-ChildItem -Path $smdir\wait\$datetime
foreach ($path in $latest){
Get-Content "$smdir\wait\$datetime\$path" | Set-Content $smdir\wait\$datetime\wait.csv
ri -Path "$smdir\wait\$datetime\$path" -Force
}

