$proc = $env:PROCESSOR_ARCHITECTURE
if($proc = "x86")
{
mkdir c:\temp\appsense\upgrade
robocopy \\sadc1asmcd1\Software\Upgrade\Agents\32bit c:\temp\appsense\upgrade
pushd c:\temp\appsense\upgrade
msiexec.exe /i  ApplicationManagerAgent32.msi /q /norestart
# this is the SP2 patch along with the SP1 agent
msiexec.exe /i  EnvironmentManagerAgent32.msi PATCH=EnvironmentManagerAgent32.msp /q /norestart
msiexec.exe /i  PerformanceManagerAgent32.msi /q /norestart

msiexec.exe /i  ClientCommunicationsAgent32.msi /q
popd
shutdown -r -t 10
}
$proc = $env:PROCESSOR_ARCHITECTURE
if($proc = "x64")
{
mkdir c:\temp\appsense\upgrade
robocopy \\sadc1asmcd1\Software\Upgrade\64bit c:\temp\appsense\upgrade
pushd c:\temp\appsense\upgrade
msiexec.exe /i  ApplicationManagerAgent64.msi /q /norestart
# this is the SP2 patch along with the SP1 agent
msiexec.exe /i  EnvironmentManagerAgent64.msi PATCH=EnvironmentManagerAgent64.msp /q /norestart
msiexec.exe /i  PerformanceManagerAgent64.msi /q /norestart

msiexec.exe /i  ClientCommunicationsAgent64.msi /q
popd
shutdown -r -t 10
}