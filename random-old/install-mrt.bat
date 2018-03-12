@echo off
Mrt.exe /q
If errorlevel 13 goto error13
If errorlevel 12 goto error12
Goto end

:error13
Ismif32.exe –f MIFFILE –p MIFNAME –d ”text about error 13”
Goto end

:error12
Ismif32.exe –f MIFFILE –p MIFNAME –d “text about error 12”
Goto end

:end
