# check for version of OS and office
#clear the values
$office201032bit = ""
$office201064bit = ""
$office200732bit = ""
$office200764bit = ""
$office201332bit = ""
$office201364bit = ""
$installed = ""
$testoffice = ""
$proc = ""

# set static variables
$log = "c:\temp\ddecleanlog.txt"
$datetime = Get-Date -Format "yyyyMMddHHmm";

# begin testing
mkdir c:\temp\ddeclean | Out-Null
# test for office 2010
$proc = $env:PROCESSOR_ARCHITECTURE
if($proc = "x86")
{
$testoffice = "C:\Program Files\Microsoft Office\Office14\excel.exe"
if(Test-Path($testoffice)){
$office201032bit = "Office 2010 on 32bit OS installed"
write-host $office201032bit
$installed = $office201032bit
}else{
$testoffice = "C:\Program Files (x86)\Microsoft Office\Office14\excel.exe"
if(Test-Path($testoffice)){
$office201064bit = "Office 2010 on 64 bit OS installed"
write-host $office201064bit
$installed = $office201064bit
}
}
}
# test for office 2007
$proc = $env:PROCESSOR_ARCHITECTURE
if($proc = "x86")
{
$testoffice = "C:\Program Files\Microsoft Office\Office12\excel.exe"
if(Test-Path($testoffice)){
$office200732bit = "Office 2007 on 32bit OS installed"
write-host $office200732bit
$installed = $office200732bit
}else{
$testoffice = "C:\Program Files (x86)\Microsoft Office\Office12\excel.exe"
if(Test-Path($testoffice)){
$office200764bit = "Office 2007 on 64 bit OS installed"
write-host $office200764bit
$installed = $office200764bit
}
}
}
# test for office 2013
$proc = $env:PROCESSOR_ARCHITECTURE
if($proc = "x86")
{
$testoffice = "C:\Program Files\Microsoft Office\Office15\excel.exe"
if(Test-Path($testoffice)){
$office201332bit = "Office 2013 on 32bit OS installed"
write-host $office201332bit
$installed = $office201332bit
}else{
$testoffice = "C:\Program Files (x86)\Microsoft Office\Office15\excel.exe"
if(Test-Path($testoffice)){
$office201364bit = "Office 2013 on 64 bit OS installed"
write-host $office201364bit 
$installed = $office201364bit 
}
}
}
if($installed -eq $office201364bit){
write-host " No dde changes have been made before"
}
# begin the setup of files
$datetime | out-file -append $log
 $installed | out-file -append $log

# office 2010 32 bit

if($installed -eq $office201032bit){
"begin xcopy of office 2010 32 bit reg keys" | out-file -append $log
xcopy \\sadc1cm12pkgp1\Packages\stateauto\ddefix_office2010_win7x86\OriginalKeys\* c:\temp\ddeclean\* /y 
$getkeys = Get-Content "c:\temp\ddeclean\ddereset.txt" 
"begin start of processing reg import of keys" | out-file -append $log
foreach ($file in $getkeys) {
$a = "c:\temp\ddeclean\" + $file
reg.exe import $a

$file | out-file -append $log
}
"done processing reg import keys" | out-file -append $log
}

# office 2010 64 bit

if($installed -eq $office201064bit){
"begin xcopy of office 2010 32 bit reg keys" | out-file -append $log
xcopy \\sadc1cm12pkgp1\Packages\stateauto\ddereset_office2010x86_w7x64\* c:\temp\ddeclean\* /y 
$getkeys = dir c:\temp\ddeclean\
"begin start of processing reg import of keys" | out-file -append $log
foreach ($file in $getkeys) {
$a = "c:\temp\ddeclean\" + $file
reg.exe import $a 

$file | out-file -append $log
}
"done processing reg import keys" | out-file -append $log
}

# office 2007 on 32 bit
if($installed -eq $office200732bit){
"begin xcopy of office 2007 32 bit reg keys" | out-file -append $log
xcopy \\sadc1cm12pkgp1\Packages\stateauto\DDEfix_RTW_Office07-10_win7x86\OriginalKeys-Office2007\* c:\temp\ddeclean\* /y 
$getkeys = Get-Content "c:\temp\ddeclean\ddeclean.txt" 
"begin start of processing reg import of keys" | out-file -append $log
foreach ($file in $getkeys) {
$a = "c:\temp\ddeclean\" + $file
reg.exe import $a 

$file | out-file -append $log
}
"done processing reg import keys" | out-file -append $log

}