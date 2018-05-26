Param([string]$strComputer,[string]$username)

$datetime = Get-Date -Format "yyyyMMddHHmm";
 $errorlog = "e:\wamp\www\iam\$strComputer-error.txt" 
$localgroupName = "administrators"
$adminlog = "e:\wamp\www\iam\admin.txt"
  
  function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

$result = Ping-Server $computername

Trap {
                #define a trap to handle any WMI errors
                Write-Warning ("There was a problem with {0}" -f $computername.toUpper())
                Write-Warning $_.Exception.GetType().FullName
                Write-Warning $_.Exception.message
                "#############################" | add-content $errorlog
                $datetime | add-content $errorlog
               "There was a problem with {0}" -f $computername | add-content $errorlog
               $_.Exception.GetType().FullName | add-content $errorlog
               $_.Exception.message | add-content $errorlog
               "#############################" | add-content $errorlog
                Continue
                }
 if($result){
 "#############################" | out-file -Append $adminlog
 $datetime | Add-content $adminlog 
$domain = "SAI"
$computer = [ADSI]("WinNT://" + $strComputer + ",computer")
$computer.name | out-file -append $adminlog
$Group = $computer.psbase.children.find("administrators")
$username | out-file -append $adminlog
"#############################" | out-file -Append $adminlog
$Group.Add("Winnt://" + $domain + "/" + $username)

}
