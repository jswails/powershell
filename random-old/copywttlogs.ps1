# Get server list

$datetime = Get-Date -Format "yyyyMMdd";




function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

mkdir \\wwtdfs01\share\v-joswai\wtt-issues\$datetime
cls
Get-Content ".\servers.txt" | % {
    $result = Ping-Server $_
    $servername = $_
    $commandLine0 = "xcopy" "\\$servername\"c$\Program Files (x86)\WTTMobile\Client\DevicePoint_output.txt" "\\wwtdfs01\share\v-joswai\wtt-issues"\$datetime\$servername"  
 #   $commandLine1 = xcopy \\$servername"\c$\Program Files (x86)\WTTMobile\Client\WTTClient_output.txt" "\\wwtdfs01\share\v-joswai\wtt-issues"\$datetime\$servername  
#	$commandLine2 = xcopy \\$servername"\c$\Program Files (x86)\WTTMobile\Client\WTTMessaging.log" "\\wwtdfs01\share\v-joswai\wtt-issues"\$datetime\$servername 
    if($result){
        $results0 = invoke-expression -command "$commandLine0"
#	$results1 = invoke-expression -command $commandLine1
#	$results2 = invoke-expression -command $commandLine2
     }
     else
     {
        $_ + "`tping fail"
     }
}


 C:\PS>copy-item C:\Wabash\Logfiles\mar1604.log.txt -destination C:\Presentation
