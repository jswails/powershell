#1.	Create the user group so that visibility of all of those who have this special perms is easily visible at a glance and easy to separate script wise.
#2.	Have their machine also be part of the group or a machines group so that we can also track all machines that have admin access and the script will  check that as well.
#3.	The final check that keeps it so that users in the User group don’t just get access to any machine they logon and also to make this not something you can just do on the fly as I want to keep the number of users down from the current 500+ who are local admins. Create something similar to unix sudoers file and put in a matching pair of username:machinename and the script checks to make sure that the logon user and the machine name match so that we don’t just let these people have mass machine access.
#4.	There is already mass machine access in being in the workstation administrators group.

# need to have check for domain in appsense above this script and to run only if domain is found like that is used in vpn script. if not on domain dont run.

$dir = "\\sadc1sccmp1\osd\LocalAdmin\admin-sudofile.33"
$latest = Get-ChildItem -Path $dir 
$search = $env:USERNAME + ":" + $env:COMPUTERNAME 
$search
$sel =  Select-String -Path $latest -Pattern "$search" 
$sel 

 if ($sel -eq $null){
 write-host "user not allowed"

 #check to see if user is part of local admin group. if it is remove it.
 $u = "$env:USERNAME"; net localgroup administrators | Where {$_ -match $u}

if ($u -eq $null){
 write-host "user not there lets exit"


 }
 else
 {
  write-host " user needs to be removed" 
   #check to see if user is part of local admin group. if it is remove it.

$strComputer = $env:COMPUTERNAME
$domain = "SAI"
$username = $env:USERNAME
$computer = [ADSI]("WinNT://" + $strComputer + ",computer")
$computer.name
$Group = $computer.psbase.children.find("administrators")
$group.name

$Group.Remove("WinNT://" + $domain + "/" + $username)

   }


 }
 else
 {
  write-host " user allowed" 

  
$strComputer = $env:COMPUTERNAME
$domain = "SAI"
$username = $env:USERNAME
$computer = [ADSI]("WinNT://" + $strComputer + ",computer")
$computer.name
$Group = $computer.psbase.children.find("administrators")
$group.name

$Group.Add("Winnt://" + $domain + "/" + $username)


  }




