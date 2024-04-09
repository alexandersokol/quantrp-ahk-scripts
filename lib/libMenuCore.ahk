#Requires AutoHotkey v2.0

#Include "libCommon.ahk"
#Include "libSequenceCore.ahk"
#Include "_JXON.ahk"

ELEMENT_TEXT := "text"
ELEMENT_MENU := "menu"
ELEMENT_SEQUENCE := "sequence"

loadMenuDir(menuDir, menuName := "main") {
    Log("Root: " menuDir)
    items := []

    Loop Files, menuDir "\*", "D" {
        ; Log("Dir: " A_LoopFileName)
        Log("A_LoopFileName: " A_LoopFileName)
        ; Log("A_LoopFilePath: " A_LoopFilePath)
        items.Push(loadMenuDir(A_LoopFilePath, A_LoopFileName))
    }

    Loop Files, menuDir "\*.txt"
        if (A_LoopFileName == "_menu.txt"){
            infoItems := loadMenuInfo(A_LoopFilePath, menuName)
            for index, value in infoItems
                items.Push(value)
        } else {
            items.Push(loadMenuFile(A_LoopFileName, A_LoopFilePath))
        }

        Loop Files, menuDir "\*.json"
            items.Push(loadMenuJson(A_LoopFilePath, A_LoopFileName))

        Loop Files, menuDir "\*.bb"
            items.Push(loadMenuJson(A_LoopFilePath, A_LoopFileName))

    return _menuElement(menuName, items)
}

loadMenuJson(filePath, filename){
    json := FileRead(filePath, "UTF-8")
    obj := Jxon_Load(&json)

    name := filename
    if (obj.Has("name")){
        name := obj["name"]
    }

    items := []

    if (obj.Has("binds")){
        binds :=  obj["binds"]
        for index, value in binds {
            if (value.Has("id") && value.Has("name")){
                items.Push(_sequenceElement(value["name"], value["id"]))
            }
        }
    }

    load_bb_sequences(filePath)

    return _menuElement(name, items)
}


; ====================================================================
; Loads info from _menu.txt file
loadMenuInfo(filePath, menuName) {
    Log("File: " filePath)
    file := FileOpen(filePath, "r", "UTF-8")

    menuItems := []

    if !file{
        Log("Unable to open a file: " filePath)
        return menuItems
    }

    Log("Menu name " menuName)
    while !file.AtEOF {
        line := file.ReadLine()
        menuItems.Push(_textElement(line))
        Log("read line: " line)
    }

    file.Close()

    return menuItems
}

; ====================================================================
; Loads menu data from
loadMenuFile(fileName, filePath) {
    ; TODO load menu reference
    name := StrReplace(fileName, ".txt", "")
    rootScriptDir := StrReplace(A_ScriptDir, "\lib", "")
    reference := StrReplace(filePath, rootScriptDir, "")

    load_txt_sequences(filePath, reference)

    return _sequenceElement(name, reference)
}


_sequenceElement(name, reference) {
    return Map(
        "type", ELEMENT_SEQUENCE,
        "name", name,
        "reference", reference
    )
}


_textElement(name) {
    return Map(
        "type", ELEMENT_TEXT,
        "name", name
    )
}

_menuElement(name, items){
    return Map(
        "type", ELEMENT_MENU,
        "name", name,
        "items", items
    )
}

loadedItems := loadMenuDir("C:\Users\rraze\OneDrive\Documents\AutoHotkey\quantrp-ahk-scripts\medic-menu")


json := Jxon_Dump(loadedItems, indent := 0)
JSON_MENU_FILE_PATH := A_WorkingDir . "\menu.json"
try {
    FileDelete JSON_MENU_FILE_PATH
}
FileAppend(json, JSON_MENU_FILE_PATH, "UTF-8")


json := Jxon_Dump(GLOBAL_SEQUENCES, indent := 0)
JSON_MENU_FILE_PATH := A_WorkingDir . "\sequence.json"
try {
    FileDelete JSON_MENU_FILE_PATH
}
FileAppend(json, JSON_MENU_FILE_PATH, "UTF-8")

ExitApp