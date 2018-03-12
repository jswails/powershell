$User = Read-Host “Enter the Users’ Logon Name”

$Search = New-Object DirectoryServices.DirectorySearcher([ADSI]“”)
$Search.filter = “(&(objectClass=user)(sAMAccountName=$User))”
$results = $Search.Findall()

Foreach($result in $results){
$User = $result.GetDirectoryEntry()
$user.DistinguishedName
}



