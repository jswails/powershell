$a = ( gci \\sadc1aspsd1\logs)
$stuff = $a.count
$stuff
$b = ( gci \\sadc1aspsd1\logs -recurse -filter "*.zip")
$more = $b.count
write-host $more  " zip files"

$messageparameters = @{
  Subject = "count of machines exported"
  body = "$stuff folders and $more zip files "
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "OutlookDC1.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml
