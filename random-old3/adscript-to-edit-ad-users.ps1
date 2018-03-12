import-module activedirectory
sl ad:
sl "dc=corp,DC=stateauto,DC=com"
sl "ou=User Objects"
sl "ou=Managed"
sl "ou=Contractors"
sl "ou=Workstations"

sl "ou=Windows XP Systems"
sl "ou=Windows 7 Systems Test"
sl "ou=Windows 7 Systems"
sl "ou=Windows XP Systems - VDI"
sl "ou=Windows 7 VDI Systems"
#check description field for windows 7 user explicitly
get-item -filter "description=windows 7 user" -path *

get-item -filter "description=Windows XP User" -path *
# this will clear out the description field.
set-itemproperty -filter "description=windows 7 user" -path * -name description -value  " " -whatif
set-itemproperty -filter "description=Windows XP User" -path * -name description -value " Windows 7 user " -whatif
#check all who have a profile path
get-item -filter "profilePath=\\*" -path *

# this could clear out the profile path
set-itemproperty -filter "profilepath=\\*" -path * -name profilepath -value " " -whatif

