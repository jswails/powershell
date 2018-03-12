# install vmtools with complete opton

# change pc name from test-pc to vpwr-vmbase

$computer= $env:COMPUTERNAME
$NewName="vpwr-vmbase"
$objWMI = Get-WmiObject -Class Win32_Computersystem
$objWMI.rename($newName)
Restart-Computer


# set stateautouser pw to PW#VMADMIN1 

net user stateautouser "PW#VMADMIN1"


# enable local admin account set pw  to PW#XP_VIEW1

net user administrator /active:yes
net user administrator "PW#XP_VIEW1"

#join to domain

add-computer -domainname corp.stateauto.com -cred


#copy vmware and sccm client install stuff to c:\packages

#copy background to c:\windows\web\wallpaper

#install sccm client
# apply updates task sequence part
# add vm to vmbuild/windows 7 64bit vm base apps collection in sccm to advertise new task sequence to install base

# workstation admins works now if logged on as a win7 user via gpo

#removed from domain
#restarted vm
restart-computer

remove-item -Path "Hklm:\software\microsoft\windows nt\currentversion\winlogon\legalnoticecaption" -recurse -Force
remove-item -Path "Hklm:\software\microsoft\windows nt\currentversion\winlogon\legalnoticetext" -recurse -Force

# stop sep mgmt service
"C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\smc -stop"

remove-item -Path "c:\program files(x86)\common files\symantec shared\hwid\sephwid.xml"
remove-item -Path "c:\program files(x86)\common files\symantec shared\hwid\sephwid.xml"
remove-item -Path "HKLM:\SOFTWARE\Symantec\Symantec Endpoint Protection\SMC\SYLINK\SyLink\HardwareID " -recurse -Force

set-service smc -startuptype disabled 
set-service ccmexec -startuptype disabled

# run ccmdelcert

run w7vmtweaks.bat
reboot

install view agent
restart vm
run pcoip tuner set to extremely broad

clean up c:\packages
pcoiptuner
w7vmtweaks
ccmdelcert
agent installer

hide c:\packages folder

removed vm from ad
removed vm from sccm

shutdown vm snapshot and clone to template



