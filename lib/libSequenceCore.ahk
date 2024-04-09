#Requires AutoHotkey v2.0
#Include "_JXON.ahk"

SEQ_ELEMENT_TEXT := "text"
SEQ_ELEMENT_DELAY := "delay"
SEQ_ELEMENT_SCREENSHOT := "screenshot"
SEQ_ELEMENT_BEEP := "beep"
SEQ_ELEMENT_SCREENSHOT_SURGEON := "screenshot_surgeon"
SEQ_ELEMENT_SCREENSHOT_DRUGS := "screenshot_drugs"
SEQ_ELEMENT_SCREENSHOT_REANIMATION := "screenshot_reanim"
SEQ_ELEMENT_SCREENSHOT_PATH := "screenshot_path"

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
    Log("Seq File: " filePath)
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

_build_seq_element_beep() {
    return Map(
        "type", SEQ_ELEMENT_BEEP
    )
}