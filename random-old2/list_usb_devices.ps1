#list of connected usb devices
Get-ItemProperty -ea 0 hklm:\system\currentcontrolset\enum\usbstor\*\* | select FriendlyName,PSChildName
# identify first connected date for devices
Get-ItemProperty -ea 0 hklm:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\* | select PSChildName | foreach-object {$P = $_.PSChildName ; Get-Content C:\Windows\inf\setupapi.dev.log | select-string $P -SimpleMatch -context 1 }

#4. Identify the last connected date for these devices.
Get-ItemProperty -ea 0 hklm:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\* | select PSChildName | foreach-object {$P = $_.PSChildName ;Get-WinEvent -LogName Microsoft-Windows-DriverFrameworks-UserMode/Operational | where {$_.message -match "$P"} | select TimeCreated, message |sort TimeCreated -desc| ft -auto -wrap} | out-file c:\temp\usb.txt

#5. Identify the drive letters that were assigned to each of the USB devices.
Get-ItemProperty -path hklm:\system\currentcontrolset\enum\usbstor\*\* | ForEach-Object {$P = $_.PSChildName; Get-ItemProperty hklm:\SOFTWARE\Microsoft\"Windows Portable Devices"\*\* |where {$_.PSChildName -like "*$P*"} | select PSChildName,FriendlyName } | ft -auto

#7. Identify if any link files references the drive letter that the USB device used.
gwmi -ea 0 Win32_ShortcutFile | where {$_.FileName –like “*Project- MX-proposal*”} | select FileName, caption, @{Name='CreationDate'; EXPRESSION={$_.ConvertToDateTime($_.CreationDate)}},@{Name=’LastAccessed’;EXPRESSION={$_.ConvertToDateTime($_.LastAccessed)}},@{Name=’Last Modified’;EXPRESSION={$_.ConvertToDateTime($_.LastModified)}},Target | sort LastModified -Descending

