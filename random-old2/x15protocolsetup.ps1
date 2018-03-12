

$shell = New-Object -ComObject WScript.Shell
$sc = $shell.CreateShortCut("$env:USERPROFILE\Desktop\CdromPermissionsTool.lnk")
$sc.TargetPath = "c:\temp\x15protocol\x15protocol.bat"
$sc.IconLocation = "%SystemRoot%\system32\SHELL32.dll,0"
$sc.Description = "Enable CD/DVD Permissions"
$sc.Save()