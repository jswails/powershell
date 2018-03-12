Param([string]$adduser,[string]$username)
import-module activedirectory
#$adduser = "bon9997"
#$username = 
$password = cat \\sadc1cmadmp1\e$\wamp\www\IAM\secure\$username\securestring.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $username, $password

         Add-ADGroupMember -Identity "AppSense-VisioUsers" -Member $adduser -Credential $cred