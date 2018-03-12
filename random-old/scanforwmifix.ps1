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
        $testPath = "\\"+ $ServerName +"\c$\Windows\SysWOW64\CCM\Cache\GKC0006C.1.System"
        if(Test-Path($testPath)){
        $ServerName + " sucess"
        }else{
            $ServerName + " FAIL"
        }
    }
}
