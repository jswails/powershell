#enter users account id
$User = Read-Host “Enter the Users’ Logon Name that you want to backup”
$colour = "Green";
Takeown /r /a /f C:\Windows\CSC
write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
write-host -ForegroundColor $colour "######################################### ######################################### #########################################"
write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
$checkrights = read-host " check output to see if takeown worked. If it failed then manually change permissions and type FAIL here otherwise script continues."

if ($checkrights -eq "fail")
{ write-host -ForegroundColor red " exiting script"
exit
} else {

write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
write-host -ForegroundColor $colour "######################################### ######################################### #########################################"
write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
icacls C:\Windows\CSC\v2.0.6\namespace\DC1USERHOME.CORP.STATEAUTO.COM\$user\* /t /c /q /grant Administrators:F
write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
write-host  " you can ignore ICACL errors as there will always be some errors unless it fails on all then you have to set perms manually"
#this checks size of cache to alert you ahead of time how large the copy is going to be

write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
write-host -ForegroundColor $colour "######################################### ######################################### #########################################"
write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
write-host  " Size of Local Cache"

$colItems = (gci -r C:\Windows\CSC\v2.0.6\namespace\DC1USERHOME.CORP.STATEAUTO.COM\$user\* -ErrorAction SilentlyContinue | Measure-Object -property length -sum)
"{0:N2}" -f ($colItems.sum / 1MB) + " MB"

write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
write-host -ForegroundColor $colour "######################################### ######################################### #########################################"
write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
#################################
# check the size of the freespace on local drive to see if enough space to move files


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

#### end of checking disk space
# will wait now for tech to confirm there is space

write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
write-host -ForegroundColor $colour "######################################### ######################################### #########################################"
write-host -ForegroundColor $colour " ####################################### ####################################### #######################################"
do {
function Read-Choice {
  PARAM([string]$message, [string[]]$choices, [int]$defaultChoice=0, [string]$Title=$null )
  $Host.UI.PromptForChoice( $caption, $message, [Management.Automation.Host.ChoiceDescription[]]$choices, $defaultChoice )
}
$choice = Read-Choice "Is there enough space to continue"  @("&Y","&N")
if ($choice -eq "0"){
write-host " Robocopy is going to begin now"
robocopy C:\Windows\CSC\v2.0.6\namespace\DC1USERHOME.CORP.STATEAUTO.COM\$user\ c:\temp\cachebackup /S /R:0 /W:0 /LOG:c:\temp\cachebackup.log
}
if ($choice -eq "1"){
write-host " you chose to cancel the robocopy due to space concerns, manually copy the cache"
}
 }while ($response -eq "y")

 #end of fail else statement is down here
 }



