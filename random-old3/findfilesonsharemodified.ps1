# search a file share for all files modified within last x days
# take variable from spreadsheet  that has users share path such as \\dc1userhome.corp.stateauto.com\swa4444
# figure out some way to output this to have it be sorted with username and file

$inputfile = "c:\temp\searchusers.txt"
$a = get-content $inputfile
foreach($share in $a)  {
$b = $share.Substring($share.Length  - 7, 7)
write-host $share
$c = dir $share -Recurse | ? {$_.lastwritetime -gt '6/27/14' -AND $_.lastwritetime -lt '7/1/14'} | export-csv -Append -NoTypeInformation C:\temp\modifiedfilesreport.csv

}



