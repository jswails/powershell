
# looks in folder and grabs everything that has sai in it and puts in txt file
# afterwards i clean it up and remove all known admin groups that leaves users

# run this twice a week on mon and thurs dump all the files into separate folders to analysis

# (gci c:\scripts\audit\windxpsystemsou).count

#############
# win7machines-appsense
#############
ri c:\scripts\audit\win7machines-appsense\*
c:\scripts\audit\adminscanscripts\win7machines-appsense.ps1 
cd c:\scripts\audit\win7machines-appsense
findstr /s /i sai *.* | out-file c:\scripts\audit\adminoutput\win7machines-appsense-admins.txt
#findstr /v /c:domain  c:\scripts\audit\adminoutput\win7machines-appsense-admins.txt | findstr /v /c:workstation | findstr /v /c:help |out-file c:\scripts\audit\adminoutput\win7machines-appsense-admins-Final.txt

##############
# win7systemsOU
##############
ri c:\scripts\audit\win7systemsOU\*
c:\scripts\audit\adminscanscripts\win7systemsOU.ps1 
cd c:\scripts\audit\win7systemsOU
findstr /s /i sai *.* | out-file c:\scripts\audit\adminoutput\win7systemsOU-admins.txt

##############
# win7systemstestOU
##############
ri c:\scripts\audit\win7systemstestOU\*
c:\scripts\audit\adminscanscripts\win7systemstestOU.ps1 
cd c:\scripts\audit\win7systemstestOU
findstr /s /i sai *.* | out-file c:\scripts\audit\adminoutput\win7systemstestOU-admins.txt

#############
# win7vdiou
#############
ri c:\scripts\audit\win7vdiou\*
c:\scripts\audit\adminscanscripts\win7vdiou.ps1 
cd c:\scripts\audit\win7vdiou
findstr /s /i sai *.* | out-file c:\scripts\audit\adminoutput\win7vdiou-admins.txt

############
# winxpsystemsou
############
ri c:\scripts\audit\winxpsystemsou\*
c:\scripts\audit\adminscanscripts\winxpsystemsou.ps1 
cd c:\scripts\audit\winxpsystemsou
findstr /s /i sai *.* | out-file c:\scripts\audit\adminoutput\winxpsystemsou-admins.txt
#findstr /v /c:"domain admins"  c:\scripts\audit\adminoutput\winxpsystemsou-admins.txt | findstr /v /c:"workstationinstaller" | findstr /v /c:"helpdeskremotetools" | findstr /v /c:"workstation administrators" |out-file c:\scripts\audit\adminoutput\winxpsystemsou-admins.txt-Final.txt

#############
# winxpvdiou
#############
ri c:\scripts\audit\winxpvdiou\*
c:\scripts\audit\adminscanscripts\winxpvdiou.ps1 
cd c:\scripts\audit\winxpvdiou
findstr /s /i sai *.* | out-file c:\scripts\audit\adminoutput\winxpvdiou-admins.txt

############
