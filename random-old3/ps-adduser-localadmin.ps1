$getnamefile = "c:\temp\user.txt"
$tada = get-content $getnamefile
$username = $tada
$strComputer = $env:COMPUTERNAME
$getrealnamefile = "c:\temp\realname.txt"
$rn = get-content $getrealnamefile
$realname = $rn

$domain = "SAI"
$username = $tada
$computer = [ADSI]("WinNT://" + $strComputer + ",computer")
$computer.name
$Group = $computer.psbase.children.find("administrators")
$group.name

$Group.Add("Winnt://" + $domain + "/" + $username)