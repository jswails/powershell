Sub AddNewComputer (connection, netBiosName, macAddress, collectionid)

  Dim inParams
  Dim outParams
  Dim siteClass
  Dim collection
  Dim collectionRule
  
  If (IsNull(smBiosGuid) = True) And (IsNull(macAddress) = True) Then
    WScript.Echo "smBiosGuid or macAddress must be defined"
    Exit Sub
  End If   

  If IsNull(macAddress) = False Then
    macAddress = Replace(macAddress,"-",":")
  End If  
  
  ' Obtain an InParameters object specific
  ' to the method.
  
  Set siteClass = connection.Get("SMS_Site")
  Set inParams = siteClass.Methods_("ImportMachineEntry"). _
    inParameters.SpawnInstance_()


  ' Add the input parameters.
  inParams.Properties_.Item("MACAddress") = macAddress
  inParams.Properties_.Item("NetbiosName") = netBiosName
  inParams.Properties_.Item("OverwriteExistingRecord") = False

  ' Add the computer.
  Set outParams = connection.ExecMethod("SMS_Site", "ImportMachineEntry", inParams)

  
  ' Add the computer to the all systems collection.
  set collection = connection.Get("SMS_Collection.CollectionID='" & collectionid & "'")
  
  set collectionRule=connection.Get("SMS_CollectionRuleDirect").SpawnInstance_
  
  collectionRule.ResourceClassName="SMS_R_System"
  collectionRule.ResourceID= outParams.ResourceID
    
  collection.AddMembershipRule collectionRule

End Sub
