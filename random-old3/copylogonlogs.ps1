# Get server list

$datetime = Get-Date -Format "yyyyMMdd";

function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

#mkdir \\sadc1sccmp1\osd\logontimes\$datetime

Get-Content ".\servers.txt" | % {
     $servername = $_
     $result = Ping-Server $_
     
   $commandline =  xcopy "\\$servername\c$\temp\logon.log" "\\sadc1sccmp1\osd\logontimes\$datetime\$servername\"  
    if($result){
    mkdir \\sadc1sccmp1\osd\logontimes\$datetime\$servername\
    $checkfile = "\\$servername\c$\temp\logon.log"
   if (test-path($checkfile)){
        $results0 = invoke-expression -command "$commandLine"
        }
    }
     else
     {
        $_ + "`tping fail"
     }
}
    
    

    





