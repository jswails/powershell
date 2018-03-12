   Param([string]$message)
   $rowheaders = "machinename,appname,message,datetime,tech,os,processor,imgver,osmodel,status,location,deploystat,mac,ip"
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
  $logonserver = $env:LOGONSERVER
 $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $machinename |Where{$_.IpEnabled -Match "True"}  
      foreach ($objItem in $colItems) {  
    $objItem |select Description,MACAddress  
    $writemac = $objItem |select Description,MACAddress  
       $ip = $objItem.IPAddress | Select-Object -First 1
   } 
    $mac = $writemac.MACAddress
if($logonserver -eq $null) {
$logonserver = $ip}
 
 $deploystat = "in-progress"
  if ($tsver -eq $null){
  $tsver = "na"
  }
  $tech = "sccm"
  if ($imgver -eq $null){
  $imgver = "na"
  }

   $appname = "Image"
  $err = $message
  $status = $tsver
     "$machinename,$appname,$err,$datetimefull,$tech,$os,$proc,$imgver,$model,$status,$logonserver,$deploystat,$mac,$ip" | set-content $wipserver\imaging\status\$machinename-$datetime.csv