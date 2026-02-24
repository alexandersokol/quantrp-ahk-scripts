#Requires AutoHotkey v2.0

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

~LButton::A
~RButton::D
XButton2::E
XButton1::Space