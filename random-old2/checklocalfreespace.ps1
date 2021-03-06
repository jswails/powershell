
$servers = ".";
 
foreach($server in $servers)
{

	$disks = Get-WmiObject -ComputerName $server -Class Win32_LogicalDisk -Filter "DriveType = 3";
 
 	
	foreach($disk in $disks)
	{
		
		$disk_name = $disk.Name;
		
		$deviceID = $disk.DeviceID;
		[float]$size = $disk.Size;
		[float]$freespace = $disk.FreeSpace;
 
	
		$sizeGB = [Math]::Round($size / 1073741824, 2);
		$freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);
 
	
		Write-Host  "$server $deviceID percentage free space in GB = $freespaceGB";
		
	}
}
