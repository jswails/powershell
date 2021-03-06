# Gets time stamps for all computers in the domain that have NOT logged in since after specified date  
$time=Read-host "Enter a date in format mm/dd/yyyy" 
 # Get all AD computers
  Get-ADComputer -Filter * |  
  # Make sure to get the lastLogonTimestamp property 
  Get-ADObject -Properties lastlogontimestamp |  
   # lastLogonTimestamp - date specified is less than zero, outputs it to a CSV file is working directory
   where {(([DateTime]::FromFileTime($_.lastlogontimestamp) - ([system.datetime]$time)).totaldays) -lt 0 } |  
    # Output hostname and lastLogonTimestamp into CSV 
    select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | export-csv c:\temp1\managedOU-6months.csv -notypeinformation 
