$osettings = "h:\usersettings\outlook-settings"

if ( test-path $osettings )
{
cpi $env:APPDATA\microsoft\outlook\outcmd.dat $osettings 

cpi $env:APPDATA\microsoft\outlook\*.xml $osettings\xml

cpi $env:APPDATA\microsoft\outlook\*.nk2 $osettings\nk2

cpi $env:APPDATA\microsoft\Signatures\* $osettings\sig

cpi $env:APPDATA\microsoft\Uproof\* $osettings\dict 

cpi $env:APPDATA\microsoft\outlook\*.srs $osettings\srs
} else {

mkdir h:\usersettings\outlook-settings

$osettings = "h:\usersettings\outlook-settings"


cpi $env:APPDATA\microsoft\outlook\outcmd.dat $osettings 

cpi $env:APPDATA\microsoft\outlook\*.xml $osettings\xml

cpi $env:APPDATA\microsoft\outlook\*.nk2 $osettings\nk2

cpi $env:APPDATA\microsoft\Signatures\* $osettings\sig

cpi $env:APPDATA\microsoft\Uproof\* $osettings\dict 

cpi $env:APPDATA\microsoft\outlook\*.srs $osettings\srs
}