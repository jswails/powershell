cpi "%userprofile%\favorites\*" H:\favorites
cpi "%userprofile%\desktop\*" H:\desktop
cpi "%userprofile%\My Documents\My Pictures\*" "h:\My Pictures"
cpi "%userprofile%\My Documents\My Music\*" "h:\My Music"
mkdir \\sadc1sccmp1\osd\settingsxfer\outlook_settings\$env:username
invoke-item \\sadc1sccmp1\osd\SettingsXfer\export-outlook-settings.bat



