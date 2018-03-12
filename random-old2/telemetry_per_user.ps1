
$username = $Env:username
$Search = New-Object DirectoryServices.DirectorySearcher([ADSI]“”)
$Search.filter = “(&(objectClass=user)(sAMAccountName=$Username))”
$results = $Search.Findall()

Foreach($result in $results){
$User = $result.GetDirectoryEntry()

$title = $user.title
$c = $user.physicaldeliveryofficename
$d = $user.department

$tag1 = '"Tag1"="' + $title + '"'
$tag2 = '"Tag2"="' + $c + '"'
$tag3 = '"Tag3"="' + $d + '"'
"Windows Registry Editor Version 5.00" | out-file C:\wamp\tmp\tags.reg

"[HKEY_CURRENT_USER\Software\Policies\Microsoft\Office\15.0\osm]" | out-file -Append C:\wamp\tmp\tags.reg
$tag1 | out-file -append C:\wamp\tmp\tags.reg
$tag2 | out-file -append C:\wamp\tmp\tags.reg
$tag3 | out-file -append C:\wamp\tmp\tags.reg
}

