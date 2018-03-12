


# Get server list

$datetime = Get-Date -Format "yyyyMMdd";

function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}


Get-Content "c:\scripts\audit\servers.txt" | % {
     $servername = $_
     $result = Ping-Server $_
     
    if($result){
 
    $checkfile = "\\$servername\c$\users\*.sai"
   if (test-path($checkfile)){
     "$servername - temp file found" | out-file -append c:\scripts\audit\sai-tempfiles.txt
        }
    }
     else
     {
        $_ + "`tping fail"
     }
}