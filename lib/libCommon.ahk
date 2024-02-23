#Requires AutoHotkey v2.0
#Include "ImagePut.ahk"

DELAY_MESSAGE_SEND := 100

BUTTON_OPEN_CHAT := "{F6}"
BUTTON_SEND_MESSAGE := "{Enter}"

LOG_FILE_PATH := A_WorkingDir . "\logs.log"
DEFAULT_SCREENSHOT_DIR_PATH := A_WorkingDir . "\screenshots"

SOUNDS_DIR := A_WorkingDir . "\sounds"

SOUND_CAMERA_SHUTTER := "camera-shutter.mp3"

INTERFACE_POSITIONS_1920_1080 := Map(
    "width", 1920,
    "height", 1080,
    "POSITION_Q_LOGO_X", 1878,
    "POSITION_Q_LOGO_Y", 28,
    "POSITION_ONLINE_LOGO_X", 1618,
    "POSITION_ONLINE_LOGO_Y", 30,
    "POSITION_CAR_FUEL_X", 0,
    "POSITION_CAR_FUEL_Y", 0,
    "POSITION_SPEEDBAR_X", 1665,
    "POSITION_SPEEDBAR_Y", 1066,
)

INTERFACE_POSITIONS_2560_1440 := Map(
    "width", 2560,
    "height", 1440,
    "POSITION_Q_LOGO_X", 2512,
    "POSITION_Q_LOGO_Y", 55,
    "POSITION_ONLINE_LOGO_X", 2157,
    "POSITION_ONLINE_LOGO_Y", 38,
    "POSITION_CAR_FUEL_X", 2343,
    "POSITION_CAR_FUEL_Y", 1411,
    "POSITION_SPEEDBAR_X", 2225,
    "POSITION_SPEEDBAR_Y", 1430,
)

global INTERFACE_POSITIONS := [
    INTERFACE_POSITIONS_1920_1080,
    INTERFACE_POSITIONS_2560_1440
]

global POSITION_Q_LOGO_X := 2512
global POSITION_Q_LOGO_Y := 55
COLOR_Q_LOGO := 0xFFFFFF

global POSITION_ONLINE_LOGO_X := 2157
global POSITION_ONLINE_LOGO_Y := 38
COLOR_ONLINE_LOGO := 0xFDCC34

global POSITION_CAR_FUEL_X := 2343
global POSITION_CAR_FUEL_Y := 1411
COLOR_CAR_FUEL_FULL := 0xC1C1C1
COLOR_CAR_FUEL_EMPTY := 0xA45C4C

global POSITION_SPEEDBAR_X := 2225
global POSITION_SPEEDBAR_Y := 1430
COLOR_SPEEDBAR_FILLED := 0xBF9A27

; ====================================================================
; Define positioning variables regarding to current screen size
;
assingPositionVariables(positions) {
    global POSITION_Q_LOGO_X := positions["POSITION_Q_LOGO_X"]
    global POSITION_Q_LOGO_Y := positions["POSITION_Q_LOGO_Y"]

    global POSITION_ONLINE_LOGO_X := positions["POSITION_ONLINE_LOGO_X"]
    global POSITION_ONLINE_LOGO_Y := positions["POSITION_ONLINE_LOGO_Y"]

    global POSITION_CAR_FUEL_X := positions["POSITION_CAR_FUEL_X"]
    global POSITION_CAR_FUEL_Y := positions["POSITION_CAR_FUEL_Y"]
}

; ====================================================================
; Define positioning variables regarding to current screen size
;
definePositionVariables() {
    global INTERFACE_POSITIONS

    Loop INTERFACE_POSITIONS.Length
    {
        positions := INTERFACE_POSITIONS[A_Index]
        
        if (positions["width"] == A_ScreenWidth && positions["height"] == A_ScreenHeight){
            assingPositionVariables(positions)
            Log("UI element position assigned for " A_ScreenWidth "x" A_ScreenHeight " screen size")
            return
        }
    }
    Log("Unable to define position of UI elements for " A_ScreenWidth "x" A_ScreenHeight " screen size")
}
definePositionVariables()


