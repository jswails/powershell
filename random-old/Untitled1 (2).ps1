if ( test-path "h:\usersettings\communicator\" )
{
cpi "$ENV:userprofile\AppData\Local\Microsoft\Communicator\sip*\*" h:\usersettings\communicator\
} else {
mkdir h:\usersettings\communicator
cpi "$ENV:userprofile\AppData\Local\Microsoft\Communicator\sip*\*" h:\usersettings\communicator\
}