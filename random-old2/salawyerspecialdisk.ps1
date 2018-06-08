# state auto Lawyers special disk Execute

$disktemp = "c:\temp\SALawyerSpecialDisk"
$scriptsdir ="c:\scripts"
$time = get-date
Write-host "###############################################################"
write-host "#      Lawyers Special Disk Execution Tool         #"
write-host "#                                                             #"
write-host "###############################################################"  
Write-host -ForegroundColor Red " Use of this Tool is monitored and logged."
$cddrive = Read-Host "Please enter the disk drive letter of the CD/DVD to read. It is most likely D."
if ($cddrive -ne "d")
{ write-host " You did not choose the D drive. Are you sure?"
$cddrive =  Read-Host "If you are sure then enter the disk drive letter again else change it to D."
}
if(test-path $cddrive":") {

cd $cddrive":"

# cleanup old files first
if(test-path $disktemp) {
remove-item -Force -recurse $disktemp
}

#logging
$env:USERNAME  | out-file -Append $scriptsdir\$env:COMPUTERNAME-x15protocol.txt
 "Started Special disk Execution Script on" | out-file -Append $scriptsdir\$env:COMPUTERNAME-x15protocol.txt
$time | out-file -Append $scriptsdir\$env:COMPUTERNAME-x15protocol.txt
"####################" | out-file -Append $scriptsdir\$env:COMPUTERNAME-x15protocol.txt
# end logging

mkdir $disktemp | Out-Null
Write-Progress -Activity "Preparing Special Disk Execution using X-15 Protocol" -PercentComplete 50 -Status "Please Wait" -Id 1;
xcopy  *.* $disktemp  /q | Out-Null
Write-Progress -Activity "Special Disk Execution using X-15 Protocol" -PercentComplete 100 -Status "Special Disk Execution Protocol applied" -Id 1;

$a = new-object -comobject wscript.shell
$b = $a.popup(" Program completed. Please proceed to install your software. ",0)
explorer $disktemp

} else {
write-host " The drive you selected does not exist or you have no rights to it. Exiting program."
pause
}



