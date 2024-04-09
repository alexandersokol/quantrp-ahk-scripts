#Requires AutoHotkey v2.0

#Include "libCommon.ahk"
#Include "libSequenceCore.ahk"
#Include "_JXON.ahk"

ELEMENT_TEXT := "text"
ELEMENT_MENU := "menu"
ELEMENT_REFERENCE := "menu_reference"
ELEMENT_SEQUENCE := "sequence"

loadMedicMenuFlat(menuDir) {
    flatMenuList := []
    loadedItems := loadMenuDirFlatten(menuDir, "", "Меню", flatMenuList)

    flatMap := Map()

    for index, value in flatMenuList {
        flatMap[value["id"]] := value
    }

    return flatMap
}

loadMenuDirFlatten(menuDir, parentId, menuName := "main", flatList := []) {
    items := []

    ownId := _randomId()
    Loop Files, menuDir "\*", "D" {
        subMenu := loadMenuDirFlatten(A_LoopFilePath, ownId, A_LoopFileName, flatList)
        items.Push(_menuElementReference(subMenu))
        ; add submenu
    }

    Loop Files, menuDir "\*.txt" {
        if (A_LoopFileName == "_menu.txt"){
            infoItems := loadMenuInfo(A_LoopFilePath, menuName)
            for index, value in infoItems
                items.Push(value)
        } else {
            items.Push(loadMenuFile(A_LoopFileName, A_LoopFilePath))
        }
    }

    Loop Files, menuDir "\*.json" {
        subMenu := loadMenuJson(A_LoopFilePath, A_LoopFileName, ownId)
        flatList.Push(subMenu)
        items.Push(_menuElementReference(subMenu))
    }

    Loop Files, menuDir "\*.bb" {
        subMenu := loadMenuJson(A_LoopFilePath, A_LoopFileName, ownId)
        flatList.Push(subMenu)
        items.Push(_menuElementReference(subMenu))
    }
    
    result := _menuElement(ownId, parentId, menuName, items)
    flatList.Push(result)
    return result
}


loadMenuDir(menuDir, parentId, menuName := "main") {
    items := []

    ownId := _randomId()

    Loop Files, menuDir "\*", "D" {
        items.Push(loadMenuDir(A_LoopFilePath, ownId, A_LoopFileName))
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
            items.Push(loadMenuJson(A_LoopFilePath, A_LoopFileName, ownId))

        Loop Files, menuDir "\*.bb"
            items.Push(loadMenuJson(A_LoopFilePath, A_LoopFileName, ownId))
    
    return _menuElement(ownId, parentId, menuName, items)
}

loadMenuJson(filePath, filename, parentId){
    json := FileRead(filePath, "UTF-8")
    obj := Jxon_Load(&json)

    ownId := _randomId()

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

    return _menuElement(ownId, parentId, name, items)
}


; ====================================================================
; Loads info from _menu.txt file
loadMenuInfo(filePath, menuName) {
    file := FileOpen(filePath, "r", "UTF-8")

    menuItems := []

    if !file{
        Log("Unable to open a file: " filePath)
        return menuItems
    }

    while !file.AtEOF {
        line := file.ReadLine()
        menuItems.Push(_textElement(line))
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

_menuElement(id, parentId,  name, items){
    return Map(
        "id", id,
        "parentId", parentId,
        "type", ELEMENT_MENU,
        "name", name,
        "items", items
    )
}

_menuElementReference(menu){
    return Map(
        "id", menu["id"],
        "type", ELEMENT_REFERENCE,
        "name", menu["name"],
    )
}

_randomId() {
    return Format("{:X}", A_TickCount) ":" Random(1, 100000) ":" Random(1, 200000) ":" Random(1, 300000)
}

; loadedItems := loadMedicMenuFlat("C:\Users\rraze\OneDrive\Documents\AutoHotkey\quantrp-ahk-scripts\medic-menu")

; json := Jxon_Dump(loadedItems, indent := 0)
; JSON_MENU_FILE_PATH := A_WorkingDir . "\menu.json"
; try {
;     FileDelete JSON_MENU_FILE_PATH
; }
; FileAppend(json, JSON_MENU_FILE_PATH, "UTF-8")


; json := Jxon_Dump(GLOBAL_SEQUENCES, indent := 0)
; JSON_MENU_FILE_PATH := A_WorkingDir . "\sequence.json"
; try {
;     FileDelete JSON_MENU_FILE_PATH
; }
; FileAppend(json, JSON_MENU_FILE_PATH, "UTF-8")

; ExitApp