; ====================================================================
; Requests script to start with admin permissions or closes the app
;
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


; ====================================================================
; Plays sound from sounds dir
;
PlaySound(filename) {
    SoundPlay(SOUNDS_DIR . "\" . filename)
}


; ====================================================================
; Plays Pop sound from sounds dir
;
PlaySound_Pop() {
    PlaySound("happy-pop.mp3")
}


; ====================================================================
; Plays Pop sound from sounds dir
;
PlaySound_Error() {
    PlaySound("error.mp3")
}


; ====================================================================
; Logs a message into the log file
;
Log(msg) {
    CurrentDateTime := FormatTime(A_Now ,"yyyy-MM-dd HH:mm:ss")
    StringToAppend := "[" . CurrentDateTime . "] " . msg . "`n"
    FileAppend StringToAppend, LOG_FILE_PATH
}


; ====================================================================
; Logs a mouse coordinates into the log file
;
LogMouseCords() {
    MouseGetPos &xpos, &ypos  
    Log("Mouse coorinates: [" xpos ":" ypos "] screen size: [" A_ScreenWidth ":" A_ScreenHeight "] color: " PixelGetColor(xpos, ypos) )
}


; ====================================================================
; Sends a message into the game chat starting with /me
;
Chat_Me(message) {
    Chat_Say("/me " . message)
}


; ====================================================================
; Sends a message into the game chat starting with /do
;
Chat_Do(message) {
    Chat_Say("/do " . message)
}


; ====================================================================
; Sends a message into the game chat starting with /try
;
Chat_Try(message) {
    Chat_Say("/try " . message)
}


; ====================================================================
; Sends a message into the game chat
Chat_Say(message)
{
    Sleep(DELAY_MESSAGE_SEND)
    Send(BUTTON_OPEN_CHAT)

    Sleep(DELAY_MESSAGE_SEND)
    SendInput(message)

    Sleep(DELAY_MESSAGE_SEND)
    Send(BUTTON_SEND_MESSAGE)

    Log("Chat sent: " . message)
}


; ====================================================================
; Types a message into the game chat and not sends a message
;
Chat_Type(message) {
    Sleep(DELAY_MESSAGE_SEND)
    Send(BUTTON_OPEN_CHAT)

    Sleep(DELAY_MESSAGE_SEND)
    SendInput(message)

    Log("Chat type: " . message)
}


; ====================================================================
; Types a message into the game chat and  sends a message without opening chat before
;
Chat_ContinueInputAndSend(message) {
    Sleep(DELAY_MESSAGE_SEND)
    SendInput(message)

    Sleep(DELAY_MESSAGE_SEND)
    Send(BUTTON_SEND_MESSAGE)

    Log("Chat ContinueInputAndSend: " . message)
}


; ====================================================================
; Makes a screenshot and saves it into the script work dir 'screenshot' directory
; dir - path to the directory, if empty - script work dir 'screenshot' directory 
; filename - screenshot filename with .png or .jpg extension, if empty - datetime format
;
Take_ScreenShot(dir := "", filename := "") {
    if dir == ""
        dir := DEFAULT_SCREENSHOT_DIR_PATH 

    if filename == ""
        CurrentDateTime := FormatTime(A_Now ,"dd.MM.yyyy - HH.mm.ss")
        filename := CurrentDateTime . ".jpg"

    output_path := dir . "\" . filename

    Log("Screen size 1: " 0 " " 0 " " A_ScreenWidth " " A_ScreenHeight)

    ; MouseGetPos(,, &WhichWindow, &WhichControl, 2)
    ; try ControlGetPos &x, &y, &w, &h, WhichControl, WhichWindow
    ; Log("Screen size 2: " x " " y " " w " " h)

    GetWindowBounds(&X, &Y, &W, &H)

    ImagePutFile([X, Y, W, H], output_path)
    ; ImagePutFile({monitor: 1}, "test_a.jpg")
    PlaySound(SOUND_CAMERA_SHUTTER)
    Log("Screenshot taken: " . output_path)
    return output_path
}


; ====================================================================
; Takes screenshot and saves into dir within current date directory
;
Take_ScreenShot_DateDir(dir) {
    CurrentDate := FormatTime(A_Now ,"dd.MM.yyyy")
    return Take_ScreenShot(dir . "\" . CurrentDate)
}


; ====================================================================
; Retuns window bounds
;
GetWindowBounds(x, y, w, h) {
    ; Log("Screen size 1: " 0 " " 0 " " A_ScreenWidth " " A_ScreenHeight)

    WinGetPos &xOut, &yOut, &wOut, &hOut, "A"
    ; Log("Screen size 2: " xOut " " yOut " " wOut " " hOut)

    ; fullscreenX := SysGet(SM_CXFULLSCREEN)
    ; fullscreenY := SysGet(SM_CYFULLSCREEN)

    ; Log("Screen size fullscreen 4: " xOut " " yOut " " fullscreenX " " fullscreenY)

    ; maximizedX := SysGet(SM_CXMAXIMIZED)
    ; maximizedY := SysGet(SM_CYMAXIMIZED)

    ; Log("Screen size maximized 4: " xOut " " yOut " " maximizedX " " maximizedY)

    ; virtualX := SysGet(SM_CXMAXIMIZED)
    ; virtualY := SysGet(SM_CYMAXIMIZED)

    ; Log("Screen size virtual 4: " xOut " " yOut " " virtualX " " virtualY)

    ; monitorsCount := SysGet(80)

    ; Log("Monitors: " monitorsCount)

    %x% := xOut
    %y% := yOut
    %w% := wOut
    %h% := hOut
}


; ====================================================================
; Retuns an item from given array at random position
;
RandomItem(arr) {
    position := Random(1, arr.Length)
    return arr[position]
}


; ====================================================================
; Retuns true if GTA game is currently active window
;
IsGameActive() {
    return WinActive("ahk_exe GTA5.exe")
}


; ====================================================================
; Makes game window active
;
focusGame(){
    WinActivate "GTA5.exe"
}


; ====================================================================
; Checks that currently is playing, not in the menu.
;
isOnGamingScreen() {
    CoordMode "Pixel", "Window"
    qLogoColor := PixelGetColor(POSITION_Q_LOGO_X, POSITION_Q_LOGO_Y)
    onlineLogoColor := PixelGetColor(POSITION_ONLINE_LOGO_X, POSITION_ONLINE_LOGO_Y)
    return qLogoColor == COLOR_Q_LOGO && onlineLogoColor == COLOR_ONLINE_LOGO
}

; ====================================================================
; Prints current game state into the log
;
PrintStateToLog(){
    Log("IsGameActive: " IsGameActive())
    Log("isOnGamingScreen: " isOnGamingScreen())
    Log("isOnAction: " isOnAction())
    Log("isMovinOnVihicle: " isMovinOnVihicle())
    Log("isInVihicle: " isInVihicle())
}


; ====================================================================
; Checks that character is moving or not
;
isOnAction()
{
    return GetKeyState("Shift", "P") ||  GetKeyState("RButton", "P") || GetKeyState("LButton", "P")
}


; ====================================================================
; Checks character is moving on any vihicle
;
isMovinOnVihicle() {
    CoordMode "Pixel", "Window"
    speedbarColor := PixelGetColor(POSITION_SPEEDBAR_X, POSITION_SPEEDBAR_Y)
    return speedbarColor == COLOR_SPEEDBAR_FILLED
}


; ====================================================================
; Checks character is in vihicle
;
isInVihicle() {
    CoordMode "Pixel", "Window"
    fuelColor := PixelGetColor(POSITION_CAR_FUEL_X, POSITION_CAR_FUEL_Y)
    return fuelColor == COLOR_CAR_FUEL_FULL || fuelColor == COLOR_CAR_FUEL_EMPTY
}


Log("")
Log("")
Log("")
Log("-------------------")
Log("New Session started.")