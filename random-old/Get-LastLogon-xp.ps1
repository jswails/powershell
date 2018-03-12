$computer = $env:COMPUTERNAME
$Win32OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer

$Build = $Win32OS.BuildNumber



If ($Build -le 6000)

{


$SysDrv = $Win32OS.SystemDrive

$SysDrv = $SysDrv.Replace(":","$")

$ProfDrv = "\\" + $Computer + "\" + $SysDrv

$ProfLoc = Join-Path -Path $ProfDrv -ChildPath "Documents and Settings"

$Profiles = Get-ChildItem -Path $ProfLoc

$LastProf = $Profiles | ForEach-Object -Process {$_.GetFiles("ntuser.dat.LOG")}

$LastProf = $LastProf | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1

$UserName = $LastProf.DirectoryName.Replace("$ProfLoc","").Trim("\").ToUpper()

$Time = $LastProf.LastAccessTime

$Sddl = $LastProf.GetAccessControl().Sddl

$Sddl = $Sddl.split("(") | Select-String -Pattern "[0-9]\)$" | Select-Object -First 1

$Sddl = $Sddl.ToString().Split(";")[5].Trim(")")

$TranSID = New-Object System.Security.Principal.NTAccount($UserName)

$UserSID = $TranSID.Translate([System.Security.Principal.SecurityIdentifier])

If ($Sddl -eq $UserSID)

{

$Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"Users",$Computer)

$Loaded = $Reg.GetSubKeyNames() -contains $UserSID.Value

$UserSID = New-Object System.Security.Principal.SecurityIdentifier($UserSID)

$User = $UserSID.Translate([System.Security.Principal.NTAccount])

}#End If ($Sddl -eq $UserSID)

Else

{

$User = $UserName

$Loaded = "Unknown"

}#End Else

#Creating the PSObject UserProf

$UserProf = New-Object PSObject -Property @{

Computer=$Computer

User=$User

Time=$Time

CurrentlyLoggedOn=$Loaded

}

$UserProf = $UserProf | Select-Object Computer, User, Time, CurrentlyLoggedOn

$UserProf

}
$timenow = get-date
$length = $timenow - $time

$disp = ($computer, $user, $timenow, $time, $length) 
$disp | Out-File -Append c:\temp\lastuser.txt