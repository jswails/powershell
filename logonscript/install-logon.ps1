# install
$logondir =  "C:\Packages\logonscript"
if(!(test-path($logondir))){
mkdir $logondir }

xcopy *.* $logondir\* /s /y
ren $logondir\1.1 $logondir\1.ps1 ; powershell.exe -file $logondir\1.ps1
ri $logondir\1.ps1
ri "C:\Packages\logonscript\install-logon.ps1"
ri "C:\Packages\logonscript\serial number monitor script.xml"
xcopy logon.cmd "C:\Users\All Users\Microsoft\Windows\Start Menu\Programs\Startup\" /y 

rmdir c:\tools
rmdir c:\scripts
