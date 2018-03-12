#created on 10/27/2015
#written by John Swails but function was from internet search.
# this will run once a week to get updates about current monitor situation

Function Get-MonitorInfo
{
    [CmdletBinding()]
    Param
    (
        [Parameter(
        Position=0,
        ValueFromPipeLine=$true,
        ValueFromPipeLineByPropertyName=$true)]
        [alias("CN","MachineName","Name","Computer")]
        [string[]]$ComputerName = $ENV:ComputerName
    )

    Begin {
        $pipelineInput = -not $PSBoundParameters.ContainsKey('ComputerName')
    }

    Process
    {
        Function DoWork([string]$ComputerName) {
            $ActiveMonitors = Get-WmiObject -Namespace root\wmi -Class wmiMonitorID -ComputerName $ComputerName
            $monitorInfo = @()

            foreach ($monitor in $ActiveMonitors)
            {
                $mon = $null

                $mon = New-Object PSObject -Property @{
                ManufacturerName=($monitor.ManufacturerName | % {[char]$_}) -join ''
                ProductCodeID=($monitor.ProductCodeID | % {[char]$_}) -join ''
                SerialNumberID=($monitor.SerialNumberID | % {[char]$_}) -join ''
                UserFriendlyName=($monitor.UserFriendlyName | % {[char]$_}) -join ''
                ComputerName=$ComputerName
                WeekOfManufacture=$monitor.WeekOfManufacture
                YearOfManufacture=$monitor.YearOfManufacture}

                $monitorInfo += $mon
            }
            Write-Output $monitorInfo
        }

        if ($pipelineInput) {
            DoWork($ComputerName)
        } else {
            foreach ($item in $ComputerName) {
                DoWork($item)
            }
        }
    }
}
Get-MonitorInfo 
if(!(test-path("C:\Packages\logonscript"))){
mkdir "C:\Packages\logonscript"
}
 $logondir =  "C:\Packages\logonscript"
$getmon = Get-MonitorInfo
if (Test-Path("C:\Packages\$logondir\monitors.txt")){
ri C:\Packages\$logondir\monitors.txt
}
foreach ( $mon in $getmon){
$mon.SerialNumberID | out-file -Append $logondir\monitor.txt
}



