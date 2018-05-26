  Param([string]$machine)
  $SiteCode="C05"
   $SCCMServer="server"
 
 
# find and delete the computer from AD
$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$root = $dom.GetDirectoryEntry()
$search = [System.DirectoryServices.DirectorySearcher]$root
$search.filter = "(&(objectclass=computer)(name=$machine))"
$search.findall() | %{$_.GetDirectoryEntry() } | %{$_.DeleteObject(0)}
 
 
  # find and delete from SCCM
$comp = get-wmiobject -query "select * from SMS_R_SYSTEM WHERE Name='$machine'" -computername $sccmServer -namespace "ROOT\SMS\site_$SiteCode"
$comp.psbase.delete()
 Removed $machine | out-file e:\wamp\delete\$machine.txt
