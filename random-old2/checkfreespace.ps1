﻿cls
# Issue warning if % free disk space is less 
$percentWarning = 15;
# Get server list
$servers = Get-Content "13.txt";
$datetime = Get-Date -Format "yyyyMMddHHmmss";
 
# Add headers to log file
Add-Content "$Env:USERPROFILE\server disks $datetime.txt" "server,deviceID,size,freespace,percentFree";
# How many servers
$server_count = $servers.Length;
# processed server count
$i = 0;
 
foreach($server in $servers)
{
	$server_progress = [int][Math]::Ceiling((($i / $server_count) * 100))
	# Parent progress bar
	Write-Progress -Activity "Checking $server" -PercentComplete $server_progress -Status "Processing servers - $server_progress%" -Id 1;
	Sleep(1); # Sleeping just for progress bar demo
	# Get fixed drive info
	$disks = Get-WmiObject -ComputerName $server -Class Win32_LogicalDisk -Filter "DriveType = 3";
 
 	# How many disks are there?
	$disk_count = $disks.Length;
 
 	$x = 0;
	foreach($disk in $disks)
	{
		$disk_progress = [int][Math]::Ceiling((($x / $disk_count) * 100));
		$disk_name = $disk.Name;
		Write-Progress -Activity "Checking disk $disk_name" -PercentComplete $disk_progress -Status "Processing server disks - $disk_progress%" -Id 2;
		Sleep(1);
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
		Add-Content ".\server disks $datetime.txt" "$server,$deviceID,$sizeGB,$freeSpaceGB,$percentFree";
		$x++;
	}
	# Finish off the progress bar
	Write-Progress -Activity "Finshed checking disks for this server" -PercentComplete 100 -Status "Done - 100%" -Id 2;
	Sleep(1); # Just so we see!
	$i++;
}
Write-Progress -Activity "Checked all servers" -PercentComplete 100 -Status "Done - 100%" -Id 1;
Sleep(1);
