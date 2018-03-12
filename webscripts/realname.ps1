Param([string]$username)

$Search = New-Object DirectoryServices.DirectorySearcher([ADSI]“”)
$Search.filter = “(&(objectClass=user)(sAMAccountName=$Username))”
$results = $Search.Findall()

Foreach($result in $results){
$User = $result.GetDirectoryEntry()
$realname = $user.DistinguishedName
$title = $user.title
$a = $user.HomeDirectory
$b = $user.badPwdCount
$c = $user.physicaldeliveryofficename
$d = $user.department
$e = $user.telephonenumber
$f = $user.memberof

$realname | out-file e:\wamp\tmp\$username.csv
$title | out-file -append e:\wamp\tmp\$username.csv
$e | out-file -append e:\wamp\tmp\$username.csv
$a | out-file -append e:\wamp\tmp\$username.csv
$b | out-file -append e:\wamp\tmp\$username.csv
$c | out-file -append e:\wamp\tmp\$username.csv
$d | out-file -append e:\wamp\tmp\$username.csv
$f | out-file -append e:\wamp\tmp\$username.csv
}


