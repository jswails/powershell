'########################################################################################
'#                -- 8/23/01 -- Fernando Martinez -- 					#
'# This script takes a group name as input and will create a log file			#
'# by the same name that lists the members of the group.				#
'# PIC or the members of the group if the input was a group name.			#
'########################################################################################

Option Explicit

'########################################################################################
'# Delcare the variables to use in the program.						#
'########################################################################################

Dim Input	
Dim ObjectType
Dim Domain
Dim List
Dim Answer

'########################################################################################
'# Declare the constants used in the program.						#
'########################################################################################

const Group = 2
Const Error = -1
Const Multiple = 3
Const ForWriting = 2

'########################################################################################
'# Output a Message Box explaining what the program will be doing, where it will be	#
'# creating log files, and the input required by ther user.  The user may cancel the	#
'# execution at this time.								#
'########################################################################################

Answer = MsgBox("This program will create membership listings for groups.  " _
	& "The file(s) for each group will be created in the same directory " _
	& "from which this program is run." & chr(10) & chr(10) & "Press OK to continue " _
	& "or Cancel to exit this program.", 65, "Program Information")

if Answer = 2 then
   wscript.quit
end if

'########################################################################################
'# Obtain a valid domain: SAI								#
'########################################################################################

Domain = "corp.stateauto.com"

'########################################################################################
'# Obtain the input and decipher if it was a PIC or a group name			#
'########################################################################################

