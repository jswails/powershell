# install
$smdir =  "C:\Packages\scriptmonitor"
if(!(test-path($smdir))){
mkdir $smdir
} else {
Push-Location
xcopy *.* $smdir\*
ren $smdir\1.1 $smdir\1.ps1 ; powershell.exe -file $smdir\1.ps1
ri $smdir\1.ps1

if(!(test-path("C:\Windows\System32\WindowsPowerShell\v1.0\Modules\registrium\regscan.psm1"))){
    mkdir "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\registrium\"
        xcopy "$smdir\registrium\*" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\registrium\"
        } else { xcopy "$smdir\registrium\*" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\registrium\" }

        #check for mof existence whether it needs to run for first time.
if(!(test-path("$smdir\productslist.mof"))){
xcopy productslist.mof $smdir\
c:\Windows\System32\wbem\mofcomp.exe c:\packages\scriptmonitor\productslist.mof
} else { c:\Windows\System32\wbem\mofcomp.exe c:\packages\scriptmonitor\productslist.mof}
Pop-Location
        }
