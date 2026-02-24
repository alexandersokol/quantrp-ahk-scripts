#Requires AutoHotkey v2.0
#Include "..\lib\libCommon.ahk"

SC_LEFT  := "sc14B"
SC_RIGHT := "sc14D"
SC_UP    := "sc148"
SC_DOWN  := "sc150"

global g_running := false

#UseHook true
SendMode "Event"
SetKeyDelay 0, 30   ; 30ms press duration tends to be safe in games
CoordMode "Pixel", "Screen"

; ~e up::OnEReleased()


IsColorAt(x, y, color) {
    try {
        c := PixelGetColor(x, y, "RGB")
    }
    catch
        return false
    return c = color
}

Tap(key) {
    Send("{" key " down}")
    Sleep 25
    Send("{" key " up}")
}

Left() {
    ; value := Random(0, 3)
    ;     switch value {
    ;     case 0:
    ;         Log("Send Left")
    ;         Send("{Left}")
    ;     case 1:
    ;         Log("Send " SC_LEFT)
    ;         Send("{" SC_LEFT "}")
    ;     case 2:
            Log("Tap Left")
            Tap("Left")
        ; case 3:
        ;     Log("Tap " SC_LEFT)
        ;     Tap(SC_LEFT)
        ; }
}

Right() {
    ; value := Random(0, 3)
    ;     switch value {
    ;     case 0:
    ;         Log("Send Right")
    ;         Send("{Right}")
    ;     case 1:
    ;         Log("Send " SC_RIGHT)
    ;         Send("{" SC_RIGHT "}")
    ;     case 2:
    ;         Log("Tap Right")
    ;         Tap("Right")
        ; case 3:
            Log("Tap " SC_RIGHT)
            Tap(SC_RIGHT)
        ; }
}

Up() {
    ; value := Random(0, 3)
    ;     switch value {
    ;     case 0:
    ;         Log("Send Up")
    ;         Send("{Up}")
    ;     case 1:
    ;         Log("Send " SC_UP)
    ;         Send("{" SC_UP "}")
    ;     case 2:
    ;         Log("Tap Up")
    ;         Tap("Up")
    ;     case 3:
            Log("Tap " SC_UP)
            Tap(SC_UP)
        ; }
}

Down() {
    ; value := Random(0, 3)
    ;     switch value {
    ;     case 0:
    ;         Log("Send Down")
    ;         Send("{Down}")
    ;     case 1:
    ;         Log("Send " SC_DOWN)
    ;         Send("{" SC_DOWN "}")
    ;     case 2:
    ;         Log("Tap Down")
    ;         Tap("Down")
    ;     case 3:
            Log("Tap " SC_DOWN)
            Tap(SC_DOWN)
        ; }
}

OnEReleased() {
    global g_running

    if g_running
        return

    g_running := true
    Log("E released")
    try {
        Sleep 400
        if IsColorAt(1321, 1005, 0xFFFFFF) AND isGameActive(){
            Log("E pressed and box detected")

            Loop {
                if IsColorAt(1262, 1061, 0x000000) {
                    Log("Left detected")
                    Left()
                } else if IsColorAt(1300, 1060, 0x000000) {
                    Log("Right detected")
                    Right()
                } else if IsColorAt(1284, 1042, 0x000000) {
                    Log("Up detected")
                    Up()
                } else if IsColorAt(1276, 1076, 0x000000) {
                    Log("Down detected")
                    Down()
                } else {
                    Log("Nothing detected")
                    break
                }

                Sleep Random(400, 700)

                if !IsColorAt(1321, 1005, 0xFFFFFF) || !isGameActive() {
                    Log("Box gone")
                    break
                }

                continue
            }
        }
     } finally {
        g_running := false
    } 
}
