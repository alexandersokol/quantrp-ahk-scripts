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

~e:: {
    ; Run clicking sequence asynchronously (so E passes instantly)
    SetTimer(StartClickSequence, -1000)  ; -1000 = run once after 1000ms
}

StartClickSequence() {
    clicks := 10
    delay := 1500  ; ms between clicks

    Loop clicks {
        Click()     ; Left mouse click
        Sleep delay
    }
}