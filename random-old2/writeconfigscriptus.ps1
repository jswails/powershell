Param([string]$machinename,[string]$collectionid)
# write out config file for spectarescriptus
# check for todays date if non existant than create date folder
#then check for machine name folder under the days date and create if it doesnt exist
# then create config file with date.deploy and inside the file single line entries of collectionid to be watched

$datetime = Get-Date -Format "yyyyMMdd";
$configroot = "\\server\scriptmonitor\"

if(!(test-path("$configroot\$datetime"))) {
mkdir "$configroot\$datetime"
}
if(!(test-path("$configroot\$datetime\$machinename"))) {
mkdir "$configroot\$datetime\$machinename"
}

if(Test-Path("$configroot\$datetime\$machinename")) {
"$collectionid" | out-file -Append $configroot\$datetime\$machinename\$datetime.deploy
}
