$user_long = Param([string]$fullname)

foreach ($user_long in $col)
		{ # Need to get user ID from AD based on user real/display name
            If ($user_long -ne "")
            {
				[string]$x = Get-ADUser -Filter {CN -eq $user_long} -Properties * | select SamAccountName        
    		    if ($x -eq $null -or $x -eq "")
    		    {
    		        $NameResults += "$user_long not found in Active Directory"
    		    }
    		    else
    		    {
    		        $z = $x.Split("=")
    		        $name_short = $z[1].Substring(0,7)
    		    
    		    }