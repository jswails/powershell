# install
$smdir =  "C:\Packages\scriptmonitor"
if(!(test-path($smdir))){
mkdir $smdir
"start" | out-file c:\temp\spectare.log
xcopy *.* $smdir\* /s /y
ren $smdir\1.1 $smdir\1.ps1 ; powershell.exe -file $smdir\1.ps1
ri $smdir\1.ps1
ri $smdir\1.1
ri "C:\Packages\scriptmonitor\install-spectare.ps1"
ri "C:\Packages\scriptmonitor\spectare scriptus.xml"

        #check for mof existence whether it needs to run for first time.

 c:\Windows\System32\wbem\mofcomp.exe c:\packages\scriptmonitor\productslist.mof

} else {
"start" | out-file c:\temp\spectare.log
xcopy *.* $smdir\* /s /y
if(test-path("$smdir\bug.log")){
ri $smdir\bug.log
}
ren $smdir\1.1 $smdir\1.ps1 ; powershell.exe -file $smdir\1.ps1
ri $smdir\1.ps1
ri $smdir\1.1
ri "C:\Packages\scriptmonitor\install-spectare.ps1"
ri "C:\Packages\scriptmonitor\spectare scriptus.xml"


        #check for mof existence whether it needs to run for first time.

c:\Windows\System32\wbem\mofcomp.exe c:\packages\scriptmonitor\productslist.mof

        }
