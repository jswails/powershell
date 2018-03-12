Public objLogin, objFso, objLocator, objNet, objUser, strLogPath, strLoginMessage, strUserName, strComputer, strLoginError, objSh, strLoginEventMsg, strColumbusDisaster, strIndyDisaster, strLogonServer, strProfile

Set objNet = CreateObject("wscript.network")
Set objSh = CreateObject("wscript.shell")

strUserName = UCase(objNet.UserName)
strDomain = objNet.UserDomain
strComputer = objNet.ComputerName

' *********************************
' Disaster Recovery Switches:
' 		strColumbusDisaster: Change this to True if Columbus is down.
'		strIndyDisaster: Change this to True if Indianapolis is down.
'
'		To change the value of one of these settings, comment out the line that equals False by
'		inserting a single quote as the 1st character of the line (usually under the double quote
'		on standard QWERTY keyboards). Then uncomment the True line by deleting the leading single
'		quote and saving the script.
' *********************************
strColumbusDisaster = False
'strColumbusDisaster = True
strIndyDisaster = False
'strIndyDisaster = True

Set objFso = CreateObject("scripting.filesystemobject")
Set objLocator = CreateObject("WbemScripting.SWbemLocator")

If IsServer = True Then
	Call ProcessServerLogin
	Set objNet = Nothing
	Set objSh = Nothing
	WScript.quit(1)	' This is a Server, stop login processing
End If

On Error Resume Next
Set objLogin = CreateObject("Loginscreen.Main")
If Err.number Then
	strLoginError = True
End If
err.clear
On Error GoTo 0

Set objEnv = objSh.Environment("PROCESS")
strLogonServer = objEnv("LOGONSERVER")
strAppData = objEnv("APPDATA")
strSystemRoot = objEnv("SYSTEMROOT")
strProfile = objEnv("USERPROFILE")
strHome = objEnv("HOMEDRIVE") & objEnv("HOMEDIR")
strImgVer = objEnv("imgver")
Set objEnv = Nothing



' The following objects cannot be constructed until this point
Set objIp = New Ip
Set objUser = New User
Set objComp = New Comp

Call OpenLoginBox
Call UpdateLoginBox("Welcome " & strUserName & vbCRLF & "Logging in to the " & strDomain & " domain via server " & strLogonServer & VbCrLf & " ")

WScript.Sleep 1000

Call UpdateLoginBox("IP Information for computer " & strComputer & ":" & VbCrLf & "Address: " & objIp.address & VbCrLf & "SubNet Mask: " & objIp.subnet & VbCrLf & "Gateway: " & objIp.gateway & VbCrLf & " ")
Call UpdateLoginBox("Found Monitor serial number " & objComp.Monitor_Serial)
Call UpdateLoginBox("Found Operating System " & objComp.ostype & VbCrLf & " ")



Call UpdateLoginBox("")

' Process websense registration
Call ProcessWebSense

' Fix StartExceed Attributes to clear read-only if set
 ' Call FixStartExceedAttributes

' Call RemoveFile(strFrmCachePath,"Cleared Microsoft Outlook Forms Cache.")
' Call RemoveFile(strExtendDatPath,"Cleared Microsoft Outlook Extend.dat file.")
' Call CleanOLKFiles


  If strColumbusDisaster = False Then
	Call WriteLog(objIp.address, strComputer, strUsername, strDomain, strLogonServer, objComp.ostype, objComp.installdate, objComp.Monitor_Serial, StrImgVer)
End If

Call WriteEvent


Call CloseLoginBox
Set objLocator = Nothing
Set objSh = Nothing
Set objFso = Nothing
set objLogin = Nothing

Sub OpenLoginBox
	If Not(strLoginError) Then
		objLogin.NoImage
		objLogin.SetWelcomeMessage("                        Welcome to State Auto Insurance.")
		objLogin.SetWaitMessage("Logging in, please wait...")
			objLogin.SetDisplayMessage("")
		objLogin.SetTitle("")
		objLogin.NoPBar
		objLogin.Start
	End If
End sub

Sub CloseLoginBox
	If Not(strLoginError) Then
		objLogin.Kill
	End If
End Sub

