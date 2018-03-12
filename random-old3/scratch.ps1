
# 'C:\Users\swa4444\Favorites\'

 #get-content something.txt | where-object {$_ -match '[\\|\s

$regex = "^\w[a-z]+\d{4}[0-9]$"

$dir = "C:\temp\sync.log"
$latest = Get-ChildItem -Path $dir | Sort-Object LastAccessTime -Descending | Select-Object -First 1
$synclog = "c:\temp\sync.log\" + $latest.name

$synclog  $regex