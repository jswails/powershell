
$intervit = get-content C:\TEMP1\machines.txt
foreach ($exo in $intervit)
 { x=0
 $exo | out-file C:\TEMP1\1.txt