Sub UpdateLoginBox(strMsg)
	strLoginMessage = strLoginMessage & strMsg
	strLoginEventMsg = strLoginEventMsg & strMsg
	If Not(strLoginError) Then
		strLoginMessage = Slice(strLoginMessage,7)
		objLogin.SetDisplayMessage(strLoginMessage)
	End If
	strLoginMessage = strLoginMessage & VbCrLf
	strLoginEventMsg = strLoginEventMsg & VbCrLf
End Sub

Function IsServer
	On Error Resume next
	isserver = False ' default assumption
	value = UCase(Trim(objSh.regread("HKLM\SYSTEM\CurrentControlSet\Control\ProductOptions\ProductType")))
	Select Case value
		Case "LANMANNT", "SERVERNT"
			IsServer = True
		Case "WINNT"
			IsServer = False
		Case Else
			IsServer = False
	End Select
	err.clear
	On Error GoTo 0
End Function



Function IsMember(gp)
	If InStr(lcase(trim(objUser.groups)),LCase(Trim(gp))) Then
		IsMember = True
	Else
		IsMember = False
	End If
End Function



Sub WriteLog(ipa, cna, una, udo, lsr, ost, isd, mos, sys)
	On Error Resume Next
	monary = Split(mos," ")
	mon1 = monary(1)
	If UBound(monary)=0 Then
		mon1 = monary(0)
	End If
	If UBound(monary)>1 Then
		mon2 = monary(2)
	Else
		mon2 = ""
	End If
	sConnect = "driver={sql server};server=sacolsqlp4;Database=Login Tracking;"
	Set conn1 = CreateObject("ADODB.Connection")
	conn1.ConnectionString = sConnect
	conn1.ConnectionTimeout = 15
	conn1.CommandTimeout = 30
	conn1.Open
	Set cmd = CreateObject("ADODB.Command")
	With cmd
		.ActiveConnection = conn1
		.CommandText = "InsertLoginLog2"
		.CommandType = &H0004
		.Parameters("@PCName") = trim(ucase(cna))
		.Parameters("@NetID") = trim(ucase(una))
		.Parameters("@AuthServer") = Trim(UCase(lsr))
		.Parameters("@DomainName") = Trim(UCase(udo))
		.Parameters("@IPAddress") = Trim(ipa)
		.Parameters("@PCsOS") = Trim(ost)
		.Parameters("@OSStreamVer") = Trim(sys)
		.Parameters("@InstallDate") = trim(isd)
		.Parameters("@MonSerial") = Trim(mon1)
		.Parameters("@MonSerial2") = Trim(mon2)
		set rsDC = .Execute
	End With
	Set cmd = Nothing
	Set conn1 = Nothing
	Err.clear
	Call UpdateLoginBox("Logged interactive login to SQL...")
	On Error GoTo 0
End Sub

Sub WriteEvent
	objSh.logevent 4, strLoginEventMsg
End Sub

Class User
	private objUsr, ntgroups

	Private Sub Class_Initialize
		Set objUsr = GetObject("WinNT://" & strDomain & "/" & strUserName & ",user")
		ntgroups = ""
		For Each prop In objUsr.groups
			ntgroups = ntgroups & "[" & Trim(UCase(prop.name)) & "]"
		Next
	End Sub
	
	Private Sub Class_Terminate
		Set objUsr = Nothing
	End Sub

	Public Property Get groups
		groups = ntgroups
	End Property
	
	Public Property Get home
		home = objUsr.HomeDirectory
	End Property
End Class
	
