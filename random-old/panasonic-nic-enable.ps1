$nic= gwmi win32_networkadapter -filter "netenabled = 'true'" -cn .

$nicPower = gwmi MSPower_DeviceWakeEnable -Namespace root\wmi -cn . |

  where {$_.instancename -match [regex]::escape($nic.PNPDeviceID) }

$nicPower.Enable = $true

$nicPower.psbase.Put()