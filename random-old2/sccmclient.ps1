Param([string]$comp)
$smscli = [wmiclass] "\\$comp\root\ccm:SMS_Client"
if($smscli){
    $check = $smscli.requestmachinepolicy()
    $check = $smscli.evaluatemachinepolicy()
    } else {
    " unable to bind to wmi class" | Out-Host
    }