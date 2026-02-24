#Requires AutoHotkey v2.0
#SingleInstance Force

requestAdminRights() {
    full_command_line := DllCall("GetCommandLine", "str")

    if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
    {
        try
        {
            if A_IsCompiled
                Run '*RunAs "' A_ScriptFullPath '" /restart'
            else
                Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
        }
        ExitApp
    }
}
Persistent true
requestAdminRights()

isActive := false

targetX := 1952
targetY := 934

moveSpeedTo := 10     ; 0 = instant, higher = slower
moveSpeedBack := 10   ; 0 = instant, higher = slower

; State for one click cycle
savedX := 0
savedY := 0
hasSavedPos := false

; Toggle ON/OFF with V
v:: {
    global isActive
    isActive := !isActive
    TrayTip("Drag Binding", isActive ? "ON" : "OFF", 1)
}

; LMB DOWN (pass-through)
~LButton:: {
    global isActive, targetX, targetY, moveSpeedTo
    global savedX, savedY, hasSavedPos

    if !isActive
        return

    ; Record where the click started
    MouseGetPos &savedX, &savedY
    hasSavedPos := true

    ; Move cursor to target while user is holding LMB (real drag)
    MouseMove targetX, targetY, moveSpeedTo
}

; LMB UP (pass-through)
~LButton Up:: {
    global isActive, moveSpeedBack
    global savedX, savedY, hasSavedPos

    if !isActive
        return

    if !hasSavedPos
        return

    ; Restore cursor to where the LMB down happened
    MouseMove savedX, savedY, moveSpeedBack

    ; Reset state
    hasSavedPos := false
}

~RButton:: {
    global isActive

    if !isActive
        return

    ; Send E while preserving the real RMB click
    Send("{e}")
}