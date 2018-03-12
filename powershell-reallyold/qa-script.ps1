


# using local servername
$Servername = "$env:computername"
$datetime = Get-Date -Format "yyyyMMddHHmm";

# Add headers to log file
Add-Content "c:\temp\QA-Script $datetime.txt" "server,office2010,bitlocker,VPN";

# test for office 2010
$proc = $env:PROCESSOR_ARCHITECTURE
if($proc = "x86")
{
$testoffice = "C:\Program Files\Microsoft Office\Office14\vviewer.dll"
if(Test-Path($testoffice)){
$officeinstalled = "Office 2010 on 32bit OS installed"
write-host $officeinstalled
}else{
$testoffice = "C:\Program Files (x86)\Microsoft Office\Office14\vviewer.dll"
if(Test-Path($testoffice)){
$officeinstalled = "Office 2010 on 64 bit OS installed"
write-host $officeinstalled
}else{
write-host "office not installed"
}
}
}

# get bitlocker status

$getblstatus = " manage-bde -status "

 $blresult = invoke-expression -command "$getblstatus"
 $blresult | out-file "c:\temp\QA-Script-bitlocker.txt" 
 write-host $blresult
 
 # check vpn installed
 
 $testvpn = "c:\Program Files (x86)\Cisco Systems\VPN Client\vpnclient.exe"
 if(Test-Path($testvpn)){
        $ServerName + " VPN software installed"
		$vpninstalled = "VPN software installed"
        }else{
            $ServerName + " VPN software not installed"
			$vpninstalled = " VPN software not installed"
        }
		

Add-Content "c:\temp\QA-Script $datetime.txt" "$servername,$officeinstalled,$vpninstalled";			
# find domain user in the local Administrators group on the local computer  

$domainname = "sai"
$erroractionpreference = "SilentlyContinue"
 $computername = "."
$userName = "workstation administrators"
  
if ($computerName -eq "") {$computerName = "$env:computername"}
([ADSI]"WinNT://$computerName/Administrators,group").Add("WinNT://$domainName/$userName")

$computer = [ADSI]("WinNT://" + $computername + ",computer")
$Group = $computer.psbase.children.find("Administrators")
$members= $Group.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}

ForEach($user in $members)

{
if ($user -eq $userName) {$found = $true}
}

if ($found -eq $true) {Write-Host "User $domainName\$userName is a local administrator on $servername." ; Add-content "c:\temp\QA-Script $datetime.txt" " Workstation Admin is an admin on the machine"}
else {Write-Host "User not found"; Add-content "c:\temp\QA-Script $datetime.txt" " Workstation Admin not found"}

#look up local printers for user.		
write-host "Default users printers:"
(get-wmiobject Win32_Printer -filter "Default=TRUE").Name

add-content "c:\temp\QA-Script $datetime.txt" "Default users printers:"
add-content "c:\temp\QA-Script $datetime.txt" (get-wmiobject Win32_Printer -filter "Default=TRUE").Name

#image version

$imgver = $env:imgver
write-host "image version ="  $imgver
add-content "c:\temp\QA-Script $datetime.txt" "image version = $imgver"

# virus scan
if($proc = "x86")
{
$vscan =  ("C:\Program Files\Symantec\Symantec Endpoint Protection\rtvscan.exe")
if(test-path($vscan)){
$vscaninstalled = "Symantec on 32bit OS installed"
write-host $vscaninstalled
}else{
$vscan = ("C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\rtvscan.exe")
if(test-path($vscan)){
$vscaninstalled = "Symantec on 64 bit OS installed"
write-host $vscaninstalled
}else{
write-host "virus scan not installed"
}
}
}

add-content "c:\temp\QA-Script $datetime.txt" $vscaninstalled

# check sccm installed
if($proc = "x86")
{
$sccminstall = ("C:\Windows\System32\CCM\ccmexec.exe")
if(test-path($sccminstall)){
$sccmcheck = "SCCM on 32bit OS installed"
write-host $sccmcheck
}else{
$sccminstall = ("c:\Windows\SysWOW64\CCM\ccmexec.exe")
if(test-path($sccminstall)){
$sccmcheck = "SCCM on 64 bit OS installed"
write-host $sccmcheck
}else{
write-host "sccm not installed"
}
}
}
add-content "c:\temp\QA-Script $datetime.txt" $sccmcheck


# event logs and device manager
compmgmt.msc


# check internet connection
$pinggoogle = ping google.com
add-content "c:\temp\QA-Script $datetime.txt" $pinggoogle

# display ipconfig
ipconfig
$ip = ipconfig
add-content "c:\temp\QA-Script $datetime.txt" $ip


# Get mac

$strcomputer = $env:COMPUTERNAME

 $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $strComputer |Where{$_.IpEnabled -Match "True"}  
     
    foreach ($objItem in $colItems) {  
     
        $objItem |select Description,MACAddress  
        
        $writemac = $objItem |select Description,MACAddress  
     
    } 
    

add-content "c:\temp\QA-Script $datetime.txt" $writemac











