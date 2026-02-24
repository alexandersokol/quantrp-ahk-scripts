#Requires AutoHotkey v2.0
#Include "..\lib\libCommon.ahk"

; button - 1235x1004 RGB(100,100,100) 1325x1005 RGB(100,100,100)
; left - 1264x1062 RGB(0,0,0)
; right - 1300x1060 RGB(0,0,0)
; top - 1284x1042 RGB(0,0,0)
; bottom - 1276x1076 RGB(0,0,0)

; #SingleInstance Force
; #UseHook true

; --- Settings ---
CoordMode "Pixel", "Screen"

; Optional: makes PixelGetColor return stable RGB (ignores window color profiles in some cases)
; (If you see mismatches, we can add "Alt" / "Slow" modes, or a tolerance.)
; AHK v2 PixelGetColor returns 0xRRGGBB

Log("==========================================================")

; --- Colors (0xRRGGBB) ---
GRAY := RGB(100, 100, 100)   ; 0x646464
GRAY2 := RGB(193, 193, 193)   ; 0x646464
BLACK := RGB(0, 0, 0)        ; 0x000000

SC_LEFT  := "sc14B"
SC_RIGHT := "sc14D"
SC_UP    := "sc148"
SC_DOWN  := "sc150"

; Helper: tap an arrow key (down+up)
Tap(key) {
    Log("Tap key " key)
    ; Send("{" key " down}{" key " up}")
    Send("{" key " down}")
    Sleep 100
    Send("{" key " up}")
}

; Helper: exact pixel match
IsColorAt(x, y, color) {
    try {
        c := PixelGetColor(x, y, "RGB")
    }
    catch
        return false
    return c = color
}

; Optional: hotkey to stop script quickly
; Esc::ExitApp()

; --- Main loop ---
Loop {
    ; Step 1 gate
    if IsColorAt(1321, 1005, 0xFFFFFF) AND isGameActive(){        
        Log("White detected")
        Sleep 200
        ; Step 2
        if IsColorAt(1262, 1061, BLACK) {
            Log("Left detected")
            Tap(SC_LEFT)
        } else if IsColorAt(1300, 1060, BLACK) {
            Log("Right detected")
            ; Step 3
            Tap(SC_RIGHT)
        } else if IsColorAt(1284, 1042, BLACK) {
            Log("Up detected")
            ; Step 4
            Tap(SC_UP)
        } else if IsColorAt(1276, 1076, BLACK) {
            Log("Down detected")
            ; Step 5
            Tap(SC_DOWN)
        } else {
            ; quit here
        }
        Sleep Random(200, 500)
        ; After steps 2-5, restart loop (as requested)
        continue
    }

    Sleep 250
}

; --- Helper: build 0xRRGGBB int ---
RGB(r, g, b) => (r << 16) | (g << 8) | b

; CoordMode "Mouse", "Screen"
; CoordMode "Pixel", "Screen"

; ~LButton::
; {
;     MouseGetPos &x, &y
;     try color := PixelGetColor(x, y, "RGB")
;     catch {
;         Log("Failed to read pixel color")
;         return
;     }

;     r := (color >> 16) & 0xFF
;     g := (color >> 8) & 0xFF
;     b := color & 0xFF

;     Log(
;         "Cursor: x=" x ", y=" y
;         " | Color: RGB(" r "," g "," b ")"
;         " | HEX: 0x" Format("{:06X}", color)
;     )
; }