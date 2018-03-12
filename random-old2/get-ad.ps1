Get-ADComputer -Filter { OperatingSystem -NotLike '*Windows Server*' } -Properties OperatingSystem |  Select Name, OperatingSystem | Format-Table -AutoSize
