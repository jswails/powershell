mkdir \\sadc1aspsd1\logs\$env:computername
cpi c:\temp\logexport\*.zip \\sadc1aspsd1\logs\$env:computername

schtasks.exe /create /RU sai\app_appenseinstaller /RP aprl#244 /TN logexporter /XML c:\scripts\logexporter.xml

ri c:\temp\logbackup -include *.zip

gci c:\temp\logbackup -include *.zip | remove-item