
# if current IP is a 192.168 then dont kill nac exe. otherwise kill it

# Get mac

$strcomputer = $env:COMPUTERNAME

 $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $strComputer |Where{$_.IpEnabled -Match "True"}  
     
    foreach ($objItem in $colItems) {  
     
        $objItem |select Description,IPAddress  
        
        $writemac = $objItem |select Description,IPAddress  
     
    } 
    
    $ip = $writemac.ipaddress
    
  if (test-path c:\temp\nac.txt)
{
 ri c:\temp\nac.txt
}
$curip = $ip | select-object  -first 1
$curip | out-file c:\temp\nac.txt

if  (!(test-path c:\tools\pstools\psexec.exe))
{
robocopy \\sadc1sccmp1\osd\tools\pstools c:\tools\pstools
}
 if ($curip -like "10.*") 
 { write-host " ip like 10."
c:\tools\pstools\pskill /accepteula nacagentui.exe
net stop nacagentui.exe
"ran pskill for nacagentui" | out-file -append c:\temp\nac.txt
c:\tools\pstools\pskill /accepteula nacagent.exe
net stop nacagent.exe
"ran pskill for nacagent" | out-file -append c:\temp\nac.txt
 }