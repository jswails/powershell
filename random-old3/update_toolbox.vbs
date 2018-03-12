Set objFso = CreateObject("Scripting.FileSystemObject")
Set objSh = CreateObject("WScript.Shell")

Set objArg = WScript.Arguments

If objArg.Count > 0 Then
	strFlag = Ucase(Trim(objArg.Item(0)))
End If

Set objArg = Nothing

strx86 = objSh.ExpandEnvironmentStrings("%ProgramFiles%") & "\State Auto Insurance\ToolBox"
if objFso.FolderExists (strx86) Then
strDst = strx86
 Else
 strDst = objSh.ExpandEnvironmentStrings("%ProgramFiles(x86)%") & "\State Auto Insurance\ToolBox"
End If
strSrc = "\\corp.stateauto.com\clientapps\Prod\SAToolbox\Win7_Toolbox"


If objFso.FolderExists (strSrc) Then
	If objFso.FolderExists (strDst) Then
		objFso.CopyFolder strSrc, strDst, True
		strLogMsg = "Toolbox was updated successfully at " & Now
		strLogEvent = 0
	Else
		strLogMsg = "Error updating ToolBox, could not find destination path " & strDst
		strLogEvent = 2
	End If
Else
	strLogMsg = "Error updating ToolBox, could not find source path " & strSrc
	strLogEvent = 1
End If
objSh.LogEvent strLogEvent, strLogMsg

If strFlag <> "/BOOT" Then
	If strLogEvent = 0 Then
		MsgBox "ToolBox was updated successfully. The Toolbox should refresh" & VbCrLf & "itself with any updates in a few seconds.",64,"ToolBox Updated Successfully"
	Else
		MsgBox "There was an error updating the ToolBox, please see" & VbCrLf & "Application Event Viewer for details.",16,"ToolBox Update Failed"
	End If
End If

Set objSh = Nothing
Set objFso = Nothing
