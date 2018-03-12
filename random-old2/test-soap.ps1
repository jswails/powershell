Param([string]$mach,[string]$collid)
$messageparameters = @{
  Subject = "User has slow bootup today"
  body = "Computer: $computername </br>Date: $date </br> Time: $bst. </br> Long Boot Time: $min Min and $sec seconds  "
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "outlookdc1.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml