$compName = Read-Host " Enter computername "

cpi c:\temp\symantec\sylinkdrop.exe \\$compname\c$\windows\Temp1\
cpi c:\temp\symantec\n-sylink.xml \\$compname\c$\windows\temp1\

psexec \\$compname c:\windows\temp1\sylinkdrop.exe -silent -p 5Mn3!yaTC c:\windows\temp1\n-sylink.xml


write-host $lastexitcode

