# import the AD module
if (-not (Get-Module ActiveDirectory)){
    Import-Module ActiveDirectory -ErrorAction Stop            
}
 
# set new default password
$password = ConvertTo-SecureString -AsPlainText "Password01" -Force 
 
# get list of account names (1 per line)
$list = Get-Content -Path c:\scripts\users.txt
 
# loop through the list
ForEach ($u in $list) {
 
    if ( -not (Get-ADUser -LDAPFilter "(sAMAccountName=$u)")) { 
        Write-Host "Can't find $u"
    }
    else { 
        $user = Get-ADUser -Identity $u
        $user | Set-ADAccountPassword -NewPassword $password -Reset
        $user | Set-AdUser -ChangePasswordAtLogon $false
        Write-Host "changed password for $u"
    }
}