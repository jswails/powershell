Set WshShell = CreateObject("WScript.Shell") 

WshShell.Run chr(34) & "C:\scripts\view.bat" & Chr(34), 0

Set WshShell = Nothing
