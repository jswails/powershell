
$computer="moegkfs01"

function Ping-Host {
  Param([string]$computername=$(Throw "You must specify a computername."))
  
  Write-Debug "In Ping-Host function"
  
  $query="Select * from Win32_PingStatus where address='$computer'"
  
  $wmi=Get-WmiObject -query $query
  write $wmi
}

$i = 1

 $pingResult=Ping-Host $computer
        
          if ($pingResult.StatusCode -ne 0) {
		  write-host  $pingresult 
		  $i = 0
		  } else { stop-process -processname xde* ; $i++
		}
		
	

