#
# Copyright (c) Microsoft Corporation.  All rights reserved.
#
#
# Use of this source code is subject to the terms of the Microsoft
# premium shared source license agreement under which you licensed
# this source code. If you did not accept the terms of the license
# agreement, you are not authorized to use this source code.
# For the terms of the license, please see the license agreement
# signed by you and Microsoft.
# THE SOURCE CODE IS PROVIDED "AS IS", WITH NO WARRANTIES OR INDEMNITIES.
#
#####################################################################
# Location of the script to call to setup the servers
#####################################################################
$_BaseDeploymentRoot    = '\\winphonelabs\wpstress\Install\Mash\Seven\tools\PodMASH\Deployment\Releases\Latest'

$_ConfigType            = 'Test'
$_CEDebugXSrcDir        = '\\winphonelabs\wpstress\BIN\cedebugx\latest\seven'
$_RDSCleanupScript      = '.\RDSCleanup.bat'
$_RemDiagSrcDir         = '{0}\{1}\RemoteDiagnoser' -f ($_BaseDeploymentRoot, $_ConfigType)
$_RDSUploaderXml        = '{0}\{1}\Client\DiagnosisUploaderConfig.xml' -f ($_BaseDeploymentRoot, $_ConfigType)
$_WatsonSrcDir          = '\\WinPhoneLabs\WPStress\Install\Mash\Seven\tools\WatsonUploader\latest\retail'

$_UserName = 'redmond\mojoabvt'
$_Password = ''

#####################################################################
# Number of RDS hosts and virtual controllers
#####################################################################
$rdsCount = 5
$virtualCount = 9

function ReadUploaderConfigXml($uploaderConfigFile)
{
    $xmlReader = New-Object "System.Xml.XmlTextReader"($uploaderConfigFile);

    while($xmlReader.Read())
    {
        if($xmlReader.IsStartElement("setting"))
        {
            if($xmlReader.GetAttribute("name") -eq "UploadTarget")
            {
                $pathsString    = $xmlReader.ReadElementString();
                $pathsArray     = $pathsString.Split(@(",",";"), [System.StringSplitOptions]"RemoveEmptyEntries");
                break;
            }
        }
    }

    $xmlReader.Close();
    return $pathsArray;
}

