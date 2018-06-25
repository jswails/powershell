$computername = ""
$log = "1"
 #boot times - took longer than expected reported by windows
$Events = Get-WinEvent -computer $computername -FilterHashtable @{Logname='Microsoft-Windows-Diagnostics-Performance/Operational';Id=100}            
            
# Parse out the event message data            
ForEach ($Event in $Events) {            
    # Convert the event to XML            
    $eventXML = [xml]$Event.ToXml()            
    # Iterate through each one of the XML message properties            
    For ($i=0; $i -lt $eventXML.Event.EventData.Data.Count; $i++) {            
        # Append these as object properties            
        Add-Member -InputObject $Event -MemberType NoteProperty -Force -Name  $eventXML.Event.EventData.Data[$i].name -Value $eventXML.Event.EventData.Data[$i].'#text'            
    }            
} 
$uno = $Events | Select-Object BootstartTime,BootTime -first 1

$bt = $uno.boottime
$ts =  [timespan]::frommilliseconds($bt)
"{0:hh:mm:ss,fff}" -f ([datetime]$ts.Ticks)
$min = $ts.Minutes
$sec = $ts.Seconds
write-host "$min $sec"
$bst = $uno.bootstarttime
$date = get-date -Format "yyyy-MM-dd"
$g = $bst | select-string -Pattern "$date"
if($g){
write-host "true"
$messageparameters = @{
  Subject = "User has slow bootup today"
  body = "Computer: $computername </br>Date: $date </br> Time: $bst. </br> Long Boot Time: $min Min and $sec seconds  "
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "outlookdc1.corp.stateauto.com"
  }
  send-mailmessage @messageparameters -bodyashtml
}

"$computername,$bt,$bst" | out-file -Append C:\temp\logbackup\$log-100pm.txt

