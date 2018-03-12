

rem fix sccm client

rem first uninstall it

\\redmond\netlogon\sms\ccmclean.exe



del /f /q c:\windows\ccmsetup\
if not exist c:\windows\ccmsetup mkdir c:\windows\ccmsetup
xcopy \\moeprosccmapp01\SMS_GKC\Client\ccmsetup.exe c:\windows\ccmsetup

c:\windows\ccmsetup\ccmsetup.exe SMSSITECODE=GKC SMSSLP=MOEPROSCCMAPP01 MP=MOEPROSCCMAPP01 FSP=MOEPROSCCMDST03

