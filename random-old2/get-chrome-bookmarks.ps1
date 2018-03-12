function add-favourite{ 
[CmdletBinding()] 
param(
[parameter(Mandatory=$true)]
[string]$name,

[ValidateNotNullOrEmpty()]
[string]$url
)
BEGIN{}#begin 
PROCESS{

$so = New-Object -ComObject Shell.Application
$ff = $so.Namespace(0x6)
$path = Join-Path -Path $($ff.Self.Path) -ChildPath "$name.url"

$shell = New-Object -ComObject WScript.Shell
$sc = $shell.CreateShortCut($path)
$sc.TargetPath = $url
$sc.Save()

}#process 
END{}#end

<# 
.SYNOPSIS
Add a new favourite

.DESCRIPTION
Add a new favourite


.EXAMPLE
add-favourite -name mytest -url "http://www.bing.com"
#>
}
if(test-path("$env:localappdata\Google\Chrome\User Data\Default\Bookmarks")){
$File = "$env:localappdata\Google\Chrome\User Data\Default\Bookmarks"
} else {
if(test-path("$env:localappdata\Google\Chrome\User Data\Profile 2\Bookmarks")){
$File = "$env:localappdata\Google\Chrome\User Data\Profile 2\Bookmarks"
}
}
$data = Get-content $file | out-string | ConvertFrom-Json
$bob =  $data.roots.bookmark_bar.children | select Name,url  #| export-csv c:\temp1\chromebookmarks.csv -NoTypeInformation

foreach($link in $bob)
{

$linkname = $link.name | Out-String 

$linkurl = $bob.url | Out-String
add-favourite -name $linkname -url $linkurl
write-host add-favourite -name $linkname -url $linkurl
}
