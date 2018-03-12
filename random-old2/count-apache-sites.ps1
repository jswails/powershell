Write-host " ##############################################################################"
write-host " #####  Admin Site #########################################"
write-host " ##############################################################################"

 $reporting = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "reporting"
 write-host " Reporting Site = " $reporting.count

  $searchcoll = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "searchcoll"
 write-host " Search Collections Site = " $searchcoll.count

  $delete = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "delete"
 write-host " Delete Machines Site = " $delete.count

  $multiapp = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "multidisplay"
 write-host " Multiapp Deploy Site = " $multiapp.count

  $multimachine = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "multimachinedisplay"
 write-host " MultiMachine Deploy Site = " $multimachine.count

  $removecoll = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "rmachcoll"
 write-host " Remove Machine from Collections Site = " $removecoll.count

  $exportdeletelog = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "exportdeleted"
 write-host " Export Deleted Log Site = " $exportdeletelog.count

   $exportuserslog = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "exportuserslog"
 write-host " Export Users Log Site = " $exportuserslog.count

   $exportdeploylog = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "exportdeploylog"
 write-host " Export Deploy Log Site = " $exportdeploylog.count

    $updatecoll = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "updatecollections"
 write-host " Update Collections Site = " $updatecoll.count

     $scanwmi = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "scan-0"
 write-host " Scan WMI of machine Site = " $scanwmi.count

      $logout = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "logout"
 write-host " Logout Site = " $logout.count

 Write-host " ##############################################################################"
write-host " #####  Main Site #########################################"
write-host " ##############################################################################"

      $index = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "index"
 write-host " Entry Page Site = " $index.count

       $logonmain = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "logondata.html"
 write-host " Logon Data Main Site = " $logonmain.count

 
       $logondata = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "logondata.php"
 write-host " Logon Data Computer Site = " $logonmain.count
  
       $logonuser = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "logondatauser.php"
 write-host " Logon Data User Site = " $logonuser.count
 
       $mail = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "mail.php"
 write-host " WirelessMac from Email Site = " $mail.count

        $syncerror = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "syncerrorsite.html"
 write-host " Syncerror Site = " $syncerror.count

        $dupdocs = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "dupdocsync.php"
 write-host " Duplicate Documents Site = " $dupdocs.count
 
       $searchlogs = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "searchlogs.html"
 write-host " Search Logs Main Site = " $searchlogs.count

         $eventlog = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "eventlog.php"
 write-host " Event Logs Site = " $eventlog.count

        $searchce = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "searchce.php"
 write-host " Search CE Site = " $searchce.count

        $time = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "time.php"
 write-host " Time Zones Site = " $time.count

        $searchlogs = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "searchlogs.html"
 write-host " Search Logs Main Site = " $searchlogs.count

        $asmachine = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "asmachinesquery"
 write-host " Find Appsense Machines Site = " $asmachine.count

         $clientsupport = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "clientsupportutil"
 write-host " Client Support Utility Site = " $clientsupport.count

         $listspeed = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "listspeedtest"
 write-host " List Speed Test Site = " $listspeed.count

         $localadmin = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "localadmin"
 write-host " Local Admin Site = " $localadmin.count