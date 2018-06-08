 $obj = "" | Select ComputerName,OldPageFile,OldInitSize,OldMaxSize,Result
 $obj.ComputerName = $srv

 $computername  = ""
 $pagefiledata = gwmi -ComputerName $serv -Class Win32_PageFileSetting

 need event id 46
 $computername  = ""
 $Events = Get-WinEvent -computer $computername -FilterHashtable @{Logname='System';Id=46}   
# Parse out the event message data            
ForEach ($Event in $Events) {            
    # Convert the event to XML            
    $eventXML = [xml]$Event.ToXml()            
    # Iterate through each one of the XML message properties            
    For ($i=0; $i -lt $eventXML.Event.EventData.Data.Count; $i++) {            
        # Append these as object properties            
        Add-Member -InputObject $Event -MemberType NoteProperty -Force -Name  $eventXML.Event.EventData.Data[$i].name -Value $eventXML.Event.EventData.Data[$i].'#text'            
    }            
} 
$uno = $Events | Select-Object Providername,Timecreated -first 1
