Param([string]$strComputer,[string]$username)

$domain = "SAI"
$computer = [ADSI]("WinNT://" + $strComputer + ",computer")
$computer.name | out-file -append e:\wamp\www\iam\admin.csv
$Group = $computer.psbase.children.find("administrators")
$group.name | out-file -append e:\wamp\www\iam\admin.csv

$Group.Add("Winnt://" + $domain + "/" + $username)