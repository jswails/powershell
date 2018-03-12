(gci C:\scripts\audit\win7systemsOU).count
(gci C:\scripts\audit\win7machines-appsense).count
(gci C:\scripts\audit\win7systemstestou).count
(gci C:\scripts\audit\win7vdiou).count
(gci C:\scripts\audit\winxpvdiou).count
(gci C:\scripts\audit\winxpsystemsou).count

#243+11+12+52+664+117 1099

#119+258+15+11+54+760 1217

# 1046 scanned on thurs afternoon 6/13/13
# 1297 scanned on monday morning 6/17/13
#836 scanned on 6/24/13
# 906 scanned on 7/8/13
 # 1289 scanned on 7/10/2013
 # 1371 scanned on 7/22/13

findstr /v /c:"Domain Admins" 

gci .\* -include *.csv | select-string -pattern "sai" | select-string -pattern "user" | out-file -append C:\scripts\localadmins.txt
 
 $test = gci '\\sadc1cmadmp1\e$\wamp\bin\apache\Apache2.4.4\logs\access.log' | select-string -Pattern "exportdeploylog"
 $test.count
