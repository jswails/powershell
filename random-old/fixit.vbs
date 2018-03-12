Set objWMIService = GetObject("WinMgmts:{impersonationLevel=impersonate,AuthenticationLevel=pktprivacy}//" & "." & "\root\CIMV2\Security\MicrosoftTpm")

Set objItems = objWMIService.InstancesOf("Win32_Tpm")



For Each objItem In objItems



'rvaluea = objItem.IsEnabled(A)

'rvalueb = objItem.IsActivated(B)

'rvaluec = objItem.IsOwned(C)

rvalued = objItem.IsEndorsementKeyPairPresent(D)



'If A Then

'WScript.Echo "TPM Is Enabled: " & A

'Else

'WScript.Echo "TPM Is Enabled: " & A

'End If



'If B Then

'WScript.Echo "TPM Is Activated: " & B

'Else

'WScript.Echo "TPM Is Activated: " & B

'End If



'If C Then

'WScript.Echo "TPM Is Owned: " & C

'Else

'WScript.Echo "TPM Is Owned: " & C

'End If



'If D Then

'WScript.Echo "TPM Is EndorsementKeyPairPresent: " & D

'Else

If Not D Then

'WScript.Echo "TPM Is EndorsementKeyPairPresent: " & D

'WScript.Echo "CreateEndorsementKeyPair... Please Wait"

rvaluee = objItem.CreateEndorsementKeyPair(E)

'WScript.Echo "CreateEndorsementKeyPair... Returns:" & rvaluee & " and E=" & E

If (rvaluee <> 0) Then

WScript.Quit -1

End If

End If

Next
WScript.Quit 0

