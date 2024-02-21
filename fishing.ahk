#Requires AutoHotkey v2.0

#Include "lib\libCommon.ahk"

FISHING_TURN_ON_SOUND_PATH := A_WorkingDir . "\sounds\fishing-on.wav"
FISHING_TURN_OFF_SOUND_PATH := A_WorkingDir . "\sounds\fishing-off.wav"

global isFishingRemapActive := false


#HotIf isGameActive()
    >^f::toggleFishingKeyRemap() ; LCtrl + F
#HotIf

#HotIf isFishingRemapActive && isGameActive()
    ~LButton::Space
    ~RButton::E
#HotIf


; ====================================================================
; Toggles fishing key remap
;
toggleFishingKeyRemap(){
    global isFishingRemapActive

    if isFishingRemapActive {
        isFishingRemapActive := false
        SoundPlay FISHING_TURN_OFF_SOUND_PATH
        Log("Fishing remap is on.")
    }
    else {
        isFishingRemapActive := true
        SoundPlay FISHING_TURN_ON_SOUND_PATH
        Log("Fishing remap is off.")
    }
}