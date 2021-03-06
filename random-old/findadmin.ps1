$domainname = "sai"
$erroractionpreference = "SilentlyContinue"
 $computername = "d8wnwjq1"
$userName = "Workstation Administrators"
 
if ($computerName -eq "") {$computerName = "$env:computername"}
([ADSI]"WinNT://$computerName/Administrators,group").Add("WinNT://$domainName/$userName")

$computer = [ADSI]("WinNT://" + $computername + ",computer")
$Group = $computer.psbase.children.find("Administrators")
$members= $Group.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}


ForEach($user in $members)


{

if ($user -eq $userName) {$found = $true}
}

if ($found -eq $true) {Write-Host "User $domainName\$userName is a local administrator on $computerName."}
else {Write-Host "User not found"; }