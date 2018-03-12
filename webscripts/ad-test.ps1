Import-Module activedirectory

$a = get-adcomputer -filter { operatingsystem -notlike '*windows server*'} -Properties operatingsystem | select name | export-csv c:\ad.csv -NoTypeInformation
$a.count

$a = gc C:\temp\allad.txt
$b = $a.count / 14
(gc c:\temp\1.txt).count
(gc c:\temp\2.txt).count
$c = $a | select -first ($b)  | out-file -append c:\temp\1.txt
$d = $a | select -skip ($b) | select -first ($b) | out-file -append c:\temp\2.txt
$e = $a | select -skip ($b * 2) | select -first ($b) | out-file -append c:\temp\3.txt

(gc c:\temp\1.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\1.txt
(gc c:\temp\2.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\2.txt
(gc c:\temp\3.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\3.txt