[Reflection.Assembly]::LoadWithPartialName( 'Microsoft.VisualBasic' ) | Out-Null

function InputBox( [string]$prompt, [string]$title, [string]$default )
{
     ( [string] ( [Microsoft.VisualBasic.Interaction]::InputBox( $prompt, $title, $default ) ) ).Trim()
}

function MsgBox( [string]$prompt, [string]$title, [int]$buttons )
{
     [int]([Microsoft.VisualBasic.Interaction]::MsgBox( $prompt, $buttons, $title ) )
}

$vbOK                  = 1
$vbCancel              = 2
$vbAbort               = 3
$vbRetry               = 4
$vbIgnore              = 5
$vbYes                 = 6
$vbNo                  = 7

$vbOKOnly              = 0
$vbOKCancel            = 1
$vbAbortRetryIgnore    = 2
$vbYesNoCancel         = 3
$vbYesNo               = 4
$vbRetryCancel         = 5

$vbCritical            = 16
$vbQuestion            = 32
$vbExclamation         = 48
$vbInformation         = 64

$vbError               = ( $vbOKOnly + $vbCritical ) ## this is mine and mine alone (not a standard value)

$vbDefaultButton1      = 0
$vbDefaultButton2      = 256
$vbDefaultButton3      = 512

$vbApplicationModal    = 0
$vbSystemModal         = 4096

$vbMsgBoxSetForeground = 65536
$vbMsgBoxRight         = 524288
$vbMsgBoxRtlReading    = 1048576

