

for /f  %%i in (c:\temp\servers.txt) do (psexec.exe \\%%i gpupdate /force)