Class Ip
    Private pr_gw, pr_sn, pr_ad, pr_hn, pr_dn, des, fdr, pdr, tdr, ist, tzn, lsrv

    Private Sub Class_Initialize
        Set objservice = objLocator.connectserver
        '
        ' define the WMI query
        '
        query = "select ipaddress, dnshostname, dnsdomain, ipsubnet, defaultipgateway from win32_networkadapterconfiguration"
        '
        ' Execute the query and create the objInstance object
        '
        Set objinstance = objservice.execquery(query)
        For Each item In objinstance
                if buildItemString(item.ipaddress) <> "N/A" And buildItemString(item.ipaddress) <> "0.0.0.0" then
                pr_ad = buildItemString(item.ipaddress)
                pr_hn = item.dnshostname
                pr_dn = item.dnsdomain
                pr_sn = buildItemString(item.ipsubnet)
                pr_gw = buildItemString(item.defaultipgateway)
            End If
        Next
    End Sub

    Private Sub Class_Terminate
        Set objinstance = Nothing
        Set objservice = Nothing
        Set objenv = Nothing
    End Sub
    
    Private Function buildItemString(aItems)

     '
     ' Accepts an array or string and returns an HTML string containing breaks <br> after
     ' each string. Used where more than one value is returned from a WMI property
     '

        Dim objItem
        Dim tempString
        Dim i
        Dim arraySize
        Dim blnFlag
            If IsNull(aItems) Then
                   tempString = "N/A"
            Elseif IsArray(aItems) Then
                For i = 0 To UBound(aItems)
                        If aItems(i) <> "" or not isnull(aItems(i)) Then
                             blnFlag = True
                        End If
                Next
                arraySize = UBound(aItems)
                If blnFlag Then
                        For i = 0 To UBound(aItems)
                         If arraySize <> i Then
                         tempString = tempString & aItems(i) & chr(13)
                         Else
                         tempString = tempString & aItems(i)
                         End If
                        Next
                   Else
                        tempString = "N/A"
                   End If
            Else
                tempString = aItems
            End If
		' Modification 12/13/2006 by Neil Toepfer - just return the 1st IP address
		if instr(tempString,vbcr) then
			xt1 = instr(tempString,vbcr)
			tempstring = left(tempString,xt1)
		end if

		If Right(Trim(LCase(tempString)), 1) = Chr(13) Then
            tempString = Left(Trim(tempString), Len(Trim(tempString)) - 1)
        Else
            tempString = Trim(tempString)
        End If
        buildItemString = tempString
    End Function
    
    Public Property Get address
        address = pr_ad
    End Property

    Public Property Get subnet
        subnet = pr_sn
    End Property

    Public Property Get gateway
        gateway = pr_gw
    End Property

    Public Property Get host
        host = lcase(pr_hn)
    End Property

    Public Property Get domain
        domain = pr_dn
    End Property
End Class

