
##############################################################################
## 20121101 - released script - Chris Nicholson                             ##
##                                                                          ##
##############################################################################

#STORED CREDENTIAL CODE
$AdminName = Read-Host "Enter your Admin AD username"
$CredsFile = "C:\$AdminName-PowershellCreds.txt"
$FileExists = Test-Path $CredsFile
if  ($FileExists -eq $false) {
    Write-Host 'Credential file not found. Enter your password:' -ForegroundColor Red
    Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File $CredsFile
    $password = get-content $CredsFile | convertto-securestring
    $Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist domain\$AdminName,$password}
else
    {Write-Host 'Using your stored credential file' -ForegroundColor Green
    $password = get-content $CredsFile | convertto-securestring
    $Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist domain\$AdminName,$password}

############################
#      Menu                #
############################


do {
function Read-Choice {
  PARAM([string]$message, [string[]]$choices, [int]$defaultChoice=3, [string]$Title=$null )
  $Host.UI.PromptForChoice( $caption, $message, [Management.Automation.Host.ChoiceDescription[]]$choices, $defaultChoice )
}


$choice = Read-Choice "Delete Computer Account"  @("Delete &AD","Delete D&NS","&Email Symantec Admin","E&xit")
$time = (Get-Date).ToLongTimestring()


############################
#      Delete AD           #
############################

if ($choice -eq "0"){

[console]::ForegroundColor = "yellow"
Import-Module ActiveDirectory
$Target = Read-Host "Enter computer name you want to remove from Active Directory:"
[console]::ResetColor()

Write-Host -ForegroundColor Cyan "$time - Checking to see if computer exists."
$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
# AD  
$ADResult = (Get-ADComputer -Filter {cn -like $Target}).name -eq $Target

if ($ADResult -eq $true) { 
Write-Host -ForegroundColor Red "$time - $Target has been found in AD."
   Remove-ADComputer -Identity "$Target" -confirm:$false -Credential $Cred -ErrorAction Stop | out-Null
   write-host $([char]7)
   write-Host "$Target is deleted" -ForegroundColor Green
   $response = Read-Host "Make another selection Y/N"
     }
if ($ADResult -eq $false) {
   write-Host -ForegroundColor Red "$time - $Target NOT found in AD."
   $response = Read-Host "Make another selection Y/N"
  }
 }
 
#############################
#      Delete DNS           #
#############################
 
 if ($choice -eq "1"){
[console]::ForegroundColor = "yellow"
$Target = Read-Host "Enter computer name you want to remove from DNS:"
$IPaddress = Read-Host "Enter IP system pings at:"
[console]::ResetColor()
 #Build our DNSCMD DELETE command syntax 
$cmdDeleteA = "SADC1AD1 /RecordDelete corp.stateauto.com $Target A $IPaddress /f"
$cmdDeletePTR = "SADC1AD1 /RecordDelete corp.stateauto.com $Target PTR $IPaddress /f"
 #Now we execute the command 
    Write-Host "Running the following command: $cmdDeleteA" 
	Start-Process dnscmd.exe -Credential $Cred $cmdDeleteA
	Start-Process dnscmd.exe -Credential $Cred $cmdDeletePTR
	write-Host "$Target is deleted" -ForegroundColor Green
	$response = Read-Host "Make another selection Y/N"
	}
	
	
#############################
#      Send Email           #
#############################	



#############################
#      EXIT                 #
#############################

if ($choice -eq "3"){
 {exit}
 }
	
 }while ($response -eq "y")
