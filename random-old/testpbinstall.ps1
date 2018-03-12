

# test path of current windows phone builder
$servers = Get-Content ".\servers.txt";

foreach ($server in $servers)
{

$testpath=Test-Path "\\$server\c$\Program Files (x86)\Microsoft Windows Phone Builder"
Write-host  $server $testpath 
}