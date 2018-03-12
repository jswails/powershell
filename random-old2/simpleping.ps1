function Ping-Server {
   Param([string]$server)
 
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
  
}
cls
Get-Content "C:\scripts\bl.txt" | % {
    if(Ping-Server $_){
        "{0}`tpass" -f $_  | out-file -append c:\scripts\blpassping2.txt
    }
    else
    {
        "{0}`tfail" -f $_ | out-file -append c:\scripts\blfailping2.txt
		
    }
	
}