function MachineNameFromSharePath($share)
{
    if($share.IndexOf('\\') -eq 0)
    {
            $nextWhack = $share.IndexOf('\', 2);
            if($nextWhack -ge 0)
            {
                # If there are any additional whacks, truncate
                return $share.Substring(2, $nextWhack - 2);
            }
            else
            {
                # Otherwise, return the string minus the initial whacks
                return $share.Substring(2);
            }
    }

    return "";
}

function UpdateRDSMachines ()
{
    $rdsPaths = ReadUploaderConfigXml($_RDSUploaderXml);
	
    foreach($rdsPath in $rdsPaths)
    {
        $machineName = MachineNameFromSharePath($rdsPath);
        write-host "Preparing to execute 'UpdateSingleMachine' on '$machineName'"
        UpdateSingleMachine($machineName);
    }
}

function InvokeOnRDSMachines ([string] $functionName)
{
    $rdsPaths = ReadUploaderConfigXml($_RDSUploaderXml);
	
    foreach($rdsPath in $rdsPaths)
    {
        $machineName = MachineNameFromSharePath($rdsPath);		
        write-host "Preparing to execute '$functionName' on '$machineName'"
        & $functionName $machineName
    }
}

function UpdateSingleMachine([string] $machineName)
{
    CreateRDSDirStructure($machineName)
    CreateUploadMonitorShare($machineName)
    #UpdateCEDebugXBinaries($machineName)
    UpdateRemoteDiagnoserBinaries($machineName)
    UpdateRemoteDiagnoserSchedTask($machineName)
    UpdateWatsonUploaderSchedTask($machineName)
    UpdateVSSymbolServer($machineName)
    #ReprocessFailedUploadeds($machineName)
}

function CreateRDSDirStructure([string] $machineName)
{
    #
    # Create the dir structure for the RDS machine
    #
    write-host "Creating the directory structure for the RDS"
    md \\$machineName\d$\RemoteDiagnoser
    md \\$machineName\d$\UploadMonitorDir
    md \\$machineName\d$\WatsonUploader
    md \\$machineName\d$\WatsonTargetDir
}

function CreateUploadMonitorShare([string] $machineName)
{
    $_CreateUploadMonitorShareScript = ".\CreateUploadMonitorShare.bat"

    #
    # Create the share that will be used to upload Diagnosis Packages to
    #
    $flags = '';
    $copyScript = '-c -f "{0}"' -f ($_CreateUploadMonitorShareScript)
    $pseCommandLine = '"\\{0}" {1} {2}' -f ($machineName, $flags, $copyScript)

    # Execute the command
    write-host "  psexec Command Line: $pseCommandLine"
    .\psexec.exe $pseCommandLine
}

function UpdateCEDebugXBinaries([string] $machineName)
{
    KillRemoteDiagnoserProcesses($machineName)

    # Update the CEDebugXBinaries
    robocopy "$_CEDebugXSrcDir" "\\$machineName\c$\Program Files (x86)\Microsoft Platform Builder\7.00\cepb\bin\Extensions" "*.*"

    StartRemoteDiagnoserTask($machineName)
}

function ReprocessFailedUploadeds([string] $machineName)
{
    $_ReprocessFailedUploadedScript = ".\ReprocessFailedUploadeds.bat"

    #
    # Move the Failed Uploaded files to be reprocessed
    #
    $flags = "-i -d"
    $copyScript = '-c -f "{0}"' -f ($_ReprocessFailedUploadedScript)
    $pseCommandLine = '"\\{0}" {1} {2}' -f ($machineName, $flags, $copyScript)

    # Execute the command
    write-host "psexec Command Line: $pseCommandLine"
    .\psexec.exe $pseCommandLine
}

function UpdateVSSymbolServer([string]$machineName)
{
    $_SetSymbolPathScript = ".\SetSymServPath.bat"

    #
    # Update the default Symbol Path for the RDS machines
    #
    $flags = "-i -d"
    $copyScript = '-c -f "{0}"' -f ($_SetSymbolPathScript)
    $pseCommandLine = '"\\{0}" {1} {2}' -f ($machineName, $flags, $copyScript)

    # Copy the regfile to the machine
    robocopy "." "\\$machineName\d$" "SetSymServPath.reg"

    # Execute the command
    write-host $pseCommandLine
    .\psexec.exe $pseCommandLine
}

function ConfigureRDM([string]$machineName)
{
  Write-Host "Configuring RDM on $machineName..."

  # Copy the REG file to the target host to be executed
  copy-item .\RemoteDiagnosisMonitorService.reg -destination \\$machineName\c$\ -force

  .\psexec.exe \\$machineName regedit.exe /s c:\RemoteDiagnosisMonitorService.reg

  remove-item -path \\$machineName\c$\RemoteDiagnosisMonitorService.reg -force
}

function UpdateRemoteDiagnoserSchedTask([string]$machineName)
{
    Write-Host "Updating the RD scheduled task on $machineName..."
    
    # Ensure the RD scheduled task isn't running
    schtasks "/end" "/s" "$machineName" "/tn" "RemoteDiagnoser"

    # Delete the current task so we can recreate to fix command line
    schtasks "/delete" "/f" "/s" "$machineName" "/tn" "RemoteDiagnoser"

    # Recreate the task with the new commandline
    schtasks "/create" "/s" "$machineName" "/XML" ".\RemoteDiagnoserSchedTask.xml" "/RU" "$_UserName" "/RP" "$_Password" "/TN" "RemoteDiagnoser" "/IT"

    StartRemoteDiagnoserTask $machineName
}

function UpdateWatsonUploaderSchedTask([string]$machineName)
{
    # Set the command line for the task
    # Note: use cmd to set the working dir so logging works correctly
    $watsonUploaderCmdLine = 'cmd /c \"pushd d:\WatsonUploader && WatsonUploaderUI.exe /dropfolder d:\WatsonTargetDir /cedevicelog default.cedevice.log /icaboutfile d:\WatsonUploader\results.txt /interval 3\"'

	# Kill the WatsonUploader if it's currently running 
    schtasks "/end" "/s" "$machineName" "/tn" "WatsonUploader"

    # Kill the WatsonUploader if it's still running to pick up the new command line
    KillRemoteProc $machineName WatsonUploaderUI

    # Delete the current task so we can recreate to fix command line
    schtasks "/delete" "/f" "/s" "$machineName" "/tn" "WatsonUploader"

    # Recreate the task with the new commandline
    #schtasks "/create" "/s" "$machineName" "/tn" "WatsonUploader" "/tr" "$watsonUploaderCmdLine" "/sc" "DAILY" "/st" "11:45" 
    schtasks "/create" "/s" "$machineName" "/XML" ".\WatsonUploaderSchedTask.xml" "/RU" "$_UserName" "/RP" "$_Password" "/TN" "WatsonUploader" "/IT"

    # Run the WatsonUploader task as the user specified
    schtasks.exe "/Run" "/s" "$machineName" "/tn" "WatsonUploader" "/U" "$_UserName" "/P" "$_Password" "/I"
}

function KillRemoteProc ([string]$machineName, [string]$processName)
{
    $message = "Killing {0} on {1}" -f $processName, $machineName
    echo $message

    .\pskill.exe "\\$machineName" -u "$_UserName" -p "$_Password" "$processName"
}

function KillRemoteDiagnoserProcesses([string]$machineName)
{
    Write-Host "Stopping RD Scheduled Task and terminating RD exes..."
    
    # Kill the RemoteDiagnosisMonitor if it's currently running 
    schtasks "/end" "/s" "$machineName" "/tn" "RemoteDiagnoser"
    
    KillRemoteProc $machineName RemoteDiagnosisMonitor
    KillRemoteProc $machineName RemoteDiagnoser
    KillRemoteProc $machineName Devenv
    KillRemoteProc $machineName CeSvcHost
    KillRemoteProc $machineName WerFault
    KillRemoteProc $machineName MMC
}

function StartRemoteDiagnoserTask([string]$machineName)
{
    # Run the RemoteDiagnoser task as the user specified
    schtasks.exe "/Run" "/s" "$machineName" "/tn" "RemoteDiagnoser" "/U" "$_UserName" "/P" "$_Password" "/I"
}

function UpdateRemoteDiagnoserBinaries ([string]$machineName)
{
    KillRemoteDiagnoserProcesses($machineName)

    Write-Host "Updating RemoteDiagnoser binaries on $machineName..."
    
    robocopy "$_RemDiagSrcDir" "\\$machineName\d$\RemoteDiagnoser" "*.*"
}

function UpdateWatsonBinaries ($machineName)
{
	# Kill the WatsonUploader if it's currently running 
    schtasks "/end" "/s" "$machineName" "/tn" "WatsonUploader"

    # Kill the WatsonUploader if it's still running to pick up the new command line
    KillRemoteProc $machineName WatsonUploaderUI

    robocopy $_WatsonSrcDir \\$machineName\d$\WatsonUploader *.*

	# Run the WatsonUploader task as the user specified
    schtasks.exe "/Run" "/s" "$machineName" "/tn" "WatsonUploader" "/U" "$_UserName" "/P" "$_Password" "/I"
}

for($index = 0; $index -lt $args.Length; $index++)
{
	switch($args[$index])
	{
		"/UploaderConfig"
		{
			$index++;
			$_RDSUploaderXml = $args[$index];
		}
		
		"/CEDebugXSrcDir"
		{
			$index++;
			$_CEDebugXSrcDir = $args[$index];
		}
		
		"/RDSCleanupScript"
		{
			$index++;
			$_RDSCleanupScript = $args[$index];
		}
		
		"/RemDiagSrcDir"
		{
			$index++;
			$_RemDiagSrcDir = $args[$index];
		}
		
		"/WatsonSrcDir"
		{
			$index++;
			$_WatsonSrcDir = $args[$index];
		}
		
		"/UserName"
		{
			$index++;
			$_UserName = $args[$index];
		}
		
		"/Password"
		{
			$index++;
			$_Password = $args[$index];
		}
        
        "/BaseDeploymentRoot"
        {
            $index++;
            $_BaseDeploymentRoot = $args[$index];
        }
        
        "/ConfigType"
        {
            $index++;
            $_ConfigType = $args[$index];
        }
	}
}

# Update the inferred paths based on configuration settings
$_RemDiagSrcDir         = '{0}\{1}\RemoteDiagnoser' -f ($_BaseDeploymentRoot, $_ConfigType)
$_RDSUploaderXml        = '{0}\{1}\Client\DiagnosisUploaderConfig.xml' -f ($_BaseDeploymentRoot, $_ConfigType)

if((test-path $_BaseDeploymentRoot) -ne $True)
{
    throw ("Base deployment directory {0} does not exist" -f ($_BaseDeploymentRoot))
}

if((test-path $_RemDiagSrcDir) -ne $True)
{
    throw ("Remote diagnoser directory {0} does not exist" -f ($_RemDiagSrcDir))
}

if((test-path $_RDSUploaderXml) -ne $True)
{
    throw ("Remote diagnosis uploader file {0} does not exist" -f ($_RDSUploaderXml))
}

write-host ""
write-host "Configuration Settings"
write-host "----------------------"
write-host "  + BaseDeploymentRoot  $_BaseDeploymentRoot"
write-host "  + ConfigType          $_ConfigType"
write-host "  + UploaderConfig      $_RDSUploaderXml"
write-host "  + CEDebugXSrcDir      $_CEDebugXSrcDir"
write-host "  + RDSCleanupScript    $_RDSCleanupScript"
write-host "  + RemDiagSrcDir       $_RemDiagSrcDir"
write-host "  + WatsonSrcDir        $_WatsonSrcDir"
write-host "  + UserName            $_UserName"
write-host "  + Password            ********"
write-host ""
    
& $args[0] $args[1]
