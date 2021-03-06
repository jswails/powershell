Option Explicit 

Dim colNetworkAdapters 
Dim objNetworkAdapter 

Dim strDevInstanceName 
Dim strNetworkAdapterID

'Query for all of the Win32_NetworkAdapters that are wired Ethernet (AdapterTypeId=0 corresponds to Ethernet 802.3) 
Set colNetworkAdapters = GetObject("WinMgmts:{impersonationLevel=impersonate}//./root/Cimv2")_ 
.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE AdapterTypeId=0") 

WScript.Echo "Enabling WoL for the following adapters:" 

For Each objNetworkAdapter In colNetworkAdapters 
            WScript.Echo "  " & objNetworkAdapter.Name & " [" & objNetworkAdapter.MACAddress & "]" 

            strNetworkAdapterID = UCase(objNetworkAdapter.PNPDeviceID) 

            'Query for all of the MSPower_DeviceWakeEnable classes 
            Dim colPowerWakeEnables 
            Dim objPowerWakeEnable 

            Set colPowerWakeEnables = GetObject("WinMgmts:{impersonationLevel=impersonate}//./root/wmi")_ 
            .ExecQuery("SELECT * FROM MSPower_DeviceWakeEnable") 
            'Compare the PNP Device ID from the network adapter against the MSPower_DeviceEnabled instances 
            For Each objPowerWakeEnable In colPowerWakeEnables 
                        'We have to compare the leftmost part as MSPower_DeviceEnabled.InstanceName contains an instance suffix 
                        strDevInstanceName = UCase(Left(objPowerWakeEnable.InstanceName, Len(strNetworkAdapterID))) 
                        'Match found, enable WOL 
                        If StrComp(strDevInstanceName, strNetworkAdapterID)=0 Then 
                                    objPowerWakeEnable.Enable = True 
                                    objPowerWakeEnable.Put_           'Required to write the value back to the object 
                        End     If 
            Next 
            'Query for all of the MSNdis_DeviceWakeOnMagicPacketOnly classes 
            Dim colMagicPacketOnlys 
            Dim objMagicPacketOnly 
            Set colMagicPacketOnlys = GetObject("WinMgmts:{impersonationLevel=impersonate}//./root/wmi")_ 
            .ExecQuery("SELECT * FROM MSNdis_DeviceWakeOnMagicPacketOnly") 
            'Compare the PNP Device ID from the network adapter against the MSNdis_DeviceWakeOnMagicPacketOnly instances 
            For Each objMagicPacketOnly In colMagicPacketOnlys 
                        'We have to compare the leftmost part as MSNdis_DeviceWakeOnMagicPacketOnly.InstanceName contains an instance suffix 
                        strDevInstanceName = UCase(Left(objMagicPacketOnly.InstanceName, Len(strNetworkAdapterID))) 
                        'Match found, enable WOL for Magic Packets only 
                        If StrComp(strDevInstanceName, strNetworkAdapterID)=0 Then 
                                    objMagicPacketOnly.EnableWakeOnMagicPacketOnly = True  'Set to false if you wish to wake on magic packets AND wake patterns 
                                    objMagicPacketOnly.Put_             'Required to write the value back to the object 
                        End     If 
            Next 
Next

