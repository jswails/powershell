$compname = Param([string]$computer)
#$compname = ""
mmc "c:\windows\system32\compmgmt.msc" /computer:\\$compname
