
# using local machine
$Servername = "$env:computername"
$datetime = Get-Date -Format "yyyyMMddHHmm";

# set c:\temp to allow users to write


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
write-host "office 2010 not installed"
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

# check for reader
if(test-path "C:\Program Files (x86)\Adobe\Reader 10.0\Reader\acrord32.exe")
{
$adrdr = " Adobe Reader is installed"
write-host $adrdr
} else {
write-host " adobe reader not installed"
}
add-content "c:\temp\QA-Script $datetime.txt" $adrdr
# check for silverlight

if(test-path "C:\Program Files (x86)\Microsoft Silverlight")
{
$silverlight = " Silverlight is installed"
write-host $silverlight
} else {
write-host " silverlight not installed"
}
add-content "c:\temp\QA-Script $datetime.txt" $silverlight
# check for flash player
if(test-path HKLM:\Software\Macromedia\FlashPlayerActiveX)
{
$flashplayer = " Flash Player is installed"
Write-Host $flashplayer
} else {
Write-Host " Flash Player is not installed"
}
add-content "c:\temp\QA-Script $datetime.txt" $flashplayer
#check for shockwave
if(Test-Path "C:\Windows\SysWOW64\Adobe\Shockwave 11\swinit.exe")
{
$shockwaveinstall = " Shockwave11 for 64 bit found"
Write-Host $shockwaveinstall
} else {
Write-Host " Shockwave 11 for 64 bit not found."
}
add-content "c:\temp\QA-Script $datetime.txt" $shockwaveinstall
# check for business objects crystal printer control

if(Test-Path "C:\Program Files (x86)\Business Objects\BusinessObjects Enterprise 11.5\win32_x86\ApsAdminHelper8.dll")
{
$businessobjects = " Microsoft Business Objects is installed"
Write-Host $businessobjects
} else {
Write-Host " Microsoft Business Objects is not installed"
}
add-content "c:\temp\QA-Script $datetime.txt" $businessobjects
# check for java 6 update 23
if(Test-Path "C:\Program Files (x86)\Java\jre6\bin")

{
$javainstalled = "Java installed"
Write-Host $javainstalled
} else {
Write-Host " Java 6 is not installed"
}
add-content "c:\temp\QA-Script $datetime.txt" $javainstalled
# check for ms office 2003 web components
if(Test-Path "C:\Program Files (x86)\Common Files\microsoft shared\Web Components\11\owc11.dll")
{
$2003webcomp = " Office 2003 web components installed"
Write-Host $2003webcomp
} else {
Write-Host " Office 2003 web components not installed"
}
add-content "c:\temp\QA-Script $datetime.txt" $2003webcomp

# check for ms office access db engine 2007


# check for communicator installed
if(Test-Path "C:\Program Files (x86)\Microsoft Office Communicator\communicator.exe")
{
$officecommunicator = " Office communicator installed "
Write-Host $officecommunicator
}else {
Write-Host " Office Communicator not installed"
}
add-content "c:\temp\QA-Script $datetime.txt" $officecommunicator
# check for visio viewer 2010
if(Test-Path "c:\Program Files (x86)\Microsoft Office\Office14\vpreview.exe")
{
$visiopreview = "  Visio preview is installed"
Write-Host $visiopreview
} else {
Write-Host " Visio preview is not installed"
}
add-content "c:\temp\QA-Script $datetime.txt" $visiopreview
# check for pwa activex 2011
if(Test-Path "C:\Program Files (x86)\My Company Name\My Product Name")
{ 
$pwaactivex = " It would appear to have attempted the Active X control. "
Write-Host $pwaactivex
} else {
Write-Host " Active X PWA did not install "
}
add-content "c:\temp\QA-Script $datetime.txt" $pwaactivex
# check for s2mclient
if(Test-Path "C:\Program Files (x86)\State Auto Insurance\S2MClient v3.1.0")
{
$s2mclientinstall = " S2MClient v3.1.0 was run to install"
Write-Host $s2mclientinstall
} else {
Write-Host " S2MClient did not create path to install"
}
add-content "c:\temp\QA-Script $datetime.txt" $s2mclientinstall


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
    
    # start appsense support script
    
    
 

add-content "c:\temp\QA-Script $datetime.txt" $writemac







