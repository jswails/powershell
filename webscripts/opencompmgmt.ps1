$compname = Param([string]$computer)
#$compname = "dg8xbpm1"
mmc "c:\windows\system32\compmgmt.msc" /computer:\\$compname