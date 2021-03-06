$User = $env:USERNAME
$source = Get-Content c:\scripts\usernames.txt
foreach ($User in $source)
{
$Search = New-Object DirectoryServices.DirectorySearcher([ADSI]“”)
$Search.filter = “(&(objectClass=user)(sAMAccountName=$User))”
$results = $Search.Findall()

Foreach($result in $results){
$User = $result.GetDirectoryEntry()
$realname = $user.DistinguishedName
$realname  | out-file -append c:\temp\realname.txt
}
}
