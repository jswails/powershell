Param([string]$computername,[string]$app)
#Created by Russell Watterson 9/3/14
#Current Java 6.45 7.51
#updated for website removal John Swails 9.8.14
#	$computername = "dg8xbpm1"
 # $app = "Microsoft .NET Framework 4 Client Profile"
 get-date | out-file -Append e:\wamp\www\uninstall\$computername.csv
# $app |  out-file -Append e:\wamp\www\uninstall\$computername.csv
# $computername | out-file -Append e:\wamp\www\uninstall\$computername.csv
$UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 
$UninstallKey32="SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
$app | out-file -Append e:\wamp\www\uninstall\$computername.csv
$uarray = @()
$reg64 = $FALSE
$reg32 = $FALSE

    #Create an instance of the Registry Object and open the HKLM base key

	$type = [Microsoft.Win32.RegistryHive]::'LocalMachine'
	
    $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey($type,$computername) 
	
    #Open Uninstall key using the OpenSubKey Method

    $regkey=$reg.OpenSubKey($UninstallKey) 

    #Retrieve an array of string that contain all the subkey names

    $subkeys=$regkey.GetSubKeyNames() 


	#64 bit check
	echo 'Reg64'
    foreach($key in $subkeys){

        $thisKey=$UninstallKey+"\\"+$key 

        $thisSubKey=$reg.OpenSubKey($thisKey) 

		$testkey = $thisSubKey.GetValue("DisplayName")
		
		if ($testkey -like $app){
"found 64 bit app" | out-file -Append e:\wamp\www\uninstall\$computername.csv
		$ucount ++
		$uarray += $thisSubKey.GetValue("UninstallString")}
		}
  
	
	#reopen with 32 bit key
	
	$regkey=$reg.OpenSubKey($UninstallKey32) 
    $subkeys=$regkey.GetSubKeyNames() 

	#32 bit check
	echo 'Reg32'
    foreach($key in $subkeys){

        $thisKey=$UninstallKey32+"\\"+$key 

        $thisSubKey=$reg.OpenSubKey($thisKey) 
		
		$testkey = $thisSubKey.GetValue("DisplayName")
		
		#ignore non java keys
		if ($testkey -like $app){
		
		"found 32 bit" | out-file -Append e:\wamp\www\uninstall\$computername.csv
		$ucount ++
		$uarray += $thisSubKey.GetValue("UninstallString")}
		}
    
	foreach ($unis in $uarray){
"starting unis" | out-file -Append e:\wamp\www\uninstall\$computername.csv
$unis | out-file -Append e:\wamp\www\uninstall\$computername.csv
if ($unis.Trim() -match 'msiexec.exe /x{(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}}') {
Write-host "Valid uninstall string found for $app..."
"Valid uninstall string found for $app..." | out-file -Append e:\wamp\www\uninstall\$computername.csv
$unis = "MsiExec.exe /X{F5B09CFD-F0B2-36AF-8DF4-1DF6B63FC7B4}"
$NewProcess = ([WMICLASS]"\\$computername\Root\CIMV2:Win32_Process").create("$unis /qn /passive /l*v! c:\packages\$app-uninstall.log")
" App uninstall log put in c:\packages " | out-file -Append e:\wamp\www\uninstall\$computername.csv
} else {
Write-host "Invalid uninstall string for $unis. MSIEXEC cannot be used." 
"Invalid uninstall string for $unis. MSIEXEC cannot be used."  | out-file -Append e:\wamp\www\uninstall\$computername.csv
}

}



