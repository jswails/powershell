$UserName = Read-Host "Enter user name in this format: Swails, John"

# Finding the location of the user account :

$Root = [ADSI]''

$searcher = new-object System.DirectoryServices.DirectorySearcher($root)

$searcher.filter = "(&(objectClass=user)(DisplayName= $UserName))"

$User = $searcher.findone()

# Binding the user account to $AUser and the OU to move to to $MovetoOU

$ADSPath = $User.Properties.adspath

$MoveToOU = [ADSI]("LDAP://OU=Windows XP Users,DC=corp,DC=stateauto,DC=com")

$AUser = [ADSI]("$ADSPath")

# Command to Do the actual move

$AUser.PSBase.moveto($MoveToOU)

write-host " User Moved back to Windows XP Users OU"