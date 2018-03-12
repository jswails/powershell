$strComputer = "."
$Nics = Get-wmiobject win32_NetworkAdapter -comp $strComputer 
foreach ($Nic in $Nics)
{
$Config = Get-Wmiobject win32_NetworkAdapterConfiguration | where {$_.index -eq $Nic.index}
if ($config.IPAddress -ne "$null")
{$VGateway = $config.DefaultIPGateway; $VGateway}
}