Class Comp
	Private osver,spver,installd,monser,strType
	
	Private Sub class_initialize
		For Each os In GetObject("winmgmts:").InstancesOf("Win32_OperatingSystem")
			osver = os.Caption
			spver = os.ServicePackMajorVersion
			installd = os.InstallDate
			ver = os.Version
		Next

		If (IsVMWare = False) And (IsServer = False) then
		'''''''''''''''''''''''''''
		' Monitor EDID Information'
		'''''''''''''''''''''''''''
		'17 June 2004
		'coded by Michael Baird
		'
		'Modified by Denny MANSART (27/07/2004)
		'
		'and released under the terms of GNU open source license agreement
		'(that is of course if you CAN release code that uses WMI under GNU)
		'
		'Please give me credit if you use my code

		'this code is based on the EEDID spec found at http://www.vesa.org
		'and by my hacking around in the windows registry
		'the code was tested on WINXP,WIN2K and WIN2K3
		'it should work on WINME and WIN98SE
		'It should work with multiple monitors, but that hasn't been tested either.

		Dim oDisplaySubKeys : Set oDisplaySubKeys = CreateObject("Scripting.Dictionary")
		Dim oRawEDID : Set oRawEDID = CreateObject("Scripting.Dictionary")
		Const HKLM = &H80000002 'HKEY_LOCAL_MACHINE

		Int intMonitorCount=0
		Int intDisplaySubKeysCount=0
		Int i=0

		Set oRegistry = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "/root/default:StdRegProv")
		strDisplayBaseKey = "SYSTEM\CurrentControlSet\Enum\DISPLAY\"

		' Retrieving EISA-Id from HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY and storing in strarrDisplaySubKeys
		iRC = oRegistry.EnumKey(HKLM, strDisplayBaseKey, strarrDisplaySubKeys)

		' Deleting from strarrDisplaySubKeys "Default_Monitor" value
		For Each sKey In strarrDisplaySubKeys
			If sKey ="Default_Monitor" Or sKey = "" Then
				' Skip
			Else
				If oDisplaySubKeys.Exists(sKey) Then
					' Duplicate, skip
				Else
					oDisplaySubKeys.add sKey, intDisplaySubKeysCount
					intDisplaySubKeysCount=intDisplaySubKeysCount + 1
				End If
			End If
		Next

		' Storing result in oDisplaySubKeys
		strResultDisplaySubKeys=oDisplaySubKeys.Keys
		toto=0

		For i = 0 to oDisplaySubKeys.Count -1
			strEisaIdBaseKey = strDisplayBaseKey & strResultDisplaySubKeys(i) & "\"

			' Retrieving Pnp-Id from HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\EISA-Id and storing in strarrEisaIdSubKeys
			iRC2 = oRegistry.EnumKey(HKLM, strEisaIdBaseKey, strarrEisaIdSubKeys)

			For Each sKey2 In strarrEisaIdSubKeys
				oRegistry.GetMultiStringValue HKLM, strEisaIdBaseKey & sKey2 & "\", "HardwareID", sValue
				For tmpctr=0 To UBound(svalue)
					If lcase(Left(svalue(tmpctr),8))="monitor\" then
						strMsIdBaseKey = strEisaIdBaseKey & sKey2 & "\"
						iRC3 = oRegistry.EnumKey(HKLM, strMsIdBaseKey, strarrMsIdSubKeys)
						For Each sKey3 In strarrMsIdSubKeys
							If skey3="Control" then
								toto=toto + 1
								oRegistry.GetBinaryValue HKLM, strMsIdBaseKey & "Device Parameters\", "EDID", intarrEDID
								' Test file
								'Dim objFileSystem, objOutputFile
								'Dim strOutputFile
								'Set objFileSystem = CreateObject("Scripting.fileSystemObject")
								'strOutputFile = "C:/temp/" & Split(WScript.ScriptName, ".")(0) & "-" & toto & ".txt"
								'Set objOutputFile = objFileSystem.CreateTextFile(strOutputFile, TRUE)
								'objOutputFile.WriteLine(strMsIdBaseKey & "Device Parameters\" & "EDID")

								' Reinitializing string to null to clear all datas
								strRawEDID=""
								strRawEDIDb=""

								If vartype(intarrEDID) = 8204 then
									For each strByteValue in intarrEDID
										strRawEDID=strRawEDID & Chr(strByteValue)
										strRawEDIDb=strRawEDIDb & Chr(strByteValue)
										' Test file
										'objOutputFile.WriteLine(strRawEDIDb)
									Next
								Else
									strRawEDID="EDID Not Available"
								End If
								' Test file
								'objOutputFile.WriteLine(strRawEDIDb)
								'objOutputFile.Close
								'Set objFileSystem = Nothing

								oRawEDID.add intMonitorCount , strRawEDID
								intMonitorCount=intMonitorCount + 1
							End If
						Next
					End If
				Next
			Next 
		Next

		'*****************************************************************************************
		'now the EDID info For each active monitor is stored in an dictionnary of strings called oRawEDID
		'so we can process it to get the good stuff out of it which we will store in a 5 dimensional array
		'called arrMonitorInfo, the dimensions are as follows:
		'0=VESA Mfg ID, 1=VESA Device ID, 2=MFG Date (M/YYYY),3=Serial Num (If available),4=Model Descriptor
		'5=EDID Version
		'*****************************************************************************************

		strResultRawEDID=oRawEDID.Keys

		dim arrMonitorInfo()
		redim arrMonitorInfo(intMonitorCount-1,5)
		dim location(3)

		' Test file
		'Set objFileSystem = CreateObject("Scripting.fileSystemObject")
		'strOutputFile = "C:/temp/" & Split(WScript.ScriptName, ".")(0) & "-test.txt"
		'Set objOutputFile = objFileSystem.CreateTextFile(strOutputFile, TRUE)

		For i=0 to oRawEDID.Count - 1
			If oRawEDID(i) <> "EDID Not Available" then
				'*********************************************************************
				'first get the model and serial numbers from the vesa descriptor
				'blocks in the edid. the model number is required to be present
				'according to the spec. (v1.2 and beyond)but serial number is not
				'required. There are 4 descriptor blocks in edid at offset locations
				'&H36 &H48 &H5a and &H6c each block is 18 bytes long
				'*********************************************************************

				location(0)=mid(oRawEDID(i),&H36+1,18)
				location(1)=mid(oRawEDID(i),&H48+1,18)
				location(2)=mid(oRawEDID(i),&H5a+1,18)
				location(3)=mid(oRawEDID(i),&H6c+1,18)

				' Test file
				'objOutputFile.WriteLine("Location-0")
				'objOutputFile.WriteLine(location(0))
				'objOutputFile.WriteLine("Location-1")
				'objOutputFile.WriteLine(location(1))
				'objOutputFile.WriteLine("Location-2")
				'objOutputFile.WriteLine(location(2))
				'objOutputFile.WriteLine("Location-3")
				'objOutputFile.WriteLine(location(3))

				'you can tell If the location contains a serial number If it starts with &H00 00 00 ff
				strSerFind=Chr(&H00) & Chr(&H00) & Chr(&H00) & Chr(&Hff)

				'or a model description If it starts with &H00 00 00 fc
				strMdlFind=Chr(&H00) & Chr(&H00) & Chr(&H00) & Chr(&Hfc)

				intSerFoundAt=-1
				intMdlFoundAt=-1
				For findit = 0 to 3
					If instr(location(findit),strSerFind)>0 then
						intSerFoundAt=findit
					End If
					If instr(location(findit),strMdlFind)>0 then
						intMdlFoundAt=findit
					End If
				Next

				'If a location containing a serial number block was found then store it
				If intSerFoundAt<>-1 then
					tmp=Right(location(intSerFoundAt),14)
					If instr(tmp,Chr(&H0a))>0 then
						tmpser=Trim(Left(tmp,instr(tmp,Chr(&H0a))-1))
					Else
						tmpser=Trim(tmp)
					End If
					'although it is not part of the edid spec it seems as though the
					'serial number will frequently be preceeded by &H00, this
					'compensates For that
					If Left(tmpser,1)=Chr(0) then tmpser=Right(tmpser,Len(tmpser)-1)
				Else
					tmpser="Serial Number Not Found in EDID data"
				End If

				'If a location containing a model number block was found then store it
				If intMdlFoundAt<>-1 then
					tmp=Right(location(intMdlFoundAt),14)
					If instr(tmp,Chr(&H0a))>0 then
						tmpmdl=Trim(Left(tmp,instr(tmp,Chr(&H0a))-1))
					Else
						tmpmdl=Trim(tmp)
					End If
					'although it is not part of the edid spec it seems as though the
					'serial number will frequently be preceeded by &H00, this
					'compensates For that
					If Left(tmpmdl,1)=Chr(0) then tmpmdl=Right(tmpmdl,Len(tmpmdl)-1)
				Else
					tmpmdl="Model Descriptor Not Found in EDID data"
				End If

				'**************************************************************
				'Next get the mfg date
				'**************************************************************
				'the week of manufacture is stored at EDID offset &H10
				tmpmfgweek=Asc(mid(oRawEDID(i),&H10+1,1))

				'the year of manufacture is stored at EDID offset &H11
				'and is the current year -1990
				tmpmfgyear=(Asc(mid(oRawEDID(i),&H11+1,1)))+1990

				'store it in month/year format 
				tmpmdt=month(dateadd("ww",tmpmfgweek,DateValue("1/1/" & tmpmfgyear))) & "/" & tmpmfgyear

				'**************************************************************
				'Next get the edid version
				'**************************************************************
				'the version is at EDID offset &H12
				tmpEDIDMajorVer=Asc(mid(oRawEDID(i),&H12+1,1))

				'the revision level is at EDID offset &H13
				tmpEDIDRev=Asc(mid(oRawEDID(i),&H13+1,1))

				'store it in month/year format 
				If tmpEDIDMajorVer < 255-48 and tmpEDIDRev < 255-48 Then
					tmpver=Chr(48+tmpEDIDMajorVer) & "." & Chr(48+tmpEDIDRev)
				Else
					tmpver="Not available"
				End If

				'**************************************************************
				'Next get the mfg id
				'**************************************************************
				'the mfg id is 2 bytes starting at EDID offset &H08
				'the id is three characters long. using 5 bits to represent
				'each character. the bits are used so that 1=A 2=B etc..
				'
				'get the data
				tmpEDIDMfg=mid(oRawEDID(i),&H08+1,2) 

				Char1=0 : Char2=0 : Char3=0 

				Byte1=Asc(Left(tmpEDIDMfg,1)) 'get the first half of the string 
				Byte2=Asc(Right(tmpEDIDMfg,1)) 'get the first half of the string

				'now shift the bits
				'shift the 64 bit to the 16 bit
				If (Byte1 and 64) > 0 then Char1=Char1+16 

				'shift the 32 bit to the 8 bit
				If (Byte1 and 32) > 0 then Char1=Char1+8 

				'etc....
				If (Byte1 and 16) > 0 then Char1=Char1+4 
				If (Byte1 and 8) > 0 then Char1=Char1+2 
				If (Byte1 and 4) > 0 then Char1=Char1+1 

				'the 2nd character uses the 2 bit and the 1 bit of the 1st byte
				If (Byte1 and 2) > 0 then Char2=Char2+16 
				If (Byte1 and 1) > 0 then Char2=Char2+8 

				'and the 128,64 and 32 bits of the 2nd byte
				If (Byte2 and 128) > 0 then Char2=Char2+4 
				If (Byte2 and 64) > 0 then Char2=Char2+2 
				If (Byte2 and 32) > 0 then Char2=Char2+1 

				'the bits For the 3rd character don't need shifting
				'we can use them as they are
				Char3=Char3+(Byte2 and 16) 
				Char3=Char3+(Byte2 and 8) 
				Char3=Char3+(Byte2 and 4) 
				Char3=Char3+(Byte2 and 2) 
				Char3=Char3+(Byte2 and 1) 

				tmpmfg=Chr(Char1+64) & Chr(Char2+64) & Chr(Char3+64)

				'**************************************************************
				'Next get the device id
				'**************************************************************
				'the device id is 2bytes starting at EDID offset &H0a
				'the bytes are in reverse order.
				'this code is not text. it is just a 2 byte code assigned
				'by the manufacturer. they should be unique to a model
				tmpEDIDDev1=hex(Asc(mid(oRawEDID(i),&H0a+1,1)))
				tmpEDIDDev2=hex(Asc(mid(oRawEDID(i),&H0b+1,1)))

				If Len(tmpEDIDDev1)=1 then tmpEDIDDev1="0" & tmpEDIDDev1
				If Len(tmpEDIDDev2)=1 then tmpEDIDDev2="0" & tmpEDIDDev2

				tmpdev=tmpEDIDDev2 & tmpEDIDDev1

				'**************************************************************
				'finally store all the values into the array
				'**************************************************************
				arrMonitorInfo(i,0)=tmpmfg
				arrMonitorInfo(i,1)=tmpdev
				arrMonitorInfo(i,2)=tmpmdt
				arrMonitorInfo(i,3)=tmpser
				arrMonitorInfo(i,4)=tmpmdl
				arrMonitorInfo(i,5)=tmpver
			End If

			'wscript.echo "Monitor " & Chr(i+65) & ")"
			'wscript.echo ".........." & "VESA Manufacturer ID= " & arrMonitorInfo(i,0)
			'wscript.echo ".........." & "Device ID= " & arrMonitorInfo(i,1)
			'wscript.echo ".........." & "Manufacture Date= " & arrMonitorInfo(i,2)
			'wscript.echo ".........." & "Serial Number= " & arrMonitorInfo(i,3)
			'wscript.echo ".........." & "Model Name= " & arrMonitorInfo(i,4)
			'wscript.echo ".........." & "EDID Version= " & arrMonitorInfo(i,5)

			tmpser = trim(ucase(arrMonitorInfo(i,3)))
			If Trim(tmpser) <> "SERIAL NUMBER NOT FOUND IN EDID DATA" Then
				If InStr(monser,tmpser) = 0 then
					monser = monser & " " & tmpser
				End If
			End If
		Next
		Else
			monser = "VMWARE"
		End If
				
		Set objWMiSvc = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
		Set colChassis = objWMiSvc.ExecQuery("select * from Win32_SystemEnclosure")
		For Each objChassis In colChassis
			For Each strChassisType In objChassis.ChassisTypes
				Select Case strChassisType
				Case 3,4,5,6,7,15,16,24
					strType = "Desktop"
				Case 8,9,10,11,12,13,14
					strType = "Laptop"
				Case 23
					strType = "Server"
				Case other
					strType = "Unknown"
				End Select
			Next
		Next
		Set colChassis = Nothing
		Set objWMiSvc = Nothing
		
		If monser = "VMWARE" Then
			strType = "VMWARE"
		End If
		
		If strType = "Unknown" Then
			' Check to see if this is a server OS
			If IsServer Then
				strType = "Server"
			End If
		End If
	end Sub
	
	Public property Get Monitor_Serial
		If monser = "" Then
			monser = "Unknown"
		Else
			Monitor_Serial = monser
		End If
	End Property
	
	Public Property Get SystemType
		SystemType = strType
	End Property
		
	public Property get ostype
		If spver <> "" Then
			myver = "SP" & spver
		Else
			myver = ""
		End If
		ostype = left(trim(replace(replace(replace(replace(replace(replace(osver,"Microsoft",""),"Professional","Pro"),"(R)",""),"Standard Edition",""),"Windows","Win"),",","") & " " & myver),20)
	end Property
	
	public property get installdate
		mm = mid(installd,5,2)
		dd = mid(installd,7,2)
		yy = left(installd,4)
		installdate = mm & "/" & dd & "/" & yy
	end Property
