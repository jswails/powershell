cls
import-module activedirectory

$result = Get-Content c:\temp\list.txt


foreach ($computer in $result)
{
	#invoke-command -ComputerName $computer -ScriptBlock {Add-Computer -DomainName corp.stateauto.com -credential SAI\GE_Support -OUPath 'OU=Workstations,DC=corp,DC=stateauto,DC=com'}
    invoke-command -ComputerName $computer -ScriptBlock {Add-Computer -WorkGroupName WORKGROUP}
    

    
	#Start-Sleep 10
	
	#$try = Get-ADComputer $computer
	#if ($try -eq $true)
	#{
		#computer was successfully added
	#}
	#else
	#{
		#it wasn't
	#}	
}