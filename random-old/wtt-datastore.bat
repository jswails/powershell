
for %i in (servers.txt) do (reg query \\%i\HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\WTTMobile /v DataStore)