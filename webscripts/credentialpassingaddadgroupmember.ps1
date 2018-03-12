Param([string]$adduser)
import-module activedirectory
#$adduser = "bon9997"
#$username = 

#$domainuser =  "sai\" + $username  
#$password = cat \\sadc1cmadmp1\e:\wamp\www\IAM\secure\$username\securestring.txt | convertto-securestring
#$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $domainuser, $password

         Add-ADGroupMember -Identity "Users - Local Admin - Workstation Administrators" -Member $adduser