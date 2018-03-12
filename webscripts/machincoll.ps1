Param([string]$checkbox)
$SiteCode="C05"
   $SCCMServer="sadc1cm12p1"
$checkbox | export-csv -path e:\wamp\www\cm12\2.txt
# Get a list of collections and find the object to build the collection list.
$Collection = Get-WmiObject -ComputerName $SCCMServer  -Namespace `
"root\sms\site_$SiteCode" -Class 'SMS_Collection'
$MyCollection = $Collection | Where-Object { $_.Name -like $checkbox }
# Grab the Resource ID of the collection
$MyCollectionMembers = Get-WmiObject  -ComputerName $SCCMServer -Namespace `
"root\sms\site_$SiteCode"  -Query "select * from SMS_CM_RES_COLL_$($MyCollection.CollectionID)"
#Echo member of the collections to screen
Foreach ($member in $MyCollectionMembers) {
   $oldErrCount = $error.Count
  $Name = $member.Name.ToString()
$Name | export-csv -notypeinformation -path e:\wamp\www\cm12\1.csv
  }