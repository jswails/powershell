cls

clear-host

function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

  
get-Content ".\Servers.txt" | % {

    $Server = $_

    $session = new-pssession -ComputerName $Server
    $results = Invoke-command -session $session -scriptblock { netsh interface isatap show state }  | out-string

    $parsed = $results.remove(0,25)
    "{0} {1}" -f $Server, $parsed
    
    $results = ""
    $parsed  = ""
    Remove-PSSession $Server
    $Server = ""
}
