
# if current IP is a 192.168 then dont kill nac exe. otherwise kill it

# Get mac

$strcomputer = $env:COMPUTERNAME

 $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $strComputer |Where{$_.IpEnabled -Match "True"}  
     
    foreach ($objItem in $colItems) {  
     
        $objItem |select Description,IPAddress  
        
        $writemac = $objItem |select Description,IPAddress  
     
    } 
    
    $ip = $writemac.ipaddress
    
    
    

$curip = $ip | select-object  -first 1

 if ($curip -like "10.*") 
 { write-host " ip like 10."
pskill /accepteula nacagentui.exe
pskill /accepteula nacagent.exe
 }


