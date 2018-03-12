#start the toaster

# get the name of user requesting from file tom creates with task sequence
# install spectare
# call image portion of spectare
#this allows for recovery from reboots
# gather up standard info
#  
# or as i had thought before have the script treat every piece of install as an appname and process them all accordingly in a csv file to be imported
# so then it would enter in db as being installed that day and can track software installs 
#email user using ad script to find their email if no email send to desktop support
# put status on imaging page

# task sequence calls spectare install package first
 $rowheaders = "machinename,appname,message,datetime,tech,os,processor,imgver,osmodel,status"
 $smdir =  "C:\Packages\scriptmonitor"
 $datetime = Get-Date -Format "yyyyMMdd";
 $datetimefull = Get-Date -Format "yyyyMMddHHmmss";
 $configroot = "\\admin3\scriptmonitor"
 $datetime | Out-File -append $smdir\bug.log
 $machinename = $env:COMPUTERNAME
 $err = ""
 $wipserver = "\\10.30.164.71\data-in"
 $sccmexeclog = "c:\windows\ccm\logs\execmgr.log"
 $os = (Get-CimInstance Win32_OperatingSystem).version
 $proc = $env:PROCESSOR_ARCHITECTURE
 $imgver = [Environment]::GetEnvironmentVariable("imgver","machine")
 $tsver =  [Environment]::GetEnvironmentVariable("BuildTS","machine")
 $model = (Get-WmiObject Win32_Computersystem).model
  $status = $tsver
 $tech = Get-Content $wipserver\imaging\$datetime\$machinename\user.config
 "imaging check starts" | Out-File -append $smdir\bug.log
 if(!(Test-Path("$sccmexeclog"))){
if(!(Test-Path("$wipserver\nosccmclient"))){
mkdir $wipserver\nosccmclient
}
"sccm client not installed" | Out-File -Append $smdir\bug.log
$err = " No SCCM Client Installed"
"$machinename,n\a,$err,$datetimefull,n\a,$os,$proc,$imgver,$model,$status" | out-file $smdir\$datetime.nosccmclient
Get-Content $smdir\$datetime.nosccmclient | Set-Content \\10.30.164.71\data-in\nosccmclient\$env:COMPUTERNAME-$datetime.nosccmclient
exit}

 if(!(test-path($smdir))){mkdir $smdir }
   c:\Windows\System32\wbem\mofcomp.exe "c:\packages\scriptmonitor\productslist.mof"
   $displayconfig = gwmi -Namespace root\default sampleproductslist32 
   $err = "Imaging"
   if($tech -eq $null){
   $tech = "desktopsupport@stateauto.com"
   } else {

   $Search = New-Object DirectoryServices.DirectorySearcher([ADSI]“”)
$Search.filter = “(&(objectClass=user)(sAMAccountName=$tech))”
$results = $Search.Findall()
Foreach($result in $results){
$User = $result.GetDirectoryEntry()
$tech = $user.mail
}
}
   foreach ($scriptus in $displayconfig){
   $appname = $scriptus.displayname
   "$machinename,$appname,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,$status" | out-file -Append $smdir\qa.csv
      }
      "qa file written" | Out-File -append $smdir\bug.log
      Get-Content $smdir\qa.csv | set-content $wipserver\imaging\upload\$machinename-$datetime-qa.csv
      "write out tech address" | Out-File -append $smdir\bug.log
$tech | Out-File -append $smdir\bug.log

  ################## email ###############################################
      $messageparameters = @{
  Subject = "ADMIN3 Notification ## $env:COMPUTERNAME - Imaging Complete"
  body = "Computer: $env:COMPUTERNAME </br>Date: $datetime </br><a href='http://10.30.164.71:3000/imaging>Imaging Status</a></br>"
  from = "john.swails@stateauto.com"
  to = "john.swails@stateauto.com"
  smtpserver = "outlookdc1.corp.stateauto.com"
  }
  
  send-mailmessage @messageparameters -bodyashtml
  "email sent" | Out-File -append $smdir\bug.log
  ################################################################################################    

  $appname = "Image"
  $err = "Image Done"
  $status = $tsver
     "$machinename,$appname,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,$status" | set-content $wipserver\imaging\status\$machinename-$datetime.csv