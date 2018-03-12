 $y = Get-Date 

$5dprev = $y.AddDays(-7)
$x = $5dprev.ticks

$log = "e:\wamp\www\ApacheSiteHits\current.txt"
if(test-path ("e:\wamp\www\ApacheSiteHits\current.txt"))
{
Rename-Item -path "e:\wamp\www\ApacheSiteHits\current.txt" -newname $x
}
Add-Content $log "$y"
Add-Content $log " ##############################################################################" 
Add-Content $log " #####  Admin Site #########################################"
Add-Content $log " ##############################################################################"

 $reporting = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "reporting"
 $r = $reporting.count 
Add-Content $log " Reporting Site = $r"
 
  $searchcoll = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "searchcoll"
  $s = $searchcoll.count
Add-Content $log " Search Collections Site = $s" 

  $delete = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "delete"
  $d = $delete.count
 Add-Content $log " Delete Machines Site = $d" 

  $multiapp = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "multidisplay"
  $m = $multiapp.count
 Add-Content $log " Multiapp Deploy Site = $m"

  $multimachine = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "multimachinedisplay"
  $mu = $multimachine.count
 Add-Content $log " MultiMachine Deploy Site = $mu" 

  $removecoll = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "rmachcoll"
  $re = $removecoll.count
 Add-Content $log " Remove Machine from Collections Site = $re"

  $exportdeletelog = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "exportdeleted"
  $ex = $exportdeletelog.count
 Add-Content $log " Export Deleted Log Site = $ex"

   $exportuserslog = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "exportuserslog"
   $exp = $exportuserslog.count
 Add-Content $log " Export Users Log Site = $exp"

   $exportdeploylog = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "exportdeploylog"
   $expo = $exportdeploylog.count
 Add-Content $log " Export Deploy Log Site = $expo"

    $updatecoll = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "updatecollections"
    $update = $updatecoll.count
 Add-Content $log " Update Collections Site = $update"

     $scanwmi = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "scan-0"
     $scan = $scanwmi.count
 Add-Content $log " Scan WMI of machine Site = $scan"

      $logout = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "logout"
      $l = $logout.count
 Add-Content $log " Logout Site = $l" 

 Add-Content $log " ##############################################################################"
Add-Content $log " #####  Main Site #########################################"
Add-Content $log " ##############################################################################"

      $index = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "index"
      $in = $index.count
 Add-Content $log " Entry Page Site = $in" 

       $logonmain = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "logondata.html"
       $lm = $logonmain.count
 Add-Content $log " Logon Data Main Site = $lm"
  
       $logondata = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "logondata.php"
       $ld = $logondata.count
 Add-Content $log " Logon Data Computer Site = $ld" 
   
       $logonuser = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "logondatauser.php"
       $lu = $logonuser.count
 Add-Content $log " Logon Data User Site = $lu"
 
       $mail = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "mail.php"
       $maillog = $mail.count
 Add-Content $log " WirelessMac from Email Site = $maillog"

        $syncerror = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "syncerrorsite.html"
        $synce = $syncerror.count
 Add-Content $log " Syncerror Site = $synce"

        $dupdocs = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "dupdocsync.php"
        $dup = $dupdocs.count
 Add-Content $log " Duplicate Documents Site = $dup"
 
       $searchlogs = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "searchlogs.html"
       $sear = $searchlogs.count
 Add-Content $log " Search Logs Main Site = $sear"

         $eventlog = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "eventlog.php"
         $even = $eventlog.count
 Add-Content $log " Event Logs Site = $even"

        $searchce = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "searchce.php"
        $seach = $searchce.count
 Add-Content $log " Search CE Site = $seach"

        $time = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "time.php"
        $ti = $time.count
 Add-Content $log " Time Zones Site = $ti"

        $searchlogs = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "searchlogs.html"
        $slogs = $searchlogs.count
 Add-Content $log " Search Logs Main Site = $slogs" 

        $asmachine = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "asmachinesquery"
        $asm = $asmachine.count
 Add-Content $log " Find Appsense Machines Site = $asm" 

         $clientsupport = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "clientsupportutil"
         $cls = $clientsupport.count
 Add-Content $log " Client Support Utility Site = $cls" 

         $listspeed = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "listspeedtest"
         $lists = $listspeed.count
 Add-Content $log " List Speed Test Site = $lists" 

         $localadmin = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "localadmin"
         $localad = $localadmin.count
 Add-Content $log " Local Admin Site = $localad" 