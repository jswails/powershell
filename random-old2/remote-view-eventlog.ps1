﻿Param([string]$mach)

get-eventlog -logname system -after ([datetime]'12/01/2013 10:00:00 am') | export-csv c:\temp\logbackup\system.csv -notypeinformation

get-eventlog -logname system  -computer machinename -after ([datetime]'01/01/2014 11:00:00 am')

 get-eventlog -logname System -EntryType Error -computer $mach | export-csv e:\wamp\eventlog\$mach.csv -notypeinformation
  get-eventlog -logname Application -EntryType Error -computer $mach | export-csv e:\wamp\eventlog\$mach.csv -notypeinformation
   get-eventlog -logname security -EntryType Error -Computer $mach | export-csv e:\wamp\eventlog\$mach.csv -notypeinformation

    get-eventlog -logname System -instanceID 3221235481 -Source "DCOM"

    get-eventlog -logname "Windows PowerShell" -message "*failed*"

     get-eventlog -log application -source outlook | where {$_.eventID -eq 34}

     get-eventlog -log system -username NT* | group-object -property username -noelement | format-table Count, Name -auto

     PS C:\> $May31 = get-date 5/31/08
PS C:\>$July1 = get-date 7/01/08
PS C:\>get-eventlog -log "Windows PowerShell" -entrytype Error -after $may31 -before $july1

# write events
#local
write-eventlog -logname Application -source MyApp -eventID 3001 -entrytype Information -message "MyApp added a user-requested feature to the display." -category 1 -rawdata 10,20

#remote
 write-eventlog -computername Server01 -logname Application -source MyApp -eventID 3001 -message "MyApp added a user-requested feature to the display."

Get-EventLog -log AppSense -InstanceId 9104 | Select-Object  eventid,machinename,message,timegenerated | export-csv C:\temp\appsensepm-9104.csv -NoTypeInformation

$mach = $env:COMPUTERNAME

 Get-EventLog -log AppSense -InstanceId 9104,9105 -ComputerName $mach | Select-Object  eventid,machinename,timegenerated | export-csv C:\temp\9104\$mach.csv -NoTypeInformation
  Get-EventLog -log AppSense -InstanceId 9120 -ComputerName $mach | Select-Object  eventid,machinename,timegenerated,message | export-csv C:\temp\9120\$mach.csv -NoTypeInformation
