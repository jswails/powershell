
# all the users are in the folder. iterate thru each folder and check size
get-content "c:\temp\usernames.txt" | % {
$username = $_
$colItems = (gci "e:\data\profile\$username\" -recurse | Measure-Object -property length -sum)
$size = "{0:N2}" -f ($colItems.sum / 1MB) + " MB"
foreach ($objitem in $colitems)
{
write-host $username $size
Add-Content "c:\temp\usernamesize-Script.txt" " $username,$size";
}
}
#$colItems = (gci h:\ -recurse | Measure-Object -property length -sum)
#"{0:N2}" -f ($colItems.sum / 1MB) + " MB"