Input = ""
Do While ReturnObjectType(Input) = Error
   if Input = "" then
      Input = LTrim(RTrim(InputBox("Please enter the name(s) of the groups " _
	& "for which to retrieve membership listings.  Multiple entries should be " _
	& "separated by a semicolon, "";""." & chr(10) & chr(10) & "You may press Cancel " _
	& " to exit this program.", "PIC or Group Name", Input)))
   else
      Input = LTrim(RTrim(InputBox("Invalid Input: """ & Input & """ is not a valid group " _
	& " name in " & Domain & "." & chr(10) & chr(10) & "Please enter the " _
	& "name(s) of the users and/or groups for which to retrieve membership listings.  " _
	& "Multiple entries should be separated by a semicolon, "";""." & chr(10) & chr(10) _
	& "You may press Cancel  to exit this program.", "PIC or Group Name", Input)))
   end if
   if Input = "" then
      wscript.quit
   end if
Loop

'########################################################################################
'# Create a list array with each group name/ PIC entered in the Input and store in List.#
'########################################################################################

Input = Input & ";"
List = Split(Input, ";", -1)

'########################################################################################
'# Create the proper log file for each entry in List if not an empty strin depending on	#
'# the object type or error for each entry.						#
'########################################################################################

for each Input in List
   Input = LTrim(RTrim(UCase(Input)))
   if ReturnObjectType(Input) = Group then
      GetUserMembershipForGroupname (Input)
   elseif (ReturnObjectType(Input) = Error) and (Input <> "") then
      CreateErrorFileForInput (Input)
   end if
next

'########################################################################################
'# End the script.									#
'########################################################################################

MsgBox("Program complete!")
wscript.quit

'########################################################################################
'########################################################################################
'###############################Functions And Procedures#################################
'########################################################################################
'########################################################################################
'# ReturnObjectType is a function that returns one of four values based on constants	#
'# previously declared in the header of the program:  User, Group, Multiple and Error.  #
'# The function returns User if the Name passed to it corresponds to a user in the AD	#
'# returns Group if the Name passed corresponds to a group, Multiple if a semicolon is	#
'# detected marking more than one name given, and Error if the name either doesn't 	#
'# exists or corresponds to any other object class in the active directory.  		#
'#											#
'# This is used to ensure that the input given by the user is always a			#
'# group or a user's name and to continue prompting the user until either a group/user	#
'# name is obtained and to choose the proper function to call once a group/user name is	#
'# obtained from the user and the proper display file can be created.			#
'########################################################################################

Public Function ReturnObjectType (ByVal Name)

                     '#####################################
                     '#    LOCAL VARIABLE DECLARATIONS    #
                     '#####################################

   Dim NewObject	' this is a temporary object set using WinNT while checking to see
			' if the name corresponds to a group/user


                     '#####################################
                     '#         DATA PROCESSING           #
                     '#####################################

   'check for a semicolon
   if InStr(Name, ";") > 0 then
      ReturnObjectType = Multiple
      Exit Function
   end if

   ' check and see if a user object exists for the name

   On Error Resume Next
      ' check and see if a group object exists for the name
      set NewObject = GetObject("WinNT://" & Domain & "/" & Name & ",group")
      if Err = 0 then
         ReturnObjectType = Group	' we've successfully found a group with the Name
      else

         ' the object was not found, and thus is an error
         ReturnObjectType = Error
      end if
   On Error goTo 0
End Function

'########################################################################################
'# GetUserMembershipForGroupName is a procedure that links to the group with the group	#
'# name and creates a display file called groupname.txt containing the group name, the	#
'# date the script was run, the total number of users in the group, and the PIC and	#
'# full name (if it exists) for all of the members of that group in a displayed table.	#
'########################################################################################

PUblic Sub GetUserMembershipForGroupname (ByVal GroupName)

                     '#####################################
                     '#    LOCAL VARIABLE DECLARATIONS    #
                     '#####################################

   Dim Log
   Dim Fso
   Dim m
   Dim Group
   Dim MaxPicLength
   Dim FUllName
   Dim MaxFullNameLength
   Dim NumUsers

                     '#####################################
                     '#         DATA PROCESSING           #
                     '#####################################

   ' create a file system object for the log file
   Set Fso = CreateObject("Scripting.FileSystemObject")

   ' link to the group
   set Group = GetObject("WinNT://" & Domain & "/" & Groupname & ",group")

   ' create a log file with the group name as the name
   set Log = fso.OpenTextFile(UCase(Group.name) & ".txt", ForWriting, true)

   ' output the header and date the file was run
   Log.WriteLine (Groupname & " -  Membership List as of " & Date)
   Log.WriteLine (String(Len(UCase(Group.Name) & " - Group Memberships as of " & Date), "-"))
   Log.WriteLine

   MaxPICLength = 3
   MaxFullNameLength = 9

   ' determine the maximum pic length and full name length
   for each m in group.Members
      if Len(m.name) > MaxPICLength then
         MaxPICLength = Len(m.name)
      end if

      On ERror Resume Next
      FullName = m.FullName
      if err = 0 then
         if Len(FullName) > MaxFullNameLength then
            MaxFullNameLength = Len(FullName)
         end if
      end if
      On Error GoTo 0
   next

   ' write out the header line for PIC - FullName
   Log.Write Chr(9) & "PIC"
   if MaxPICLength > 3 then
      Log.Write Space(MaxPicLength - 3)
   end if
   Log.WriteLine " - Full Name"

   ' write out the underline line
   Log.Write Chr(9) & "---"
   if MaxPICLength > 3 then
      Log.Write String(MaxPicLength - 3, "-")
   end if
   Log.Write "------------"
   if MaxFullNameLength > 9 then
      Log.Write String(MaxFullNameLength - 9, "-")
   end if
   Log.WriteLine

   ' count the number of memberships and output their pic - full name
   NumUsers = 0
   for each m in group.members
      ' increment the number of members
      NumUsers = NumUsers + 1

      ' write out a tab and then the PIC
      log.Write chr(9) & m.name

      ' output more spaces if the PIC wasn't the longest in the list so that
      ' all of the columns match up
      if Len(m.Name) < MaxPICLength then
         Log.Write Space (MaxPICLength - Len(m.Name))
      end if

      ' dash to the full name
      Log.Write " - "

      ' if the full name field was populated out put it
      On Error Resume Next
         FullName = m.FullName
         if err = 0 then
            Log.Write FullName
         end if
      On Error GoTo 0

      ' carriage return
      Log.WriteLine
   next   ' member of the group


   ' output the total number of members of the group and the domain
   Log.WriteLine
   Log.WriteLine
   Log.WriteLine NumUsers & " users are a member of this groups on " & Domain

   ' free up all objects still attached
   set Group = nothing
   LOg.Close
   set Log = nothing
   Set Fso = nothing

End Sub


'########################################################################################
'# This function will only run if multiple names were requested.  It creates a log file	#
'# with Name.txt and states that the Name given is not a valid user or group in the	#
'# active directory.
'########################################################################################

Public Sub CreateErrorFileForInput (ByVal Name)

                     '#####################################
                     '#    LOCAL VARIABLE DECLARATIONS    #
                     '#####################################

   Dim FSO	' File System Object used to create the error log file

   Dim Log	' the log file created by this procedure as Name.txt


                     '#####################################
                     '#         DATA PROCESSING           #
                     '#####################################

   ' create the File System Object
   set FSO = CreateObject("Scripting.FileSystemObject")

   ' create the log file
   set Log = fso.OpenTextFile(UCase(Name) & ".txt", 2, true)

   ' output the error message

   Log.WriteLine ("Error: " & Name & " is not a valid User or Group Name of an object in " _
	& "the Active Directory.")

   ' close the log file
   Log.Close

   ' free up all remaining objects
   set Log = nothing
   set fso = nothing

End Sub ' outputting an error log file

'########################################################################################

