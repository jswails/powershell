﻿# Adapted from: http://powershell.com/cs/media/p/3215.aspx
 
# List local group members on the local or a remote computer  

Param([string]$computername)
#$computername = ""
  
  function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

 $errorlog = "e:\wamp\www\adminaudit\$computername-error.csv" 
$localgroupName = "administrators"
$filesPath = "e:\wamp\www\adminaudit\"
 

$result = Ping-Server $computername

  Trap {
                #define a trap to handle any WMI errors
                Write-Warning ("There was a problem with {0}" -f $computername.toUpper())
                Write-Warning $_.Exception.GetType().FullName
                Write-Warning $_.Exception.message
               "There was a problem with {0}" -f $computername | add-content $errorlog
               $_.Exception.GetType().FullName | add-content $errorlog
               $_.Exception.message | add-content $errorlog
                Continue
                }
 if($result){
    if([ADSI]::Exists("WinNT://$computerName/$localGroupName,group")) {  
  
        $group = [ADSI]("WinNT://$computerName/$localGroupName,group")  
  
        $members = @()  
        $Group.Members() |  
        % {  
            $AdsPath = $_.GetType().InvokeMember("Adspath", 'GetProperty', $null, $_, $null)  
            # Domain members will have an ADSPath like WinNT://DomainName/UserName.  
            # Local accounts will have a value like 
            # WinNT://DomainName/ComputerName/UserName.  
            $a = $AdsPath.split('/',[StringSplitOptions]::RemoveEmptyEntries)  
            $name = $a[-1]  
            $domain = $a[-2]  
            $class = $_.GetType().InvokeMember("Class", 'GetProperty', $null, $_, $null)  
  
            $member = New-Object PSObject  
            $member | Add-Member -MemberType NoteProperty -Name "Name" -Value $name  
            $member | Add-Member -MemberType NoteProperty -Name "Domain" -Value $domain  
            $member | Add-Member -MemberType NoteProperty -Name "Class" -Value $class  
  
            $members += $member  
        }  
        
        # The back tick (`) tells PowerShell the command continues on the next line
        $members | Select-Object Name,Domain,Class `
          | export-csv "$filesPath\$computername.csv"  -NoTypeInformation
          
    }  
    else {  
        Write-Warning `
           "Local group '$localGroupName' doesn't exist on computer '$computerName'"  
          "Local group '$localGroupName' doesn't exist on computer '$computerName'" | add-content $errorlog
    } 
}


