Param([string]$servers)
# Issue warning if % free disk space is less 
$percentWarning = 15;
# Get server list

$datetime = Get-Date -Format "yyyyMMddHHmmss";
 

# How many servers
$server_count = $servers.Length;
# processed server count
$i = 0;
 
foreach($server in $servers)
{
	# Get fixed drive info
	$disks = Get-WmiObject -ComputerName $server -Class Win32_LogicalDisk -Filter "DriveType = 3";
 Add-Content "e:\wamp\tmp\$server.csv" "server,deviceID,size,freespace,percentFree";
 	# How many disks are there?
	$disk_count = $disks.Length;
 
 	$x = 0;
	foreach($disk in $disks)
	{
		
		$disk_name = $disk.Name;
		
		$deviceID = $disk.DeviceID;
		[float]$size = $disk.Size;
		[float]$freespace = $disk.FreeSpace;
 
		$percentFree = [Math]::Round(($freespace / $size) * 100, 2);
		$sizeGB = [Math]::Round($size / 1073741824, 2);
		$freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);
 
		$colour = "Green";
		if($percentFree-lt $percentWarning)
		{
			$colour = "Red";
		}
		Write-Host -ForegroundColor $colour "$server $deviceID percentage free space = $percentFree";
		Add-Content "e:\wamp\tmp\$server.csv" "$server,$deviceID,$sizeGB,$freeSpaceGB,$percentFree";
		$x++;
	}
	# Finish off the progress bar
	
	$i++;
}
