#Param([string]$computername,[string]$app)
	$computername = ""
 $app = "Microsoft Filter Pack 2.0"
 get-date | out-file -Append c:\temp\$computername.csv
 "$app" |  out-file -Append c:\temp\$computername.csv
 $computername | out-file -Append c:\temp\$computername.csv
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


if ($testkey -eq "$app") {
"found app in registry uninstall" | out-file -Append c:\temp\$computername.csv

	$ucount ++
		$uarray += $thisSubKey.GetValue("UninstallString")
if ($uarray.length -eq 0){
write-host " No array set"
" No array set" | out-file -Append c:\temp\$computername.csv
}
foreach ($unis in $uarray){
 $unis | out-file -Append c:\temp\$computername.csv
if ($unis.Trim() -match 'msiexec.exe /x{(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}}') {
Write-host "Valid uninstall string found for $ProductName..."
"Valid uninstall string found for $ProductName..." | out-file -Append c:\temp\$computername.csv
$NewProcess = ([WMICLASS]"\\$computername\Root\CIMV2:Win32_Process").create("$unis /qn /passive /l*v! c:\packages\$app-uninstall.log")
" App uninstall log put in c:\packages " | out-file -Append c:\temp\$computername.csv
} else {
Write-host "Invalid uninstall string. MSIEXEC cannot be used." 
"Invalid uninstall string. MSIEXEC cannot be used."  | out-file -Append c:\temp\$computername.csv
}

}
}
}


