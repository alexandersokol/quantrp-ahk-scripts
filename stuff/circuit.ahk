#Requires AutoHotkey v2.0

#Include "../lib/libCommon.ahk"

ELECTRIC_ICON_PADDING := 32
ELECTRIC_SINGLE_AREA_SIZE := 120 + ELECTRIC_ICON_PADDING
ELECTRIC_SEARCH_AREA_START_X := 285
ELECTRIC_SEARCH_AREA_START_Y := 160
ELECTRIC_TURN_ON_SOUND_PATH := A_WorkingDir . "\temp\e-on.wav"
ELECTRIC_TURN_OFF_SOUND_PATH := A_WorkingDir . "\temp\e-off.wav"

global isElectricHelperActive := false

#HotIf IsGameActive()
    >^e::toggleElectricHelper()
#HotIf

#HotIf isElectricHelperActive && IsGameActive()
    E::lookUpForShortage()
#HotIf


; ====================================================================
; Toggles electric helper on/off
;
toggleElectricHelper(){
    global isElectricHelperActive

    if isElectricHelperActive
        {
            isElectricHelperActive := false
            SoundPlay ELECTRIC_TURN_OFF_SOUND_PATH
            Log("Electric helper is on.")
        }
    else
        {
            isElectricHelperActive := true
            SoundPlay ELECTRIC_TURN_ON_SOUND_PATH
            Log("Electric helper is off.")
        }
    
}


; ====================================================================
; Looks for shortage on a screen
;
lookUpForShortage(){
    Sleep(100)
    Send "{E}"
    Sleep(500)

    if isOnGamingScreen(){
        Log("Electric: Still on gaming screen")
        Sleep(500)
        if isOnGamingScreen(){
            Log("Electric: Still on gaming screen - 2")
            PlaySound_Pop()
            return
        }
    }

    CoordMode "Pixel", "Window"
    MouseMove ELECTRIC_SINGLE_AREA_SIZE, ELECTRIC_SINGLE_AREA_SIZE

    msg := ""

    found_X_Array := []
    found_Y_Array := []
    
    Loop 5
    {
        yPos := A_Index - 1
        Loop 5
        {
            xPos := A_Index - 1

            x := ELECTRIC_SEARCH_AREA_START_X + (ELECTRIC_SINGLE_AREA_SIZE * xPos)
            y := ELECTRIC_SEARCH_AREA_START_Y + (ELECTRIC_SINGLE_AREA_SIZE * yPos)

            endX := x + ELECTRIC_SINGLE_AREA_SIZE
            endY := y + ELECTRIC_SINGLE_AREA_SIZE

            if isShortageExists(&Px, &Py, x, y, endX, endY)
            {
                found_X_Array.push(Px)
                found_Y_Array.push(Py)
                msg := msg " [" xPos ":" yPos " - " Px ":" Py "]"
            }    
        }
    }

    if found_X_Array.Length > 0
    {
        Sleep 4000
        CoordMode "Pixel", "Window"
        Loop found_X_Array.Length
        {
            CoordMode "Pixel", "Window"
            MouseMove found_X_Array[A_Index], found_Y_Array[A_Index]
            Sleep(100)
            CoordMode "Pixel", "Window"
            Click found_X_Array[A_Index], found_Y_Array[A_Index]
            Sleep(200)
        }
    }
}


; ====================================================================
; Checks shortage exists in an area
;
isShortageExists(&Px, &Py, StartX, StartY, EndX, EndY){
    CoordMode "Pixel", "Window"
    if PixelSearch(&Px, &Py, StartX, StartY, EndX, EndY, 0x893c23, 1)
        return true
    else
        return false
}