$rootsms = "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System"
test-path("$rootsms\C05001F1")
Gci "$rootsms"
C05001F1
| ForEach-Object {Get-ItemProperty $_.name}
Gci "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System" | ForEach-Object {gci $_.pspath} | Select-Object -property *


$a = Gci "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System" | ForEach-Object {gci $_.pspath} | select-object -Property * 
#$a |  select @{n='Properties';e={$_.Property}} | select @{n="ID";e={$_.ProgramID}}

$g = $a | where {$_.PSParentPath } | select @{n='PackageID';e={$_.NAME}} 

# output of g is this
# HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System\C05001F1\eaf3a042-10af-11e5-b8f7-005056843804 
# the parser cant understand that and requires it to be HKLM: so that has to be changed
# here is the output of the below script 
foreach ($fix in $g) {

#$a = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System\C0400033\5ad02b35-a2b5-11e2-8b92-00505684014c"
$good = $fix -replace "HKEY_LOCAL_MACHINE", "HKLM:"
$again = $good -replace "@{PackageID=", ''
$yagain = $again -replace "}", '' 


# now $good is fixed path so function will work below

#property               Value                
#--------               -----                
#_ProgramID             Install Java JRE 8u45
#_State                 Success              
#_RunStartTime          2015/06/11 22:54:05  
#SuccessOrFailureCode   0                    
#SuccessOrFailureReason      
########################################
# need to make this into a function#
#####################################
Push-Location 
#Set-Location  "HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Software Distribution\Execution History\System\C0400033\5ad02b35-a2b5-11e2-8b92-00505684014c"
Set-Location "$yagain"

Get-Item . |

Select-Object -ExpandProperty property |
ForEach-Object {

New-Object psobject -Property @{"property"=$_;

   "Value" = (Get-ItemProperty -Path . -Name $_).$_}}  | select-object -Index 0,2 |   Where {$_ -like "*Java*"}
      #out-file -append c:\testing-sms-output1.txt

#Format-Table property, value -AutoSize | out-file -append c:\testing-sms-output.txt

Pop-Location
} # this goes up to the foreach corresponding to $good



########################################
# have it check for RunStartTime to see if its today
# if its today then check status anc compare to Program ID vs whats in the config.
# if nothing for today then exit
# if for today and it matches config then check state to report on that and if success/failure report on that.
# if no success/fail yet then sleep and check again in 15 min
# if for today and not compared to config write to separate area to alert just ce for either debuging or tracking ce deployments



#select-string -Pattern "java|_RunStartTime" -Path "c:\testing-sms-output1.txt"