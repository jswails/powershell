$getnamefile = "c:\packages\logonscript\user.txt"
$log = "c:\temp\adminscriptdebug.txt"
$datetime = Get-Date -Format "yyyyMMddHHmm"
$tada = get-content $getnamefile
$username = $tada
$strComputer = $env:COMPUTERNAME
"starting add user script" | out-file -append $log
$domain = ""
$username = $tada
$computer = [ADSI]("WinNT://" + $strComputer + ",computer")
$computer.name
$Group = $computer.psbase.children.find("administrators")
$group.name

$Group.Add("Winnt://" + $domain + "/" + $username)
$datetime | out-file -append $log
$username + " to be added to local admins" | out-file -append $log
