# remove empty lines from a file
 (gc c:\temp\1119.txt) | ? {$_.trim() -ne "" } | set-content c:\scripts\1119.txt