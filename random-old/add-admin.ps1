

$strComputer = "."
$domain = "SAI"
$username = "Workstation Administrators" 
$computer = [ADSI]("WinNT://" + $strComputer + ",computer")
$computer.name
$Group = $computer.psbase.children.find("administrators")
$group.name

$Group.Add("Winnt://" + $domain + "/" + $username)


