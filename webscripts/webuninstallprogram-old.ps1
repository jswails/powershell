Param([string]$computername,[string]$app)
#Created by Russell Watterson 9/3/14
#Current Java 6.45 7.51
#updated for website removal John Swails 9.8.14
#	$computername = "dd2rdtr1"
 # $app = "doPDF 7.2 printer"
 get-date | out-file -Append e:\wamp\www\uninstall\$computername.csv
# $app |  out-file -Append e:\wamp\www\uninstall\$computername.csv
# $computername | out-file -Append e:\wamp\www\uninstall\$computername.csv
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

"$app" | out-file -Append e:\wamp\www\uninstall\$computername.csv

if ("$testkey" -ieq "$app") {
    if ($testkey -like '*Appsense*') {
    "Appsense is not to be uninstalled using this page." | out-file -Append e:\wamp\www\uninstall\$computername.csv
    exit}
      if ($testkey -like '*Symantec*') {
    "Symantec is not to be uninstalled using this page." | out-file -Append e:\wamp\www\uninstall\$computername.csv
    exit}
"found $app app in registry uninstall" | out-file -Append e:\wamp\www\uninstall\$computername.csv

	$ucount ++
		$uarray += $thisSubKey.GetValue("UninstallString")
if ($uarray.length -eq 0){
write-host " No array set"
" No array set" | out-file -Append e:\wamp\www\uninstall\$computername.csv
}
foreach ($unis in $uarray){

if ($unis.Trim() -match 'msiexec.exe /x{(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}}') {
Write-host "Valid uninstall string found for $unis..."
"Valid uninstall string found for $unis..." | out-file -Append e:\wamp\www\uninstall\$computername.csv
$NewProcess = ([WMICLASS]"\\$computername\Root\CIMV2:Win32_Process").create("$unis /qn /passive /l*v! c:\packages\$unis-uninstall.log")
" App uninstall log put in c:\packages " | out-file -Append e:\wamp\www\uninstall\$computername.csv
} else {
Write-host "Invalid uninstall string for $unis. MSIEXEC cannot be used." 
"Invalid uninstall string for $unis. MSIEXEC cannot be used."  | out-file -Append e:\wamp\www\uninstall\$computername.csv
}

}
}
}

