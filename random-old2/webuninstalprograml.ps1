Param([string]$computername,[string]$app)
#	$computername = "dd2rdtr1"
 # $app = "doPDF 7.2 printer"
$UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 
$UninstallKey32="SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"

$uarray = @()
    #Create an instance of the Registry Object and open the HKLM base key

	$type = [Microsoft.Win32.RegistryHive]::'LocalMachine'
	
    $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey($type,$computername) 
	
    #Open Uninstall key using the OpenSubKey Method

    $regkey=$reg.OpenSubKey($UninstallKey) 

    #Retrieve an array of string that contain all the subkey names

    $subkeys=$regkey.GetSubKeyNames() 
#64 bit check
	
    foreach($key in $subkeys){

        $thisKey=$UninstallKey+"\\"+$key 

        $thisSubKey=$reg.OpenSubKey($thisKey) 

		$testkey = $thisSubKey.GetValue("DisplayName")


if ($testkey -like $app) {
write-host "Found doPDF"

	$ucount ++
		$uarray += $thisSubKey.GetValue("UninstallString")
if ($uarray.length -eq 0){
write-host " No array set"
}
foreach ($unis in $uarray){
if ($unis.Trim() -match 'msiexec.exe /x{(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}}') {
Write-host "Valid uninstall string found for $ProductName..."
$NewProcess = ([WMICLASS]"\\$computername\Root\CIMV2:Win32_Process").create("$unis /qn /passive /l*v! c:\packages\testautouninstall.log")
} else {
Write-host "Invalid uninstall string. MSIEXEC cannot be used."
}

}
}
}

