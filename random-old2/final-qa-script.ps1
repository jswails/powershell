
# using local servername
$Servername = "$env:computername"
$datetime = Get-Date -Format "yyyyMMddHHmm";

# Add headers to log file
Add-Content "c:\temp\Final-QA-Script $datetime.txt" "server,office2010,bitlocker,VPN";

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
 $blresult | out-file "c:\temp\Final-QA-Script-bitlocker.txt" 
 write-host $blresult
 
 # check vpn installed
 
 $testvpn = "C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnagent.exe"
 if(Test-Path($testvpn)){
        $ServerName + " VPN software installed"
		$vpninstalled = "VPN software installed"
        }else{
            $ServerName + " VPN software not installed"
			$vpninstalled = " VPN software not installed"
        }
		

Add-Content "c:\temp\Final-QA-Script $datetime.txt" "$servername,$officeinstalled,$vpninstalled";			
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

add-content "c:\temp\Final-QA-Script $datetime.txt" "Default users printers:"
add-content "c:\temp\Final-QA-Script $datetime.txt" (get-wmiobject Win32_Printer -filter "Default=TRUE").Name

#image version

$imgver = $env:imgver
write-host "image version ="  $imgver
add-content "c:\temp\Final-QA-Script $datetime.txt" "image version = $imgver"

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

add-content "c:\temp\Final-QA-Script $datetime.txt" $vscaninstalled

# check sccm installed
if($proc = "x86")
{
$sccminstall = ("C:\Windows\CCM\ccmexec.exe")
if(test-path($sccminstall)){
$sccmcheck = "SCCM on 32bit OS installed"
write-host $sccmcheck
}else{
$sccminstall = ("c:\Windows\CCM\ccmexec.exe")
if(test-path($sccminstall)){
$sccmcheck = "SCCM on 64 bit OS installed"
write-host $sccmcheck
}else{
write-host "sccm not installed"
}
}
}
add-content "c:\temp\Final-QA-Script $datetime.txt" $sccmcheck


# event logs and device manager
compmgmt.msc


# check internet connection
$pinggoogle = ping google.com
add-content "c:\temp\Final-QA-Script $datetime.txt" $pinggoogle

# display ipconfig
ipconfig
$ip = ipconfig
add-content "c:\temp\Final-QA-Script $datetime.txt" $ip


# Get mac

$strcomputer = $env:COMPUTERNAME

 $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $strComputer |Where{$_.IpEnabled -Match "True"}  
     
    foreach ($objItem in $colItems) {  
     
        $objItem |select Description,MACAddress  
        
        $writemac = $objItem |select Description,MACAddress  
     
    } 
    add-content "c:\temp\Final-QA-Script $datetime.txt" $writemac
    
    # check dns issues
    $h = $env:COMPUTERNAME
$a = Test-Connection $h
$b = $a.IPV4Address | select-object IPaddresstostring -First 1
$c = ping -n 1 -a $b.IPAddressToString | select-string -SimpleMatch "Pinging"
 $c | select-string -SimpleMatch $h

 if ($c -eq $null) {
  $dnsfail = " records do not match. dns issue"
  add-content "c:\temp\Final-QA-Script $datetime.txt" $dnsfail
 } else {
$dnsok = " ip matches dns"
add-content "c:\temp\Final-QA-Script $datetime.txt" $dnsok
 }

 #output of desktop currently

 $desktop = dir "C:\Users\Public\Desktop" 

 add-content "c:\temp\Final-QA-Script $datetime.txt" $desktop

 # output add remove programs
 "Installled Applications and Versions" | out-file -append "c:\temp\Final-QA-Script $datetime.txt"
 $ar = gwmi win32reg_addremoveprograms 
 foreach($program in $ar) {
 $displayname = $program.displayname
 $appversion = $program.version
write-host $displayname "--->Version:" $appversion
$displayname +  "--->Version:" + $appversion  | out-file -append "c:\temp\Final-QA-Script $datetime.txt"

 }











