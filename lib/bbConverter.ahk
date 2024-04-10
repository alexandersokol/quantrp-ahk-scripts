#Requires AutoHotkey v2.0
#Include "_JXON.ahk"

INPUT_DIR := A_WorkingDir "/bbInput"
OUTPUT_DIR := A_WorkingDir "/bbOutput"

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

        if (bind.Has("name") && sequence.Length > 0){
            return Map(
                "id", bind["id"],
                "name", bind["name"],
                "sequence", sequence
            )
        }
    }

    return 0
}

_load_bb_action_text(value){
    if (value.Has("payload")){
        payload := value["payload"]
        if (payload.Has("value")){
            return payload["value"]
        }
    }
    return 0
}


_load_bb_action_pause(value){
    if (value.Has("payload")){
        payload := value["payload"]
        if (payload.Has("value")){
            return "[" payload["value"] "]"
        }
    }
    return 0
}

_load_bb_action_screenshot(value){
    if (value.Has("payload")){
        payload := value["payload"]
        if (payload.Has("value")){
            return "[screenshot=" payload["value"] "]"
        }
    }
    return 0
}

load_bb_sequences(filePath){
    json := FileRead(filePath, "UTF-8")
    obj := Jxon_Load(&json)

    sequences := []

    if (obj.Has("binds")){
        binds :=  obj["binds"]
        for index, value in binds {
            result := _load_bb_bind(value)
            if (result != 0){
                sequences.Push(result)
            }
        }
    }

    return sequences
}

Run(){
    Loop Files, INPUT_DIR "\*.bb"{
        ConvertFile(A_LoopFilePath, A_LoopFileName)
    }
    Loop Files, INPUT_DIR "\*.json"{
        ConvertFile(A_LoopFilePath, A_LoopFileName)
    }   
}

ConvertFile(filePath, fileName) {
    sequences := load_bb_sequences(filePath)

    
    for index, sequenceMap in sequences {
        name := sequenceMap["name"]
        id := sequenceMap["id"]
        sequence := sequenceMap["sequence"]
        
        fileName := name "_(" fileName ").txt"

        SaveSequenceToFile(fileName, sequence)
    }
}

SaveSequenceToFile(fileName, data){
    filePath := OUTPUT_DIR "/" fileName
    

    if(FileExist(filePath)){
        FileDelete(filePath)
    }

    for index, value in data {
        FileAppend value "`n", filePath, "UTF-8"
    }
}

Run()