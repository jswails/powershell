
$64chrome = "C:\Program Files (x86)\Google\Chrome\Application"
$32chrome = "C:\Program Files\Google\Chrome\Application"

if(test-path($64chrome)) {
#this is 64bit os
xcopy  "64\2015 Open Enrollment" "C:\Users\Public\Desktop\" /y
} else {
#this is 32bit os
xcopy "32\2015 Open Enrollment" "C:\Users\Public\Desktop\" /y
}