#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "lib\libCommon.ahk"

Persistent true
requestAdminRights()

~+Esc::ProcessClose("GTA5.exe")     ; Shift + Esc - Close GTA5 game
\::Take_ScreenShot()

XButton1::toggleRun()

IS_RUNNING := false

toggleRun() {
    global IS_RUNNING
    
    if (IS_RUNNING) {
        Send("{W up}")
        IS_RUNNING := false
    } else {
        Send("{W down}")
        IS_RUNNING := true
    }
}