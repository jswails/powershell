$getnamefile = "c:\packages\logonscript\user.txt"
$tada = get-content $getnamefile
$username = $tada
$strComputer = $env:COMPUTERNAME
$datetime = Get-Date -Format "yyyyMMddHHmm"; 
$log = "c:\temp\adminscriptdebug.txt"
$dir = "\\SADC1CMADMP1\LocalAdmin\admin-sudofile.33"
$latest = Get-ChildItem -Path $dir 
$search = $env:COMPUTERNAME + ":" + $username
$search
$sel =  Select-String -Path $latest -Pattern "$search" 
$sel
$testpath = test-path $dir
if ($testpath -eq $FALSE) {
"testpath returned $FALSE; exit script" | out-file -append $log
exit}
$domain = "SAI"

$datetime | out-file -append $log
$username " being removed from local admins"| out-file -append $log
$computer = [ADSI]("WinNT://" + $strComputer + ",computer")
$computer.name
$Group = $computer.psbase.children.find("administrators")
$group.name

$Group.Remove("WinNT://" + $domain + "/" + $username)

