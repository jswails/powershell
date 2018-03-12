$datetimes = Get-Date -Format "yyyyMMddhhmmss";

$env:USERNAME + "," + $datetimes 
 $appEventCategory = 1002
 # set Event log default entry type to Information
        $appEventErrorType = "Information"
        
        # standard script starting event id for this session appsense node
        $appEventID = 11002

        # Check for CE-Script event source and create if not found
        if(!(Get-Eventlog -LogName Application -Source CE-Script -ErrorAction SilentlyContinue)){New-Eventlog -LogName "Application" -Source "CE-Script" | Out-Null}

        # Make an event log entry for lock recorded
        Write-EventLog -EventId $appEventID -Category $appEventCategory -LogName Application -Source CE-Script -EntryType $appEventErrorType -Message "Lock recorded"


 