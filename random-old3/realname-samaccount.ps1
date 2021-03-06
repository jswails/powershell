cls
import-module ActiveDirectory
$source = Get-Content c:\scripts\1119.txt

foreach ($user_long in $source)
{
	[string]$x = Get-ADUser -Filter {CN -eq $user_long} -Properties * | select SamAccountName	
    if ($x -eq $null -or $x -eq "")
    {
        write-host -foregroundcolor RED "$($user_long)"
    }
    else
    {
    	$z = $x.Split("=")
        $name_short = $z[1].Substring(0,7)
       # write-host "$($user_long) ++ $($name_short)" | out-file c:\scripts\3112014.txt
        write-host "$($name_short)" 
    }
} #end foreach get all users