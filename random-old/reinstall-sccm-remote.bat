

rem fix sccm client

rem first uninstall it

psexec \\%1 -c \\redmond\netlogon\sms\ccmclean.exe /q



del /f /q \\%1\c$\windows\ccmsetup\
if not exist \\%1\c$\windows\ccmsetup mkdir \\%1\c$\windows\ccmsetup
xcopy \\moeprosccmapp01\SMS_GKC\Client\ccmsetup.exe \\%1\c$\windows\ccmsetup

rem c:\windows\ccmsetup\ccmsetup.exe SMSSITECODE=GKC SMSSLP=MOEPROSCCMAPP01 MP=MOEPROSCCMAPP01 FSP=MOEPROSCCMDST03

