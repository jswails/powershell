

Param([string]$computer)


$colItems = gci "\\$computer\C$\appsensevirtual" -recurse -force
$finish = $colItems | Measure-Object -property length -sum
"{0:N2}" -f ($finish.sum / 1MB) + " MB" | export-csv -Path e:\wamp\tmp\$computer-asprofile.csv
$test = gci "\\$computer\C$\appsensevirtual"  -force | where {$_.PSIsContainer}
$test.count | export-csv -Path -append e:\wamp\tmp\$computer-asprofile.csv
