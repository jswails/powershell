$compname = Read-host " Enter Machines Name"
#$compname = "dg8xbpm1"
mmc "c:\windows\system32\compmgmt.msc" /computer:\\$compname