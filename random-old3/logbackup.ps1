﻿function Add-Zip
{
 param([string]$zipfilename)

 if(-not (test-path($zipfilename)))
 {
  set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
  (dir $zipfilename).IsReadOnly = $false 
 }
 
 $shellApplication = new-object -com shell.application
 $zipPackage = $shellApplication.NameSpace($zipfilename)
 
 foreach($file in $input) 
 { 
            $zipPackage.CopyHere($file.FullName)
            Start-sleep -milliseconds 500
 }
} 
mkdir c:\temp\qa
$tools = "c:\temp\qa"
$datetime = Get-Date -Format "yyyyMMddHHmm"
# export logs
copy c:\windows\windowsupdate.log $tools\

# test sccm path and copy logs
if (test-path C:\Windows\SysWOW64\CCM\Logs) {
mkdir $tools\sccmlogs
copy C:\Windows\SysWOW64\CCM\Logs\*.log $tools\sccmlogs
} else {
mkdir $tools\sccmlogs
copy C:\Windows\System32\CCM\Logs\*.log $tools\sccmlogs
}

# execute the backup function
dir $tools\*.* | add-zip $tools\$env:COMPUTERNAME-$datetime.zip

copy $tools\*.zip \\admin\Software\Workstation\ClientSupportUtility\$computername
