Import-Module activedirectory

$a = get-adcomputer -filter { operatingsystem -notlike '*windows server*'} -Properties operatingsystem | select name | export-csv c:\ad.csv -NoTypeInformation
$a.count

$a = gc C:\temp\allad.csv
$b = $a.count / 14
(gc c:\temp\1.txt).count
(gc c:\temp\2.txt).count
$c = $a | select -first ($b)  | out-file -append c:\temp\1.txt
$d = $a | select -skip ($b) | select -first ($b) | out-file -append c:\temp\2.txt
$e = $a | select -skip ($b * 2) | select -first ($b) | out-file -append c:\temp\3.txt
$f = $a | select -skip ($b * 3) | select -first ($b) | out-file -append c:\temp\4.txt
$g = $a | select -skip ($b * 4) | select -first ($b) | out-file -append c:\temp\5.txt
$h = $a | select -skip ($b * 5) | select -first ($b) | out-file -append c:\temp\6.txt
$i = $a | select -skip ($b * 6) | select -first ($b) | out-file -append c:\temp\7.txt
$j = $a | select -skip ($b * 7) | select -first ($b) | out-file -append c:\temp\8.txt
$k = $a | select -skip ($b * 8) | select -first ($b) | out-file -append c:\temp\9.txt
$l = $a | select -skip ($b * 9) | select -first ($b) | out-file -append c:\temp\10.txt
$m = $a | select -skip ($b * 10) | select -first ($b) | out-file -append c:\temp\11.txt
$n = $a | select -skip ($b * 11) | select -first ($b) | out-file -append c:\temp\12.txt
$o = $a | select -skip ($b * 12) | select -first ($b) | out-file -append c:\temp\13.txt
$p = $a | select -skip ($b * 13) | select -first ($b) | out-file -append c:\temp\14.txt
$q = $a | select -skip ($b * 14) | select -first ($b) | out-file -append c:\temp\15.txt
(gc c:\temp\1.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\1.txt
(gc c:\temp\2.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\2.txt
(gc c:\temp\3.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\3.txt
(gc c:\temp\4.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\4.txt
(gc c:\temp\5.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\5.txt
(gc c:\temp\6.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\6.txt
(gc c:\temp\7.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\7.txt
(gc c:\temp\8.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\8.txt
(gc c:\temp\9.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\9.txt
(gc c:\temp\10.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\10.txt
(gc c:\temp\11.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\11.txt
(gc c:\temp\12.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\12.txt
(gc c:\temp\13.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\13.txt
(gc c:\temp\14.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\14.txt
(gc c:\temp\15.txt) | ? {$_.trim() -ne "" } | set-content c:\temp\15.txt