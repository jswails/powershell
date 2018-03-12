#Param([string]$job,[string]$log)
$job = "1"
$log = "1"
   $datetime = Get-Date -Format "yyyyMMdd";
  function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

 $errorlog = "c:\batchjobs\pm\error.txt" 
  $job1 = $job + ".txt"
  $cerulean = Get-Content "\\sadc1asmcp2\e$\batchjobs\lists\$job1";
  $count = $cerulean.Length;
  $k = 0;
foreach ($computerName in Get-Content "\\sadc1asmcp2\e$\batchjobs\lists\$job1")
{


$server_progress = [int][Math]::Ceiling((($k / $count) * 100))

# Parent progress bar
	Write-Progress -Activity "Checking $computername" -PercentComplete $server_progress -Status "Processing clients - $server_progress%" -Id 1;
	Sleep(1); # Sleeping just for progress bar demo
$result = Ping-Server $computername

  Trap {
                #define a trap to handle any WMI errors
                Write-Warning ("There was a problem with {0}" -f $computername.toUpper())
                Write-Warning $_.Exception.GetType().FullName
                Write-Warning $_.Exception.message
               "There was a problem with {0}" -f $computername | add-content $errorlog
               $_.Exception.GetType().FullName | add-content $errorlog
               $_.Exception.message | add-content $errorlog
                Continue
                }
 if($result){
 "start" | out-file -Append C:\batchjobs\pm\100\start.txt


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
#$uno = $Events | Select-Object BootstartTime,BootTime -first 1
$septem = $Events | Select-Object BootstartTime,BootTime -first 7

foreach($octo in $septem){
$7days = $octo.boottime
$7start = $octo.bootstarttime

$ts =  [timespan]::frommilliseconds($7days)
"{0:hh:mm:ss,fff}" -f ([datetime]$ts.Ticks)
$min = $ts.Minutes
$sec = $ts.Seconds



if ($min -gt 2 ){


"$computername,$7days,$7start" | out-file -Append c:\batchjobs\pm\100\$log-100pm-7days.txt

}

}
}


#event 101 gather
#$Events = Get-WinEvent -computer $computername -FilterHashtable @{Logname='Microsoft-Windows-Diagnostics-Performance/Operational';Id=101}            
            
# Parse out the event message data            
#ForEach ($Event in $Events) {            
    # Convert the event to XML            
 #   $eventXML = [xml]$Event.ToXml()            
    # Iterate through each one of the XML message properties            
  #  For ($i=0; $i -lt $eventXML.Event.EventData.Data.Count; $i++) {            
   #     # Append these as object properties            
    #    Add-Member -InputObject $Event -MemberType NoteProperty -Force -Name  $eventXML.Event.EventData.Data[$i].name -Value $eventXML.Event.EventData.Data[$i].'#text'            
    #}            
#} 
#$dos = $Events | Select-Object StartTime,Name,Path,TotalTime,DegradationTime -first 20 | export-csv -Append e:\batchjobs\pm\101\$log-$computername-101pm.csv -NoTypeInformation
#$quattuor = $Events | Select-Object StartTime,Name,Path,TotalTime,DegradationTime -first 20 
#foreach ( $tres in $quattuor) {
#$starttime = $tres.StartTime
#$appname = $tres.Name
#$apppath = $tres.Path
#$appTotalTime = $tres.TotalTime
#$appdegradeTime = $tres.DegradationTime



#"$computername,$starttime,$appname,$apppath,$appTotalTime,$appdegradeTime" | out-file -Append e:\batchjobs\pm\101\$log-101pm.txt
#}

#} # this goes to the if($result)
#} # this goes back up to the foreach at top

$k++
}
Write-Progress -Activity "Checked all clients" -PercentComplete 100 -Status "Done - 100%" -Id 1;
Sleep(1);
