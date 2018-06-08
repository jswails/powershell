# Adapted from: http://powershell.com/cs/media/p/3215.aspx
 

   
  function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

 $errorlog = "c:\batchjobs\printq.txt" 

foreach ($computerName in Get-Content "c:\batchjobs\pg.txt")
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
 if(test-path("\\$computername\c$\packages\scriptmonitor")){
 
 ri  \\$computername\C$\packages\scriptmonitor\printq.flag
 } else {

 $computername | out-file -Append C:\batchjobs\notfound.txt
 }
    
}
}
