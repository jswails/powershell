# Get server list
$servers = Get-Content ".\servers.txt";
$datetime = Get-Date -Format "yyyyMMddHHmmss";
 
# Add headers to log file
Add-Content "$Env:USERPROFILE\server memory $datetime.txt" "server,memorystick,partnumber";
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
	$memory = gwmi -query "select * from win32_physicalmemory" -ComputerName $server;
#	$partnumber = $memory | Select-Object partnumber 
	

$disk_count = $memory.length;
$x = 0;
foreach($stick in $memory)
	{
		$disk_progress = [int][Math]::Ceiling((($x / $disk_count) * 100));
		$stick = $memory | Select-Object tag;
		$partnumber = $memory | Select-Object partnumber;
		Write-Progress -Activity "Checking stick $stick" -PercentComplete $disk_progress -Status "Processing server - $disk_progress%" -Id 2;
		Sleep(1);

 		

		Add-Content ".\server memory $datetime.txt" "$server,$stick,$partnumber";
		$x++;
	}
	
			# Finish off the progress bar
	Write-Progress -Activity "Finshed checking disks for this server" -PercentComplete 100 -Status "Done - 100%" -Id 2;
	Sleep(1); # Just so we see!
	$i++;
}
Write-Progress -Activity "Checked all servers" -PercentComplete 100 -Status "Done - 100%" -Id 1;
Sleep(1);