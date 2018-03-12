
  $messageparameters = @{
  Subject = "Sync failed after 5 days for $env:COMPUTERNAME.$env:USERNAME"
  body = "Sync failed after 5 days for $env:COMPUTERNAME.$env:USERNAME"
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "OutlookDC1.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml