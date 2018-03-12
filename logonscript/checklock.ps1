Param([string]$lockstate)
# accept arguments of lock or unlock
 $datetimefull = Get-Date -Format "yyyyMMddHHmmss";
 $user = cat C:\Packages\logonscript\user.txt
 $machine = $env:COMPUTERNAME

"$lockstate,$machine,$user,$datetimefull" | out-file -append C:\packages\logonscript\lockedreport.log



