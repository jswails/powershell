
import-module activedirectory

$checkname = Get-ADGroupMember -identity "Users - Local Admin - Workstation Administrators" 
$checkname.samaccountname

#grab id and do a compare to make sure they match