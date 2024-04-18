#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "lib\libCommon.ahk"
; #Include "feeding.ahk"
#Include "fishing.ahk"
; #Include "medic.ahk"
#Include "temp\"

Persistent true
requestAdminRights()

~+Esc::ProcessClose("GTA5.exe")     ; Shift + Esc - Close GTA5 game
\::Take_ScreenShot()
