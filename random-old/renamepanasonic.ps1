$tsenv = new-object -comobject microsoft.sms.tsenvironment

$getbios = gwmi win32_bios
$serial = $getbios.serialnumber
$serial = $serial.substring(3)
$name = "T" + $serial

$tsenv.Value("OSDComputername") = $name
