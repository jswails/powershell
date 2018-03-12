$computername = "E7HQPTY1"
$details1 = (get-eventlog -computer $computername system | where-object {$_.EventID -eq "46"})[0].TimeGenerated

$y = get-date
$compname = $env:COMPUTERNAME
$username = $env:USERNAME

$details3 = get-date -format g
$time = $y - $details1

$disp = ($compname, $username, $details3, $time) -join "^"
$disp | Out-File -Append c:\temp\lastuser.txt

ping E7HQPTY1