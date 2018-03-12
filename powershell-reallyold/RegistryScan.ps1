clear-host

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

function Ping-Server {
   Param([string]$server)
   $pingresult = Get-WmiObject win32_pingstatus -f "address='$Server'"
   if($pingresult.statuscode -eq 0) {$true} else {$false}
}

function Scan-Registry {
    $results = @()
    $retrun = ""| select text   
    $Value = $z
    get-Content "c:\temp2\Servers.txt" | % {
        $result = Ping-Server $_
        if($result){
            $srv = $_
            $key = $x
            $type = [Microsoft.Win32.RegistryHive]::LocalMachine
            $regKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($type, $Srv)
            $regKey = $regKey.OpenSubKey($key)
            if (!$regKey){
               $retrun = ""| select text
               $results += $retrun.text = "$srv , Fail, registry path does not exist!"
               write-host "$srv, Fail, registry path does not exist!"
            }
            else
            {
                $val = $regKey.getvalue($y)
                if ($val -eq $Value ){
                    $retrun = ""| select text
                    $results += $retrun.text = "$srv , Pass, correct value found, " + $val
                    write-host "$srv, Pass, correct value found, "  $val
                }
                else
                {
                    $retrun = ""| select text
                    $results += $retrun.text = "$srv , Fail, Wrong value found, " + $val
                    write-host "$srv, Fail, Wrong value found, "  $val
                }
            }
        }
        else
        {
            $retrun = ""| select text
            $results += $retrun.text = "$srv , Fail, no ping!"
            write-host "$srv, Fail, no ping!"
        }
    }
    $results
}

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Registry Scan"
$objForm.Size = New-Object System.Drawing.Size(840,300) 
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$x=$objRegKeyPath.Text;$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})
    
#OK button
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(420,220)
$OKButton.Size = New-Object System.Drawing.Size(75,25)
$OKButton.Text = "OK"
$OKButton.Add_Click({
    $x=$objRegKeyPath.Text
    $y=$objRegKey.Text
    $z=$objRegKeyValue.text
    Scan-Registry
    $objForm.Close()})
$objForm.Controls.Add($OKButton)

#Cancel button
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(495,220)
$CancelButton.Size = New-Object System.Drawing.Size(75,25)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

#reg key path label
$objRegKeyPathLabel = New-Object System.Windows.Forms.Label
$objRegKeyPathLabel.Location = New-Object System.Drawing.Size(10,20) 
$objRegKeyPathLabel.Size = New-Object System.Drawing.Size(800,20) 
$objRegKeyPathLabel.Text = "[local machine] registry path (SOFTWARE\Microsoft\Windows\CurrentVersion)"
$objForm.Controls.Add($objRegKeyPathLabel) 

#reg key path textbox
$objRegKeyPath = New-Object System.Windows.Forms.TextBox 
$objRegKeyPath.Location = New-Object System.Drawing.Size(10,40) 
$objRegKeyPath.Size = New-Object System.Drawing.Size(800,20) 
$objForm.Controls.Add($objRegKeyPath) 

#reg key label
$objRegKeyLabel = New-Object System.Windows.Forms.Label
$objRegKeyLabel.Location = New-Object System.Drawing.Size(10,65) 
$objRegKeyLabel.Size = New-Object System.Drawing.Size(800,20) 
$objRegKeyLabel.Text = "Key to search for (DisplayVersion)"
$objForm.Controls.Add($objRegKeyLabel) 

#reg key textbox
$objRegKey = New-Object System.Windows.Forms.TextBox 
$objRegKey.Location = New-Object System.Drawing.Size(10,85) 
$objRegKey.Size = New-Object System.Drawing.Size(800,20) 
$objForm.Controls.Add($objRegKey) 

#reg key value label
$objRegKeyValueLabel = New-Object System.Windows.Forms.Label
$objRegKeyValueLabel.Location = New-Object System.Drawing.Size(10,110) 
$objRegKeyValueLabel.Size = New-Object System.Drawing.Size(800,20) 
$objRegKeyValueLabel.Text = "Value you expect to find (3.0.04)"
$objForm.Controls.Add($objRegKeyValueLabel) 

#reg key value textbox
$objRegKeyValue = New-Object System.Windows.Forms.TextBox 
$objRegKeyValue.Location = New-Object System.Drawing.Size(10,135) 
$objRegKeyValue.Size = New-Object System.Drawing.Size(800,20) 
$objForm.Controls.Add($objRegKeyValue) 

$objForm.Topmost = $True

###Main###

#default text
$objRegKeyPath.Text = "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
$objRegKey.Text = "imgver"
$objRegKeyValue.Text = " "
   

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()

#$x
#$y
#$z



$results