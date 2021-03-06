Get-Content C:\scripts\cleanupAD\win7systemsou.txt | % { Get-ADComputer -Filter { Name -eq $_ } } | Remove-ADComputer -WhatIf

# this removes all reference to domain
 findstr /v /c:domain  win7machines-appsense-admins.txt |out-file c:\temp1\win7machines-appsense-admins-1.txt
 
 # this removes all reference to workstation
findstr /v /c:workstation  win7machines-appsense-admins-1.txt |out-file c:\temp1\win7machines-appsense-admins-2.txt
# this removes helpdesk references
findstr /v /c:help  win7machines-appsense-admins-2.txt |out-file c:\temp1\win7machines-appsense-admins-3.txt

 findstr /v /c:domain  win7machines-appsense-admins.txt | findstr /v /c:workstation | findstr /v /c:help |out-file c:\temp1\win7machines-appsense-admins-3.txt
 
 # remove empty lines from a file
 (gc c:\temp\1119.txt) | ? {$_.trim() -ne "" } | set-content c:\scripts\1119.txt

### trap errors
   Trap {
                #define a trap to handle any WMI errors
                Write-Warning ("There was a problem with {0}" -f $computer.toUpper())
                Write-Warning $_.Exception.GetType().FullName
                Write-Warning $_.Exception.message
                Continue
                }
                
                
                
 ##### count  files in folder
 
 (gci c:\scripts\audit\win7).count
 
findstr " *resources*" < win7machinesappsenseadminerrorlog.txt 
gci .\* -include *.txt | select-string -pattern "path" | out-file c:\scripts\audit\pathnotfounderror.txt
(gci .\* -include *.txt | select-string -pattern "path").count

measure-command {robocopy c:\temp\test h:\}

fsutil file createnew file.out 12000



