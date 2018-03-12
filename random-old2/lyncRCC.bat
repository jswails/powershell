

reg add HKCU\Software\Policies\Microsoft\Communicator /v TelephonyMode /t REG_DWORD /d 2 /f
reg add HKCU\Software\Policies\Microsoft\Communicator /v DisablePC2PCAUDIO /t REG_DWORD /d 0 /f
reg add HKCU\Software\Policies\Microsoft\Communicator /v EnablePhoneControl /t REG_DWORD /d 1 /f

reg add HKLM\Software\Policies\Microsoft\Communicator /v TelephonyMode /t REG_DWORD /d 2 /f
reg add HKLM\Software\Policies\Microsoft\Communicator /v DisablePC2PCAUDIO /t REG_DWORD /d 0 /f
reg add HKLM\Software\Policies\Microsoft\Communicator /v EnablePhoneControl /t REG_DWORD /d 1 /f