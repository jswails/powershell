import-module activedirectory
sl ad:
sl "dc=corp,DC=stateauto,DC=com"
sl "ou=User Objects"
sl "ou=Managed"
# check all who have profile path
get-item -filter "profilePath=\\*" -path * | out-file e:\wamp\tmp\adprofile.csv

cd ..
sl "ou=Contractors"
get-item -filter "profilePath=\\*" -path * | out-file -append e:\wamp\tmp\adprofile.csv
exit