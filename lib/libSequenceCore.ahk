#Requires AutoHotkey v2.0
#Include "_JXON.ahk"
#Include "libCommon.ahk"
#Include "libMedic.ahk"

SEQ_ELEMENT_TEXT := "text"
SEQ_ELEMENT_DELAY := "delay"
SEQ_ELEMENT_SCREENSHOT := "screenshot"
SEQ_ELEMENT_BEEP := "beep"
SEQ_ELEMENT_SCREENSHOT_SURGEON := "screenshot_surgeon"
SEQ_ELEMENT_SCREENSHOT_DRUGS := "screenshot_drugs"
SEQ_ELEMENT_SCREENSHOT_REANIMATION := "screenshot_reanim"
SEQ_ELEMENT_SCREENSHOT_PATH := "screenshot_path"
SEQ_ELEMENT_BLOOD_ANALYSIS_RANDOM := "blood_analysis_random"
SEQ_ELEMENT_BLOOD_ANALYSIS_OK := "blood_analysis_ok"
SEQ_ELEMENT_BADGE := "badge"

SEQ_EXT_ELEMENT_BREAK := "break"
SEQ_EXT_ELEMENT_UNKNOWN := "unknown"

GLOBAL_SEQUENCES := Map()

load_bb_sequences(filePath){
    json := FileRead(filePath, "UTF-8")
    obj := Jxon_Load(&json)

    if (obj.Has("binds")){
        binds :=  obj["binds"]
        for index, value in binds {
            _load_bb_bind(value)
        }
    }
}


_load_bb_bind(bind) {
    if (bind.Has("actions")){
        sequence := []

        actions := bind["actions"]

        for index, value in actions {
            if (value.Has("type")) {
                if(value["type"] == "text") {
                    seq := _load_bb_action_text(value)
                    if (seq != 0){
                        sequence.Push(seq)
                    }
                }
                else if(value["type"] == "pause"){
                    seq := _load_bb_action_pause(value)
                    if (seq != 0){
                        sequence.Push(seq)
                    }
                } else if (value["type"] == "screenshot"){
                    seq := _load_bb_action_screenshot(value)
                    if (seq != 0){
                        sequence.Push(seq)
                    }
                }
            }
        }

        if (bind.Has("id") && sequence.Length > 0){
            variations := []
            variations.Push(sequence)
            GLOBAL_SEQUENCES[bind["id"]] := variations
        }
    }
}

_load_bb_action_text(value){
    if (value.Has("payload")){
        payload := value["payload"]
        if (payload.Has("value")){
            return _build_seq_element_text(payload["value"])
        }
    }
    return 0
}


_load_bb_action_pause(value){
    if (value.Has("payload")){
        payload := value["payload"]
        if (payload.Has("value")){
            return _build_seq_element_delay(payload["value"])
        }
    }
    return 0
}

_load_bb_action_screenshot(value){
    if (value.Has("payload")){
        payload := value["payload"]
        if (payload.Has("value")){
            return _build_seq_element_screenshot_path(payload["value"])
        }
    }
    return 0
}

load_txt_sequences(filePath, reference){
    file := FileOpen(filePath, "r", "UTF-8")

    variations := []

    if !file{
        Log("Unable to open a file: " filePath)
        return
    }

    sequence := []

    while !file.AtEOF {
        line := file.ReadLine()
        type := _get_element_type(line)
        
        seq_element := _get_seq_element(type, line)
        if (seq_element == 0){
            if (type == SEQ_EXT_ELEMENT_BREAK){
                if (sequence.Length > 0) {
                    variations.Push(sequence)
                    sequence := []
                }
            } else {
                Log("Unhandled element type: " line)
            }
        } else {
            sequence.Push(seq_element)
        }
    }
    
    if (sequence.Length > 0) {
        variations.Push(sequence)
        sequence := []
    }

    GLOBAL_SEQUENCES[reference] := variations

}


