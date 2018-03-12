$wipserver = "\\10.30.164.71\data-in"
$datetime = Get-Date -Format "yyyyMMdd";
$datetimem = Get-Date -Format "yyyyMMddmm";
$rowheaders = "machinename,appname,message,datetime,tech,os,processor,imgver,osmodel,status"
# this runs every 15 minutes on admin3 to check for updates in each status folder and to take those and combine them to 1 file to be moved over to area for rake task to process.

if (!(test-path("$wipserver\rake"))){
mkdir $wipserver\rake
}
#########################################################################################################
$rowheaders | out-file $wipserver\rake\imagingupload-tmp.csv
$latest = Get-ChildItem -Path $wipserver\imaging\upload
foreach ($path in $latest){
Get-Content "$wipserver\imaging\upload\$path" | out-file -Append $wipserver\rake\imagingupload-tmp.csv
ri -Path "$wipserver\imaging\upload\$path" -Force
}
get-content $wipserver\rake\imagingupload-tmp.csv | Set-Content $wipserver\rake\imagingupload.csv
ri -path $wipserver\rake\imagingupload-tmp.csv -force
#########################################################################################################

#findstr /V /C:"machine,sizemb,date" C:\temp\TYA87581-20150812.log > c:\temp\cleanedfile.txt

$wipserver = "c:\temp"
$rowheaders = "machinename,appname,message,datetime,tech,os,processor,imgver,osmodel,status"
$latest = Get-ChildItem -Path $wipserver\cleanup
$rowheaders | out-file $wipserver\rake\cleanup-tmp.csv
foreach ($path in $latest){
findstr /V /C:"machine,sizemb,datetime" "$wipserver\cleanup\$path" > "$wipserver\cleanup1\$path"
Get-Content "$wipserver\cleanup1\$path" | out-file -Append $wipserver\rake\cleanup-tmp.csv

}
get-content $wipserver\rake\cleanup-tmp.csv | Set-Content $wipserver\rake\cleanup.csv
