
$compname = "$env:computername"
$datetime = Get-Date -Format "yyyyMMddHHmm";


if(Test-Path("c:\temp\speedtest\")){

$log = "c:\temp\speedtest\speedtest-$datetime-$servername.txt"
} else  {
mkdir "c:\temp\speedtest"
}

    if(!(test-path("c:\temp\speedtest\speedtest-32.exe"))) { 
    xcopy \\sai\admin\Software\Workstation\speedtest\speedtest-32.exe c:\temp\speedtest\
     } 

if(test-path("c:\temp\speedtest\")){
add-content $log "Begin ----> $datetime" ;
add-content $log "--------------------------------------->" ;
add-content $log "--------------------------------------->" ;
add-content $log "Begin GOOGLE PING --------------------->" ;
add-content $log "--------------------------------------->" ;

# check internet connection
$pinggoogle = ping google.com
add-content $log $pinggoogle ;
add-content $log "--------------------------------------->" ;
add-content $log "Begin VPN PING ------------------------>" ;
add-content $log "--------------------------------------->" ;
# check vpn connection
$pingvpn= ping npv.stateauto.com
add-content $log $pingvpn ;
add-content $log "--------------------------------------->" ;
add-content $log "--------------------------------------->" ;
add-content $log "Begin IPCONFIG ------------------------>" ;
add-content $log "--------------------------------------->" ;
# display ipconfig
ipconfig
$ip = ipconfig
add-content $log $ip ;
add-content $log "--------------------------------------->" ;
add-content $log "Begin MAC CHECK ------------------------>" ;
add-content $log "--------------------------------------->" ;

# Get mac

$strcomputer = $env:COMPUTERNAME

 $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $strComputer |Where{$_.IpEnabled -Match "True"}  
     
    foreach ($objItem in $colItems) {  
     
        $objItem |select Description,MACAddress  
        
        $writemac = $objItem |select Description,MACAddress  
     
    }
    } 
    

add-content $log $writemac ;
add-content $log "--------------------------------------->" ;
add-content $log "Begin SPEED CHECK ------------------------>" ;
add-content $log "--------------------------------------->" ;


C:\temp\speedtest\speedtest-32.exe –r  > c:\temp\speedtest\speedOUTPUT-$datetime-$servername.txt

add-content $log "END ----> $datetime" ;

if(test-path("\\sai\admin\Software\Workstation\speedtest\logs\$compname")){

xcopy "c:\temp\speedtest\*.txt" \\sai\admin\Software\Workstation\speedtest\logs\$compname
} else {
mkdir \\sai\admin\Software\Workstation\speedtest\logs\$compname
xcopy "c:\temp\speedtest\*.txt" \\sai\admin\Software\Workstation\speedtest\logs\$compname
}



