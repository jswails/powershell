#logon function
$logonfind = findstr /B Boot \\sadc1sccmp1\OSD\logontimes\20130508\D1V5KCX1\logon.log | select-object  -Last 40
$logonfind
$logonsplit = $logonfind.Split(" ")
 # logon 
 # 3 is time. 4 is date. 5 is time to logon.

$timeoflogon = $split[3]
$dateoflogon = $split[4]
$logonspeed = $split[5]

 # had to trim off the ( from the number.
$trimlogon = $logonspeed.TrimStart("(")

$timeoflogon
$ateoflogon
$trimlogon
