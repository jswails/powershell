configuration EnableWMILog

{

    $Server = @('s1','s2')

    Import-DscResource -module "C:\Program Files (x86)\WindowsPowerShell\Modules\DSC_Resource_Kit_Wave_9_12172014\All Resources\xWinEventLog\xWinEventLog"

    $logname = "Microsoft-Windows-WMI-Activity/Operational"

    node $Server

    {

        xWinEventLog WMILog

        {

            LogName            = $logname

            IsEnabled          = $true

            LogMode            = "AutoBackup"

            MaximumSizeInBytes = 2mb

        }

    }

}

EnableWMILog -OutputPath c:\DSC\WMILog

Start-DscConfiguration -Path C:\DSC\WMILog -Verbose -wait -debug

