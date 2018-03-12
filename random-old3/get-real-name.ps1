$User = $env:USERNAME

$Search = New-Object DirectoryServices.DirectorySearcher([ADSI]“”)
$Search.filter = “(&(objectClass=user)(sAMAccountName=$User))”
$results = $Search.Findall()

Foreach($result in $results){
$User = $result.GetDirectoryEntry()
$realname = $user.DistinguishedName
$realname  #| out-file c:\temp\realname.txt
}