Param([string]$adduser)
import-module activedirectory


         Add-ADGroupMember -Identity "Users - Local Admin - Workstation Administrators" -Member $adduser