_get_seq_element(type, line){
    if (type == SEQ_ELEMENT_TEXT){
        return _build_seq_element_text(line)
    } else if(type == SEQ_ELEMENT_DELAY){
        valueStr := StrReplace(StrReplace(line, "[", ""), "]", "")
        return _build_seq_element_delay(0 + valueStr)
    } else if (type == SEQ_ELEMENT_SCREENSHOT){
        return _build_seq_element_screenshot()
    }
    else if (type == SEQ_ELEMENT_SCREENSHOT_SURGEON){
        return _build_seq_element_screenshot_surgeon()
    }
    else if (type == SEQ_ELEMENT_SCREENSHOT_DRUGS){
        return _build_seq_element_screenshot_drugs()
    }
    else if (type == SEQ_ELEMENT_SCREENSHOT_REANIMATION){
        return _build_seq_element_screenshot_reanimation()
    }
    else if (type == SEQ_ELEMENT_SCREENSHOT_PATH){
        valueStr := StrReplace(StrReplace(line, "[", ""), "]", "")
        path := StrReplace(valueStr, "screenshot=", "")
        return _build_seq_element_screenshot_path(path)
    }
    else if (type == SEQ_ELEMENT_BEEP){
        return _build_seq_element_beep()
    }
    else if (type == SEQ_ELEMENT_BLOOD_ANALYSIS_RANDOM){
        return _build_seq_blood_analysis_random()
    }
    else if (type == SEQ_ELEMENT_BLOOD_ANALYSIS_OK){
        return _build_seq_blood_analysis_ok()
    }
    else if (type == SEQ_ELEMENT_BADGE){
        return _build_seq_badge()
    }

    return 0
}


_get_element_type(line) {
    if (StrLen(line) == 0 || line == "\n" || RegExMatch(line, "^\s*$")){
        return SEQ_EXT_ELEMENT_BREAK
    }
    else if (StrLen(line) > 2 && SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]"){
        type := StrReplace(StrReplace(line, "[", ""), "]", "") 
        if RegExMatch(type, "^\s*-?\d+(\.\d+)?\s*$"){
            return SEQ_ELEMENT_DELAY
        } else if(type == SEQ_ELEMENT_SCREENSHOT){
            return SEQ_ELEMENT_SCREENSHOT
        }
        else if(type == SEQ_ELEMENT_SCREENSHOT_SURGEON){
            return SEQ_ELEMENT_SCREENSHOT_SURGEON
        }
        else if(type == SEQ_ELEMENT_SCREENSHOT_DRUGS){
            return SEQ_ELEMENT_SCREENSHOT_DRUGS
        }
        else if(type == SEQ_ELEMENT_SCREENSHOT_REANIMATION){
            return SEQ_ELEMENT_SCREENSHOT_REANIMATION
        }
        else if(RegExMatch(type, "^screenshot=")){
            return SEQ_ELEMENT_SCREENSHOT_PATH
        }
        else if(type == SEQ_ELEMENT_BEEP){
            return SEQ_ELEMENT_BEEP
        }
        else if(type == SEQ_ELEMENT_BLOOD_ANALYSIS_RANDOM){
            return SEQ_ELEMENT_BLOOD_ANALYSIS_RANDOM
        }
        else if(type == SEQ_ELEMENT_BLOOD_ANALYSIS_OK){
            return SEQ_ELEMENT_BLOOD_ANALYSIS_OK
        }
        else if(type == SEQ_ELEMENT_BADGE){
            return SEQ_ELEMENT_BADGE
        }
        else {
            return SEQ_EXT_ELEMENT_UNKNOWN
        }
    } else {
        return SEQ_ELEMENT_TEXT
    }
}


_build_seq_element_text(text) {
    return Map(
        "type", SEQ_ELEMENT_TEXT,
        "text", text
    )
}

_build_seq_element_delay(delay_ms) {
    return Map(
        "type", SEQ_ELEMENT_DELAY,
        "delay", delay_ms
    )
}

_build_seq_element_screenshot() {
    return Map(
        "type", SEQ_ELEMENT_SCREENSHOT
    )
}

_build_seq_element_screenshot_path(path) {
    return Map(
        "type", SEQ_ELEMENT_SCREENSHOT_PATH,
        "path", path
    )
}

_build_seq_element_screenshot_surgeon() {
    return Map(
        "type", SEQ_ELEMENT_SCREENSHOT_SURGEON
    )
}

_build_seq_element_screenshot_drugs() {
    return Map(
        "type", SEQ_ELEMENT_SCREENSHOT_DRUGS
    )
}

_build_seq_element_screenshot_reanimation() {
    return Map(
        "type", SEQ_ELEMENT_SCREENSHOT_REANIMATION
    )
}

_build_seq_badge() {
    return Map(
        "type", SEQ_ELEMENT_BADGE
    )
}

_build_seq_blood_analysis_random() {
    return Map(
        "type", SEQ_ELEMENT_BLOOD_ANALYSIS_RANDOM
    )
}

