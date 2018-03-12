# capture the  default printer from the xp migration script and place that on the users H drive in a file

$getprinterfile = "h:\defaultprinter.txt"
$defaultprinter = get-content $getprinterfile

# on win7 machine run the cscript.exe prnmngr.vbs 
# set printer connection
cscript.exe C:\windows\system32\Printing_Admin_Scripts\en-US\prnmngr.vbs -ac -p $defaultprinter
# set it as default printer
cscript.exe C:\windows\system32\Printing_Admin_Scripts\en-US\prnmngr.vbs -t -p $defaultprinter
