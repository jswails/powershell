﻿icacls "$env:USERPROFILE\Documents\My Documents" /deny users:F

icacls "\\puter\c$\Users\bob\Documents\My Documents" /grant users:F
icacls "\\puter\c$\Users\bob\Documents\My Documents" /grant users:F

icacls "c:\Users\bob\Documents\My Documents" /grant users:F

psexec.exe \\puter cmd
icacls "c:\Users\bob\Documents\My Documents" /grant users:F




icacls "h:\My Documents\My Documents" /grant users:F

