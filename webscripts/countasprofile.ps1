Param([string]$computer)
#$computer = "dg8xbpm1"

$colItems = gci "\\$computer\C$\appsensevirtual" -recurse -force
$finish = $colItems | Measure-Object -property length -sum
"{0:N2}" -f ($finish.sum / 1MB) + " MB" | out-file e:\wamp\tmp\$computer-asprofile.csv
$test = gci "\\$computer\C$\appsensevirtual"  -force | where {$_.PSIsContainer}
$test.count | out-file -append e:\wamp\tmp\$computer-asprofile.csv


$bob = (($finish.sum /1MB) / 4)

if ($bob > 30) {
 " too much!" | out-file -append e:\wamp\tmp\$computer-asprofile.csv
} else {
write-host " we are good"
}

