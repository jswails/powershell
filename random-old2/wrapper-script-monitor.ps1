<#
NOTE: If you use this method, do not import the Add-RegKeyMember function and Get-ChildItem proxy function
#>
Add-Type @"
    using System; 
    using System.Text;
    using System.Runtime.InteropServices; 

    namespace CustomNameSpace {
        public class advapi32 {
            [DllImport("advapi32.dll", CharSet = CharSet.Auto)]
            public static extern Int32 RegQueryInfoKey(
                Microsoft.Win32.SafeHandles.SafeRegistryHandle hKey,
                StringBuilder lpClass,
                [In, Out] ref UInt32 lpcbClass,
                UInt32 lpReserved,
                out UInt32 lpcSubKeys,
                out UInt32 lpcbMaxSubKeyLen,
                out UInt32 lpcbMaxClassLen,
                out UInt32 lpcValues,
                out UInt32 lpcbMaxValueNameLen,
                out UInt32 lpcbMaxValueLen,
                out UInt32 lpcbSecurityDescriptor,
                out Int64 lpftLastWriteTime
            );
        }
    }
"@

Update-TypeData -TypeName Microsoft.Win32.RegistryKey -MemberType ScriptProperty -MemberName LastWriteTime -Value {

    $LastWriteTime = $null
            
    $Return = [CustomNameSpace.advapi32]::RegQueryInfoKey(
        $this.Handle,
        $null,       # ClassName
        [ref] 0,     # ClassNameLength
        $null,  # Reserved
        [ref] $null, # SubKeyCount
        [ref] $null, # MaxSubKeyNameLength
        [ref] $null, # MaxClassLength
        [ref] $null, # ValueCount
        [ref] $null, # MaxValueNameLength 
        [ref] $null, # MaxValueValueLength 
        [ref] $null, # SecurityDescriptorSize
        [ref] $LastWriteTime
    )

    if ($Return -ne 0) {
        "[ERROR]"
    }
    else {
        # Return datetime object:
        [datetime]::FromFileTime($LastWriteTime)
    }
}

Update-TypeData -TypeName Microsoft.Win32.RegistryKey -MemberType ScriptProperty -MemberName ClassName -Value {

    $ClassLength = 255 # Buffer size (class name is rarely used, and when it is, I've never seen 
                        # it more than 8 characters. Buffer can be increased here, though. 
    $ClassName = New-Object System.Text.StringBuilder $ClassLength  # Will hold the class name
            
    $Return = [CustomNameSpace.advapi32]::RegQueryInfoKey(
        $this.Handle,
        $ClassName,
        [ref] $ClassLength,
        $null,  # Reserved
        [ref] $null, # SubKeyCount
        [ref] $null, # MaxSubKeyNameLength
        [ref] $null, # MaxClassLength
        [ref] $null, # ValueCount
        [ref] $null, # MaxValueNameLength 
        [ref] $null, # MaxValueValueLength 
        [ref] $null, # SecurityDescriptorSize
        [ref] $null  # LastWriteTime
    )

    if ($Return -ne 0) {
        "[ERROR]"
    }
    else {
        # Return class name
        $ClassName.ToString()
    }
}




# get name of app install need to have a list that equates name of app install to what appears in ARP
# create sccm collection that machine is put in to deploy the script monitor. it executes the script and cleans up previous runs.
# need to create data collectors on admin3 for management portal
# the installer also sets up the mof program and runs that. copies over the mof from admin3 and runs its locally to setup wmi

# when admin3 is used have to edit the page to capture each app into a separate config file this file is put on admin3 in a folder for that computer and datetime
# when script monitor starts it searchs for config file on admin3
# write something to have it check for current date and if there is one then add to it if on same day they go back to machine
$smdir =  "C:\Packages\scriptmonitor"
$datetime = Get-Date -Format "yyyyMMdd";
$configroot = "\\admin3\scriptmonitor"
"start" | out-file "$smdir\start.txt"

#run the script if locally something found in past day this wrapper runs every 15 minutes. once it finds the local registry change then the config files come into play
dir "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System\" | where { $_.LastWriteTime -gt (Get-Date).AddDays(-1) } | foreach-object -Process { $_.Name | out-file c:\test.txt}
$begin = dir "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System\" | where { $_.LastWriteTime -gt (Get-Date).AddDays(-1) } 
$begin | Out-File "$smdir\beginout.txt"
 if($begin){
 

if(!(test-path("$smdir\script-monitor.ps1"))) {
xcopy "\\sadc1cm12pkgp1\Packages\stateauto\scriptmonitor\script-monitor.ps1" "$smdir\"
}
# checking to see if active still around. if it is add to it.if not around that means that it should have become archived and can proceed with new run.
if(test-path("$smdir\$datetime.deploy-Active")) {
#read server deploy config and insert its config into current active config
if(!(test-path("$configroot\$env:COMPUTERNAME"))){
"configroot path for computer not created - wrapper" | out-file $smdir\$datetime.nocomputer; break }
if(test-path("$configroot\$env:computername\$datetime.deploy")){
get-Content "$configroot\$env:computername\$datetime.deploy" | % {
$_ | out-file -append $smdir\$datetime.deploy-Active
}
}
}


#check for mof existence whether it needs to run for first time.
if(!(test-path("$smdir\productslist.mof"))){
xcopy \\sadc1cm12pkgp1\Packages\stateauto\scriptmonitor\productslist.mof $smdir\
c:\Windows\System32\wbem\mofcomp.exe c:\packages\scriptmonitor\productslist.mof
}
# run the file monitor

    powershell.exe -file $smdir\script-monitor.ps1
    }
