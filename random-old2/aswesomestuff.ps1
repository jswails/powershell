$env:PSModulePath -split ';'

Import-Module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\registrium\regscan.psm1

New-ModuleManifest

get-module -ListAvailable


gwmi -Namespace root\default sampleproductslist32 | Select-Object displayname,displayversion
$out = winmgmt /verifyrepository 
write-host $out