

$datetime = (Get-Date).AddDays(-1) 

get-eventlog -logname system -after ([datetime]'12/01/2013 10:00:00 am') | export-csv c:\temp\logbackup\system.csv -notypeinformation

get-eventlog -logname system  -computer E1TKG2M1 -after ($datetime) | where-object {$_.EventID -eq "46"} | Select-Object -first 10

| where-object {$_.EventID -eq "46"}

[globalization.cultureinfo]::GetCultures("allCultures") | where {$_.name -match '^fr'}
