



$machine = "dg8xbpm1"
$colItems = gci "\\$machine\C$\appsensevirtual" -recurse -force
$finish = $colItems | Measure-Object -property length -sum
"{0:N2}" -f ($finish.sum / 1MB) + " MB"
$test = gci "\\$machine\C$\appsensevirtual"  -force | where {$_.PSIsContainer}
$test.count
