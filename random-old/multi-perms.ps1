get-Content ".\userdirectory.txt" | % {
    $userName = $_ 
  
    h:\powershell\get-perms.ps1 \\sacolfs5\$username | export-csv c:\temp\$username-permsaudit.csv -notypeinformation
      
  
}