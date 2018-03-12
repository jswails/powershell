

REM set the following line to the network or memory key location to where you exported the user's settings.
set d=\\sadc1sccmp1\osd\SettingsXfer\outlook_settings\%username%

REM Command Bar and Menu Customizations
copy "%d%\outcmd.dat" "%appdata%\Microsoft\Outlook"

REM Navigation Pane settings
copy "%d%\xml\*.xml" "%appdata%\Microsoft\Outlook"

REM Contacts AutoComplete
copy "%d%\nk2\*.nk2" "%appdata%\Microsoft\Outlook"

REM Signatures
if not exist "%appdata%\Microsoft\Signatures" md "%appdata%\Microsoft\Signatures"
copy "%d%\sig\*.*" "%appdata%\Microsoft\Signatures"

REM Dictionaries
copy "%d%\dict\*.*" "%appdata%\Microsoft\UProof"

REM SendRecieve Settings
copy "%d%\srs\*.srs" "%appdata%\Microsoft\Outlook"