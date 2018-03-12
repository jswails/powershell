#Created by Russell Watterson 9/3/14
#Current Java 6.45 7.51

$pclist =  Get-Content c:\temp1\Javalist.txt

foreach ($computername in $pclist){
echo $computername
if (Test-Connection -Computername $computername -Quiet){

#-----------------------------------------------------------------

$uarray = @()
$current664 = $FALSE
$current632 = $FALSE
$current764 = $FALSE
$current732 = $FALSE

$UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 
$UninstallKey32="SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall"

#-----------------------------------------------------------------
	
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
		#ignore non java keys
		if ($testkey -like '*Java*'){
		
		#test for current java versions
		if ($testkey -like '*6 Update 45*'){
		$current664 = $TRUE}
		elseif ($testkey -like '*7 Update 51*'){
		$current764 = $TRUE}
		
		#adds non current java to uninstall list
		else{
		$ucount ++
		$uarray += $thisSubKey.GetValue("UninstallString")}
		}
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
		if ($testkey -like '*Java*'){
		
		#test for current java versions
		if ($testkey -like '*6 Update 45*'){
		$current632 = $TRUE}
		elseif ($testkey -like '*7 Update 51*'){
		$current732 = $TRUE}
		
		#adds non current java to uninstall list
		else{
		$ucount ++
		$uarray += $thisSubKey.GetValue("UninstallString")}
		}
    }

	#Outputs to file if java needs update on current machine
	if (!($current764 -and $current732)){
	write-output "$computername" | Out-File c:\temp1\Java7update.txt -Append}
	if (!($current664 -and $current632)){
	write-output "$computername" | Out-File c:\temp1\Java6update.txt -Append}

	# calls uninstall through msiexec on the remote machine
	if (($current764 -and $current732) -and ($current664 -and $current632)){
	echo 'Uninstall'
	if ($uarray.length -eq 0){
	write-output "$computername" |Out-File c:\temp1\JavaDone.txt -Append}
	else{
	foreach ($unis in $uarray){
	$NewProcess = ([WMICLASS]"\\$computername\Root\CIMV2:Win32_Process").create("$unis /qn /passive /l*v! c:\packages\juninst.log")}
	write-output "$computername" |Out-File c:\temp1\JavaDone.txt -Append
	}
	}
}

else {write-output "$computername" | Out-File c:\temp1\JavaOffline.txt -Append}
}
