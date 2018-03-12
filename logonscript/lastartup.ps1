"salve" | out-file C:\Packages\logonscript\allow.flag
 $buildts = [Environment]::GetEnvironmentVariable("BuildTS","machine")
 $buildts | out-file C:\packages\logonscript\buildts.txt