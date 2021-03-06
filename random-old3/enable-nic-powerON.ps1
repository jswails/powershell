# Get server list

function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

Get-Content "c:\scripts\audit\win7machines-appsense.txt" | % {
     $servername = $_
     $result = Ping-Server $_
     
    if($result){

#find if netenabled

$nic= gwmi win32_networkadapter -filter "netenabled = 'true'" -cn $servername

$nicPower = gwmi MSPower_DeviceWakeEnable -Namespace root\wmi -cn $servername |

  where {$_.instancename -match [regex]::escape($nic.PNPDeviceID) }
# check to see if machine has enable power to true
if ($nicPower.Enable -eq $true)
{
}
else
{
$servername | out-file -append c:\scripts\wolstatus.txt
$nicPower.Enable | out-file -append c:\scripts\wolstatus.txt
 
# this sets it so nic can power machine
$nicPower.Enable = $true
# this applies the enable = true
$nicPower.psbase.Put()
# this forces a reboot
#(gwmi win32_operatingsystem -cn $servername ).reboot()
$servername | out-file -append c:\scripts\wolenabled.txt
"enabled wol on machine" | out-file -append c:\scripts\wolenabled.txt

}
}
}



