$appkeys32 = @("c:\progra~1\appsense\applic~1\agent\amldra~1.dll","c:\progra~1\appsense\applic~1\agent\amapphook.dll")
$badkeys32 = @("c:\progra~1\appsense\application manager\agent\amapphook.dll ","c:\progra~1\appsense\application manager\agent\amapphook.dll","c:\progra~1\appsense\application ","c:\progra~1\appsense\application","manager\agent\amapphook.dll ","manager\agent\amapphook.dll")

$appkeys64 = @("c:\progra~2\appsense\applic~1\agent\amldra~1.dll","c:\progra~2\appsense\applic~1\agent\amapphook.dll")
$badkeys64 = @("c:\progra~2\appsense\application manager\agent\amapphook.dll ","c:\progra~2\appsense\application manager\agent\amapphook.dll","c:\progra~2\appsense\application ","c:\progra~2\appsense\application","manager\agent\amapphook.dll ","manager\agent\amapphook.dll")


$arch = Get-ItemProperty "hklm:\system\currentcontrolset\control\session manager\environment" | select -expandproperty Processor_Architecture


$origKey = Get-ItemProperty "hklm:\software\microsoft\windows nt\currentversion\windows" -name AppInit_Dlls | select -expandproperty AppInit_Dlls
$splitKey = $origKey.split(",")
$currentKey = $appkeys32

write-output $origKey | out-file c:\temp\appinit.bak -append

foreach ($key in $splitKey){
if (!($badkeys32 -contains $key)){
	if (!($appkeys32 -contains $key)){
		foreach ($bkey in $badkeys32){$key = $key -replace [Regex]::Escape($bkey), ""}
		$currentKey+=$key
		}
	}
}

$setKey = $currentKey -join ','

Set-ItemProperty "hklm:\software\microsoft\windows nt\currentversion\windows" -name AppInit_Dlls -value $setKey


if($arch -eq "AMD64"){

$origKey = Get-ItemProperty "hklm:\software\wow6432node\microsoft\windows nt\currentversion\windows" -name AppInit_Dlls | select -expandproperty AppInit_Dlls
$splitKey = $origKey.split(",")
$currentKey = $appkeys64

write-output $origKey | out-file c:\temp\appinit.bak -append

foreach ($key in $splitKey){
if (!($badkeys64 -contains $key)){
	if (!($appkeys64 -contains $key)){
		foreach ($bkey in $badkeys64){$key = $key -replace [Regex]::Escape($bkey), ""}
		$currentKey+=$key
		}
	}
}

$setKey = $currentKey -join ','

Set-ItemProperty "hklm:\software\wow6432node\microsoft\windows nt\currentversion\windows" -name AppInit_Dlls -value $setKey
}