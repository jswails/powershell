$servername = "V23P1DC10015"
test-path \\$servername\c$\temp\logon.log
 xcopy "\\$servername\c$\temp\logon.log" "\\sadc1sccmp1\osd\logontimes\$datetime\$servername\"  