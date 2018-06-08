


 #check to see if user is in local admin group
 $u = "domain\" + "$env:USERNAME" 
 $n = net localgroup administrators | Where {$_ -like $u}

if ($n -eq $null){

 write-host -foregroundcolor Red "User is not explicitely in the Local Admin Group but this does not mean that their AD group membership isnt allowing them Local Admin rights." 
 write-host -foregroundcolor White " Attempting to launch regedit to test admin rights...."
 regedit 
 write-host -foregroundcolor Yellow " If regedit appeared then the user has Local Admin rights inherited otherwise they do not."
 }
 else
 {
  write-host -foregroundcolor Green " User is explicitely in the Local Admin Group" 

  }




