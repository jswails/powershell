clear-host

function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

$HotFixID = "KB981314"
  
get-Content ".\Servers.txt" | % {
    $ServerName = $_ 
    $result = Ping-Server $_
    if($result){

        $results = get-wmiobject -class "Win32_QuickFixEngineering" -namespace "root\CIMV2" -ComputerName $servername

        foreach ($objItem in $results) 
        { 
            # Do the match 
            if ($objItem.HotFixID -match $HotFixID) 
            { 
                write-host $objItem.CSName "pass" 
            } 
			else {
			if ($objItem.HotFixID -notmatch $HotFixID) 
			{
			write-host $objItem.CSName "fail"
			}
			}
        }  
}
}