end Class




Function CountCR(strMsg)
	strFinished = False
	strCount = 0
	t0 = Len(strMsg)
	If t0 > 0 Then
		Do
			t1 = InStrRev(strMsg,VbCrLf,t0)
			If t1 > 0 Then
				strCount = strCount + 1
				t0 = t1 - 1
			Else
				strFinished = True
			End If
		Loop While Not strFinished
	End If
	CountCR = strCount
End Function

Function Slice(strMsg, strNum)
	If CountCR(strMsg) > strNum Then
		t0 = InStrRev(strMsg,VbCrLf,Len(strMsg))
		Slice = right(strMsg,(Len(strMsg) - InStr(strMsg,VbCrLf)) - 1)
	Else
		Slice = strMsg
	End If
End Function

Function IsVMWare
	On Error Resume Next
	strTemp = objSh.RegRead("HKLM\SOFTWARE\VMware, Inc.\VMware Tools\InstallPath")
	If Err.Number Then
		IsVMWare = False
	Else
		If IsServer = False Then
			IsVMWare = True
		Else
			IsVMWare = False
		End If
	End If
	Err.Clear
	On Error GoTo 0
End Function

Sub ProcessServerLogin
	Set objEnv = objSh.Environment("PROCESS")
	strLogonServer = objEnv("LOGONSERVER")
	Set objEnv = Nothing
	strClientName = objSh.ExpandEnvironmentStrings ("%CLIENTNAME%")

	' The following objects cannot be constructed until this point
	Set objIp = New Ip
	Set objComp = New Comp
	
	Call WriteLog(objIp.address, strComputer, strUsername, strDomain, strLogonServer, objComp.ostype, objComp.installdate, strClientName, "Server")
	
	Set objIp = Nothing
	Set objComp = Nothing	
End Sub



Sub ProcessWebSense
	strWebSensePath = strLogonServer & "\NETLOGON\WebSense\LogonApp.exe"
	strWebSensePath2 = strLogonServer & "\NETLOGON\WebSense2\LogonApp.exe"
'	If IsMember("Dept085430") Or IsMember("Dept085470") or IsMember("Dept085440") or IsMember ("Dept085450") or strUserName = "BOL0047" or strUserName = "FIT2659" Then
'		If objFso.FileExists(strWebSensePath2) Then
'			objSh.run strWebSensePath2 & " http://websense:15880 /PERSIST",0,False
'			Call UpdateLoginBox("Ran websense test registration from " & strLogonServer)
'		Else
'			Call UpdateLoginBox("Error, could not find path " & strWebSensePath2)
'		End If
'	Else
		If objFso.FileExists(strWebSensePath) Then
			objSh.run strWebSensePath & " http://websense:15880 /PERSIST",0,False
			Call UpdateLoginBox("Ran websense registration from " & strLogonServer)
		Else
			Call UpdateLoginBox("Error, could not find path " & strWebSensePath)
		End If
'	End If
End Sub


