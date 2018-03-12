$datetime = Get-Date -Format "yyyyMMddHHmm";
$log = "c:\temp\$env:USername-exportmigration.log"
add-content $log " ################## $datetime  #######################"
Add-Content $log "Beginning of migration - Good Luck we are all counting on you."
# added this per brian request to catch old my docs possibly missed. #########
Add-Content $log "moving any existing local my docs to H:\migration\XP-mydocs"

if ( test-path c:\temp\ )
{
}
else
{
mkdir c:\temp
}
if ( test-path "$env:userprofile\my documents\my documents\" ) 
{
$buttons=[system.windows.forms.messageboxbuttons]::ok; [system.windows.forms.messagebox]::Show("My Documents is not properly setup. Stop process and correct","",$buttons); 
exit
}

############################
#      Menu                #
############################


do {
function Read-Choice {
  PARAM([string]$message, [string[]]$choices, [int]$defaultChoice=1, [string]$Title=$null )
  $Host.UI.PromptForChoice( $caption, $message, [Management.Automation.Host.ChoiceDescription[]]$choices, $defaultChoice )
}


$choice = Read-Choice "Do you want to backup the current XP My Docs to their H drive"  @("&YesBackup","&NoBackup")

###############################
###############################

if ($choice -eq "0"){


    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:Userprofile\my documents" "h:\migration\XP-mydocs" /E /log+:c:\temp\xpmydocs.log


    #####################################################################################
    Add-Content $log "Started Favorites migration to H:\Migration\favorites\ "
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\favorites" H:\Migration\favorites /E /log+:c:\temp\favoritesexport.log
    Add-Content $log " Starting to attempt desktop move. check c:\temp\desktopexport.log"
    if ( test-path h:\desktop\ )
        {

    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\desktop" H:\desktop /E /log+:c:\temp\desktopexport.log
        }
        else
        {
    mkdir h:\desktop\
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\desktop" H:\desktop /E /log+:c:\temp\desktopexport.log
        }
    Add-Content $log " Assumed desktop finished; starting Pictures move to h:\Migration\My Pictures\"
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\My Documents\My Pictures" "h:\Migration\My Pictures" /E /log+:c:\temp\picexport.log
    Add-Content $log " Assumed pics done starting music now."
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\My Documents\My Music" "h:\Migration\My Music" /E /log+:c:\temp\musicexport.log
    Add-Content $log " Assumed Music done starting video now."
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\My Documents\My Videos" "h:\Migration\My Videos" /E /log+:c:\temp\videoexport.log
    Add-Content $log " Assumed videos done starting outlook settings now."
    if (test-path h:\usersettings\outlook-settings\)
        {
        "outlook user folder exists"
        invoke-item \\sadc1sccmp1\osd\SettingsXfer\export-outlook-settings.bat
        }
        else
        {
      
    mkdir h:\usersettings\outlook-settings
    invoke-item \\sadc1sccmp1\osd\SettingsXfer\export-outlook-settings.bat
    }
    Add-Content $log " Assumed outlook settings done check the h:\usersettings\outlook_settings folder."
    if ( test-path c:\mitbak\ )
    {
    mkdir h:\mitchellbackup\
    cpi c:\mitbak\* h:\mitchellbackup\
    Add-Content $log " mitchell backup created on h:\mitchellbackup"
    }

    if ( test-path c:\mochasoft\) 
    {
    mkdir h:\usersettings\MigratedMochasoft
    cpi -force c:\mochasoft\*.map "h:\usersettings\MigratedMochasoft"
    }

    if ( test-path "c:\program files\HEAT\" )
    {
    mkdir h:\userdata\HeatAlert\
    cpi "C:\program files\HEAT\*.alr" h:\userdata\HeatAlert\
    Add-Content $log " heat alerts copied over to h:\userdata\HeatAlert"
    }
    if ( test-path "$ENV:userprofile\Local Settings\Application Data\Microsoft\Communicator\")
    {
    cpi "$ENV:userprofile\Local Settings\Application Data\Microsoft\Communicator\sip*\*" h:\usersettings\communicator\
    } else {

    add-content $log " no communicator settings " 

    }

    # capture current default printer name
		
    write-host "Default users printers:"
    (get-wmiobject Win32_Printer -filter "Default=TRUE").Name


    add-content "h:\defaultprinter.txt" (get-wmiobject Win32_Printer -filter "Default=TRUE").Name
  }
  
  
  if ($choice -eq "1"){

      Add-Content $log "Started Favorites migration to H:\Migration\favorites\ "
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\favorites" H:\Migration\favorites /E /log+:c:\temp\favoritesexport.log
    Add-Content $log " Starting to attempt desktop move. check c:\temp\desktopexport.log"
    if ( test-path h:\desktop\ )
        {

    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\desktop" H:\desktop /E /log+:c:\temp\desktopexport.log
        }
        else
        {
    mkdir h:\desktop\
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\desktop" H:\desktop /E /log+:c:\temp\desktopexport.log
        }
    Add-Content $log " Assumed desktop finished; starting Pictures move to h:\Migration\My Pictures\"
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\My Documents\My Pictures" "h:\Migration\My Pictures" /E /log+:c:\temp\picexport.log
    Add-Content $log " Assumed pics done starting music now."
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\My Documents\My Music" "h:\Migration\My Music" /E /log+:c:\temp\musicexport.log
    Add-Content $log " Assumed Music done starting video now."
    \\sadc1sccmp1\osd\settingsxfer\robocopy.exe "$env:USERPROFILE\My Documents\My Videos" "h:\Migration\My Videos" /E /log+:c:\temp\videoexport.log
    Add-Content $log " Assumed videos done starting outlook settings now."
    if (test-path h:\usersettings\outlook-settings\)
        {
        "outlook user folder exists"
        invoke-item \\sadc1sccmp1\osd\SettingsXfer\export-outlook-settings.bat
        }
        else
        {
      
    mkdir h:\usersettings\outlook-settings
    invoke-item \\sadc1sccmp1\osd\SettingsXfer\export-outlook-settings.bat
    }
    Add-Content $log " Assumed outlook settings done check the h:\usersettings\outlook_settings folder."
    if ( test-path c:\mitbak\ )
    {
    mkdir h:\mitchellbackup\
    cpi c:\mitbak\* h:\mitchellbackup\
    Add-Content $log " mitchell backup created on h:\mitchellbackup"
    }

    if ( test-path c:\mochasoft\) 
    {
    mkdir h:\usersettings\MigratedMochasoft
    cpi -force c:\mochasoft\*.map "h:\usersettings\MigratedMochasoft"
    }

    if ( test-path "c:\program files\HEAT\" )
    {
    mkdir h:\userdata\HeatAlert\
    cpi "C:\program files\HEAT\*.alr" h:\userdata\HeatAlert\
    Add-Content $log " heat alerts copied over to h:\userdata\HeatAlert"
    }
    if ( test-path "$ENV:userprofile\Local Settings\Application Data\Microsoft\Communicator\")
    {
    cpi "$ENV:userprofile\Local Settings\Application Data\Microsoft\Communicator\sip*\*" h:\usersettings\communicator\
    } else {

    add-content $log " no communicator settings " 

    }

    # capture current default printer name
		
    write-host "Default users printers:"
    (get-wmiobject Win32_Printer -filter "Default=TRUE").Name


    add-content "h:\defaultprinter.txt" (get-wmiobject Win32_Printer -filter "Default=TRUE").Name
  }
  


# copy logs to central log site
 if ( test-path \\sadc1sccmp1\osd\SettingsXfer\log\$env:USername\ )
 {
 cpi c:\temp\*.log \\sadc1sccmp1\osd\SettingsXfer\log\$env:USername\
 } else {
 mkdir \\sadc1sccmp1\osd\SettingsXfer\log\$env:USername\
 cpi c:\temp\*.log \\sadc1sccmp1\osd\SettingsXfer\log\$env:USername\

 }
 