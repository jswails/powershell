import-module activedirectory
$UserName = Read-Host "Enter user name in this format: swa4444"

remove-adgroupmember -Identity "Windows XP SmartSync Pro" -Member $username
remove-adgroupmember -Identity "Windows XP Users" -Member $username
remove-adgroupmember -Identity "Folder Redirection - XP Users" -Member $username