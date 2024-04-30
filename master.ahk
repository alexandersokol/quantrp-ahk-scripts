#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "lib\libCommon.ahk"

#Include "stuff\bite.ahk"
#Include "stuff\circuit.ahk"

Persistent true
requestAdminRights()

~+Esc::ProcessClose("GTA5.exe")     ; Shift + Esc - Close GTA5 game
\::Take_ScreenShot()
