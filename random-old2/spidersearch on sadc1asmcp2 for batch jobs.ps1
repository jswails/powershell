# Adapted from: http://powershell.com/cs/media/p/3215.aspx
 
Param([string]$job)
   
  function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

 $errorlog = "e:\batchjobs\error\profileerrorlog.txt" 
  $job1 = $job + ".txt"
foreach ($computerName in Get-Content "e:\batchjobs\lists\$job1")
{
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
    if(test-path("\\$computername\C$\appsensevirtual\")) {
        
$colItems = gci "\\$computername\C$\appsensevirtual" -recurse -force
$finish = $colItems | Measure-Object -property length -sum
"{0:N2}" -f ($finish.sum / 1MB) + " MB" 
$test = gci "\\$computername\C$\appsensevirtual"  -force | where {$_.PSIsContainer}
$test.count 


$bob = (($finish.sum /1MB) / $test.count)

if ($bob -gt 30) {
"{0:N2}" -f ($finish.sum / 1MB) + " MB" | out-file -append e:\batchjobs\bad\$computername-asprofile.csv 
$test.count | out-file -append e:\batchjobs\bad\$computername-asprofile.csv
 " BAD!" | out-file -append e:\batchjobs\bad\$computername-asprofile.csv
 
} else {
write-host " we are good"
}
} else {
"{0:N2}" -f ($finish.sum / 1MB) + " MB" | out-file -append e:\batchjobs\unknown\$computername-asprofile.csv 
$test.count | out-file -append e:\batchjobs\unknown\$computername-asprofile.csv
"some issue unknown" | out-file -append e:\batchjobs\unknown\$computername-asprofile.csv
}

          
    }  
    
}


