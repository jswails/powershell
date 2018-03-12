$sharedownlog = "c:\temp\sasync-share-down.log"
$datetime = Get-Date -Format "yyyyMMddHHmm";
# robocopy options /FP = print out full path name
if(test-path($env:homeshare))
{
Write-Progress -Activity "Preparing to Sync Local to H drive" -PercentComplete 0 -Status "Starting Document Sync" -Id 1;
# sync local c docs up to H
robocopy $ENV:USERPROFILE\Documents $env:homeshare\Documents /S /XF desktop.ini sync.ffs_db /FP /log+:c:\temp\sasync.log /R:2
Write-Progress -Activity "Document Sync done from local to H drive" -PercentComplete 25 -Status "Starting Favorites Sync" -Id 1;
# sync local c favorites
robocopy $ENV:USERPROFILE\Favorites $env:homeshare\Favorites /S /XF desktop.ini sync.ffs_db /FP /log+:c:\temp\sasync.log /R:2
Write-Progress -Activity "Favorites Sync done" -PercentComplete 50 -Status "Starting Pictures Sync" -Id 1;
# sync local c pics up to h
robocopy $ENV:USERPROFILE\Pictures $env:homeshare\Pictures /S /XF desktop.ini sync.ffs_db /FP /log+:c:\temp\sasync.log /R:2
Write-Progress -Activity "Pictures Sync done" -PercentComplete 75 -Status "Starting Desktop Sync" -Id 1;
# sync local c desktop up to H
robocopy $ENV:USERPROFILE\Desktop $env:homeshare\Desktop /S /XF desktop.ini sync.ffs_db /FP /log+:c:\temp\sasync.log /R:2
Write-Progress -Activity "Desktop Sync done" -PercentComplete 100 -Status "All Sync's are done." -Id 1;
} else {
$datetime >> $sharedownlog
"no connection to homeshare found" | out-file -append $sharedownlog
$a = new-object -comobject wscript.shell
$b = $a.popup(" Your H drive was not found. Sync will not run. ",0)

}