_build_seq_blood_analysis_ok() {
    return Map(
        "type", SEQ_ELEMENT_BLOOD_ANALYSIS_OK
    )
}

_build_seq_element_beep() {
    return Map(
        "type", SEQ_ELEMENT_BEEP
    )
}

Sequence_Log_All(){
    for key, value in GLOBAL_SEQUENCES {
        Log("reference: " key)
    }
}


Sequence_Play(reference) {
    Log("Play by reference: " reference)
    if (!GLOBAL_SEQUENCES.Has(reference)){
        Log("Sequence " reference " not found!")
        return
    }

    variations := GLOBAL_SEQUENCES[reference]
    if (variations.Length == 0){
        Log("Sequence " reference " has no variations!")
        return
    }

    sequence := RandomItem(variations)
    if (sequence.Length == 0){
        Log("Sequence " reference " got an empty sequence to play!")
        return
    }

    _Sequence_Play_Variation(sequence)
}


_Sequence_Play_Variation(sequence){
    global isActionsLocked
    isActionsLocked := true

    for index, item in sequence {

        if (!isActionsLocked){
            PlaySound_Pop()
            return
        }

        if (!item.Has("type")){
            Log("Sequence item has no type!")
            continue
        }

        type := item["type"]
        if(type == SEQ_ELEMENT_TEXT){
            _Play_Text(item)
        } else if (type == SEQ_ELEMENT_DELAY){
            _Play_Deleay(item)
        } else if (type == SEQ_ELEMENT_SCREENSHOT){
            _Play_Screenshot()
        } else if (type == SEQ_ELEMENT_BEEP){
            _Play_Beep()
        } else if (type == SEQ_ELEMENT_SCREENSHOT_SURGEON){
            _Play_Screenshot_Surgeon()
        } else if (type == SEQ_ELEMENT_SCREENSHOT_DRUGS){
            _Play_Screenshot_Drugs()
        } else if (type == SEQ_ELEMENT_SCREENSHOT_REANIMATION){
            _Play_Screenshot_Reanimation()
        } else if (type == SEQ_ELEMENT_SCREENSHOT_PATH){
            _Play_Screenshot_Path(item)
        } else if (type == SEQ_ELEMENT_BLOOD_ANALYSIS_RANDOM){
            _Play_Blood_Analysis_Random()
        } else if (type == SEQ_ELEMENT_BLOOD_ANALYSIS_OK){
            _Play_Blood_Analysis_Ok()
        } else if (type == SEQ_ELEMENT_BADGE){
            _Play_Badge()
        } else {
            Log("Uknown sequence item type " type "!")
        }
    }
    isActionsLocked := false

    if (sequence.Length > 5) {
        _Play_Beep()
    }
}


_Play_Blood_Analysis_Ok() {
    Medic_Analysis_Blood_Ok()
}


_Play_Blood_Analysis_Random() {
    Medic_Analysis_Blood_Random()
}


_Play_Screenshot_Path(item) {
    if(item.Has("path")){
        path := item["path"]

        if (!InStr(path, ":\")){
            path := DEFAULT_SCREENSHOT_DIR_PATH "\" path
        }

        Take_ScreenShot(path)
    } else {
        Log("Screenshot path sequence has no path field!")
    }
    Take_ScreenShot(GetReportWeekDir(REANIMATIONS_DIR))
}

_Play_Badge(){
    Chat_Say(BADGE_PLAY_TEXT)
}

_Play_Screenshot_Reanimation(){
    Take_ScreenShot(GetReportWeekDir(REANIMATIONS_DIR))
}

_Play_Screenshot_Drugs(){
    Take_ScreenShot(GetReportWeekDir(DRUGS_DIR))
}

_Play_Screenshot_Surgeon(){
    Take_ScreenShot(GetReportWeekDir(SURGEON_DIR))
}

_Play_Beep(){
    PlaySound_Start()
}

_Play_Screenshot(){
    Take_ScreenShot()
}

_Play_Deleay(item){
    if(item.Has("delay")){
        Sleep(item["delay"])
    } else {
        Log("Delay sequence has no delay field!")
    }
}

_Play_Text(item){
    if (item.Has("text")){
        text := ConstantTextReplace(item["text"])
        text := GenderTextReplace(text)
        text := RandomTextReplace(text)
        Chat_Say(text)
    } else {
        Log("Text sequence has no text field!")
    }
}