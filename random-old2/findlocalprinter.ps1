#Puts all the printer names into a file c:\temp\printers.txt and stores them on the admin3 server under qasheets
$datetime = Get-Date -Format "yyyyMMddHHmm";
$printers = gwmi win32_printer 
$user = $env:USERNAME
$machine = $env:COMPUTERNAME
if(!(test-path("c:\temp\printers"))){
mkdir "c:\temp\printers" 
"user:" + $user | out-file -Append c:\temp\printers\printers.txt
"machine:" + $machine | out-file -Append c:\temp\printers\printers.txt
foreach($p in $printers){
$p.name | out-file -append c:\temp\printers\printers.txt
} 
if(test-path("\\admin3\qasheets\RHPrinters\$env:COMPUTERNAME")) {
copy "c:\temp\printers\printers.txt" "\\admin3\qasheets\RHPrinters\$env:COMPUTERNAME\$datetime-printers.txt"
xcopy c:\temp\printers\*-printers.txt \\admin3\qasheets\RHPrinters\$env:COMPUTERNAME /y
} else {
mkdir \\admin3\qasheets\RHPrinters\$env:COMPUTERNAME\
copy "c:\temp\printers\printers.txt" "\\admin3\qasheets\RHPrinters\$env:COMPUTERNAME\$datetime-printers.txt"
xcopy c:\temp\printers\*-printers.txt \\admin3\qasheets\RHPrinters\$env:COMPUTERNAME /y
}
} else {
if(test-path("c:\temp\printers\printers.txt")) {
Rename-Item "C:\temp\printers\printers.txt" "$datetime-printers.txt"
}
"user:" + $user | out-file -Append c:\temp\printers\printers.txt
"machine:" + $machine | out-file -Append c:\temp\printers\printers.txt
foreach($p in $printers){
$p.name | out-file -append c:\temp\printers\printers.txt
} 
if(test-path("\\admin3\qasheets\RHPrinters\$env:COMPUTERNAME")) {
copy "c:\temp\printers\printers.txt" "\\admin3\qasheets\RHPrinters\$env:COMPUTERNAME\$datetime-printers.txt"
xcopy c:\temp\printers\*-printers.txt \\admin3\qasheets\RHPrinters\$env:COMPUTERNAME /y
} else {
mkdir \\admin3\qasheets\RHPrinters\$env:COMPUTERNAME\
copy "c:\temp\printers\printers.txt" "\\admin3\qasheets\RHPrinters\$env:COMPUTERNAME\$datetime-printers.txt"
xcopy c:\temp\printers\*-printers.txt \\admin3\qasheets\RHPrinters\$env:COMPUTERNAME /y
}
}
