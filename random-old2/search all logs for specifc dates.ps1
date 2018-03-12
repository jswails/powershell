$ComputerName = "E6Z2Z7V1"
 
## Specify the timeframe you'd like to search between
$StartTimestamp = '6-10-2015 04:00:00'
$EndTimeStamp = '6-10-2015 04:04:00'
 
## Specify in a comma-delimited format which event logs to skip (if any)
$SkipEventLog = 'Microsoft-Windows-TaskScheduler/Operational'
 
## The output file path of the text file that contains all matching events
$OutputFilePath = 'C:\E6Z2Z7V1-eventlogs.txt'
 
## Create the Where filter ahead of time to only get events within the timeframe
$filter = {($_.TimeCreated -ge $StartTimestamp) -and ($_.TimeCreated -le $EndTimeStamp)}
 
## Only get events from included event logs
if ($SkipEventLog) {
    $op_logs = Get-WinEvent -ListLog * -ComputerName $ComputerName | Where {$_.RecordCount -and !($SkipEventLog -contains $_.LogName)}
} else {
    $op_logs = Get-WinEvent -ListLog * -ComputerName $ComputerName | Where {$_.RecordCount}
}
 
## Process each event log and write each event to a text file
$i = 0
foreach ($op_log in $op_logs) {
    Write-Progress -Activity "Processing event logs" -status "Processing $($op_log.LogName) event log" -percentComplete ($i / $op_logs.count*100)
    Get-WinEvent $op_log.LogName -ComputerName $ComputerName | Where $filter |
        Select @{n='Time';e={$_.TimeCreated}},
            @{n='Source';e={$_.ProviderName}},
            @{n='EventId';e={$_.Id}},
            @{n='Message';e={$_.Message}},
            @{n='EventLog';e={$_.LogName}} | Out-File -FilePath $OutputFilePath -Append -Force
$i++
}
