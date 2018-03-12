$strComputer = "."
$Nics = Get-wmiobject win32_NetworkAdapter -comp $strComputer |where {$_.description -eq "WAN Miniport (IP)"}
foreach ($Nic in $Nics)
{
$Config = Get-Wmiobject win32_NetworkAdapterConfiguration | where {$_.index -eq $Nic.index}
if ($config.IPAddress -ne "$null")
{$VGateway = $config.DefaultIPGateway; $VGateway}
}
