import-module activedirectory
sl ad:
sl "dc=corp,DC=stateauto,DC=com"
sl "ou=User Objects"
sl "ou=Managed"
$checkpath = get-item -filter "profilePath=\\*" -path *

$messageparameters = @{
  Subject = " Win 7 Users with profile paths"
  body = " Here are the list of users with profiles: $checkpath"
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "OutlookDC1.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml