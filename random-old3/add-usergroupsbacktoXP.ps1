import-module activedirectory
$UserName = Read-Host "Enter user name in this format: swa4444"

Add-ADGroupMember -identity "Windows XP SmartSync Pro" -Member $username
Add-ADGroupMember -identity "Windows XP Users" -Member $username
Add-ADGroupMember -identity "Folder Redirection - XP Users" -Member $username