clear-host

function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}
  
get-Content ".\Servers.txt" | % {
    $ServerName = $_ 
    $result = Ping-Server $_
    if($result){
        if($timeVal = (Get-WmiObject -ComputerName $ServerName -Query "SELECT LastBootUpTime FROM Win32_OperatingSystem").LastBootUpTime){
                
            #$timeVal  
            $DbPoint = [char]58  
            $Years = $timeVal.substring(0,4)  
            $Months = $timeVal.substring(4,2)  
            $Days = $timeVal.substring(6,2)  
            $Hours = $timeVal.substring(8,2)  
            $Mins = $timeVal.substring(10,2)  
            $Secondes = $timeVal.substring(12,2)  
            $dayDiff = New-TimeSpan  $(Get-Date –month $Months -day $Days -year $Years -hour $Hours -minute $Mins -Second $Secondes) $(Get-Date)  
              
            $Info = "" | select ServerName, Uptime  
            $Info.servername = $servername  
            $d =$dayDiff.days  
            $h =$dayDiff.hours  
            $m =$dayDiff.Minutes  
            $s = $daydiff.Seconds  
            $info.Uptime = "$d Days $h Hours $m Min $s Sec"  
              
            #$Info 
            $ServerName +"`t$d Days $h Hours $m Min $s Sec" 
            
            $timeVal = ""
            $d = 0
            $h = 0
            $m = 0 
            $s = 0 
        }else{
            $ServerName 
        }
    }
    else
    {
       $Info.servername = $servername
        $info.Uptime = "PingFail"
    }
} 