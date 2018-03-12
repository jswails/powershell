function Add-Zip
{
 param([string]$zipfilename)

 if(-not (test-path($zipfilename)))
 {
  set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
  (dir $zipfilename).IsReadOnly = $false 
 }
 
 $shellApplication = new-object -com shell.application
 $zipPackage = $shellApplication.NameSpace($zipfilename)
 
 foreach($file in $input) 
 { 
            $zipPackage.CopyHere($file.FullName)
            Start-sleep -milliseconds 500
 }
} 

$tools = "c:\temp\logbackup"
$datetime = Get-Date -Format "yyyyMMddHHmm"
# export logs to csv
get-eventlog -logname system | export-csv $tools\system.csv -notypeinformation
get-eventlog -logname application | export-csv $tools\application.csv -notypeinformation
get-eventlog -logname security | export-csv $tools\security.csv -notypeinformation


# execute the backup function
dir $tools\*.csv | add-zip $tools\$env:COMPUTERNAME-$datetime.zip
#if (test-path \\sadc1aspsd1\logs)
#{
#mkdir \\sadc1aspsd1\logs\$env:COMPUTERNAME

#copy $tools\*.zip \\sadc1aspsd1\logs\$env:COMPUTERNAME

#}