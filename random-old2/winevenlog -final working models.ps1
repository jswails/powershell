$query = @"

<QueryList>

  <Query Id="0" Path="microsoft-windows-Diagnostics-Performance/operational">

    <Select Path="microsoft-windows-Diagnostics-Performance/operational">*[System[Provider[@Name='microsoft-windows-Diagnostics-Performance']

    and (Level=3) and (EventID=101)]]

    and *[EventData[Data='name']]</Select>

  </Query>

</QueryList>

"@
Get-WinEvent -FilterXml $query 

Get-WinEvent -ListProvider * | Format-Table   
Get-WinEvent -ListProvider *performance* | Format-Table   
Get-WinEvent -ListLog Microsoft-Windows-Diagnostics-Performance/Operational
(Get-WinEvent -ListProvider Microsoft-Windows-Diagnostics-Performance).Events |            
   Format-Table id, description -AutoSize  
   (Get-WinEvent -ListProvider Microsoft-Windows-Diagnostics-Performance).Events |
   Where-Object {$_.Id -eq 101}

   (Get-WinEvent -ListProvider Microsoft-Windows-Diagnostics-Performance).Events |            
   Where-Object {$_.template -like "*pcoip*"}    

   $event =  Get-WinEvent  -FilterHashtable @{Logname='Microsoft-Windows-Diagnostics-Performance/Operational';Id=101}
   $Event | Format-List *
   $Event.Properties
   $eventXML = [xml]$Event.ToXml()
   $eventXML.Event.EventData.Data
   $eventXML.Event.EventData.Data[0].name
    $eventXML.Event.EventData.Data[0].'#text'

    # Grab the events from a DC            
$Events = Get-WinEvent -computername "vw7lr01" -FilterHashtable @{Logname='Microsoft-Windows-Diagnostics-Performance/Operational';Id=101}            
            
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
$Events | Select-Object * -first 20 -ExcludeProperty message| Out-GridView

$events | export-csv 
