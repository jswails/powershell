# Start VM’s that are powered off and match the given computer name pattern
$vmList =  get-vm | where-object {$_.powerstate -eq "poweredoff" -and $_.Name -like "blarg*"}
ForEach($vm in $vmList)
{
start-vm -RunAsync -VM $vm -Confirm:$false
write-output "$VM was started $(Get-Date -format 'G')" | Out-File c:\vm-boot-log.txt -Append
Start-sleep -s 15
}
