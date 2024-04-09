#Requires AutoHotkey v2.0

#Include "libMedic.ahk"
#Include "libMenuCore.ahk"

TITLE_TEXT_COLOR := "cffffff"
TITLE_TEXT_SIZE := "s12"

TEXT_COLOR := "cffffff"
TEXT_SIZE := "s12"

BACK_COLOR := "cffffff"
TEXT_SIZE := "s12"

DIVIDER_COLOR := "c515151"
BACKGROUND_COLOR := "c000000"

global GTAWindowID := 0

global flatMedicMenu := loadMedicMenuFlat(A_ScriptDir "\medic-menu")

global menus := Map()


toggleMedicUiVisibility(){
    global menus

    Sleep(100)

    if (isAnyMenuVisible()){
        hideAllMenus()
    } else {
        _showMenu()
    }
}

; ====================================================================
; Returns true if any menu isVisible
;
isAnyMenuVisible(){
    global menus

    for key, value in menus {
        if (value["isVisible"]) {
            return true
        }
    }
    return false
}

_showMenu(id := ""){
    hideAllMenus()

    global menus
    global flatMedicMenu

    if(id == ""){
        for key, value in flatMedicMenu {
            if (value.Has("id") && value.Has("parentId") && value["parentId"] == ""){
                id := value["id"]
            }
        } 
    }


    if (menus.Has(id)) {
        if (IsObject(menus[id]["gui"])) {
            menus[id]["gui"].Show()
            menus[id]["isVisible"] := true
        } else {
            menus[id]["gui"] := buildUiMenu(flatMedicMenu[id])
            menus[id]["isVisible"] := true
        }
    } else if(flatMedicMenu.Has(id)){
        menus[id] := Map(
            "gui", buildUiMenu(flatMedicMenu[id]),
            "isVisible", true
        )
    }
}

; ====================================================================
; Hides all Visible Menus
;
hideAllMenus(){
    global menus

    for key, value in menus {
        if (value["isVisible"]) {
            value["gui"].Hide()
            value["isVisible"] := false
        }
    }
}


; ====================================================================
; Appends Title widget to GUI Object
;
appendTitle(menuGui, name){
    menuGui.SetFont(TITLE_TEXT_SIZE " " TITLE_TEXT_COLOR)
    menuGui.Add("Text",,name)
    menuGui.Add("Progress", "h1 " DIVIDER_COLOR " -Smooth", "100")
}

; ====================================================================
; Appends Divider widget to GUI Object
;
appendDivider(menuGui){
    menuGui.Add("Progress", "h1 " DIVIDER_COLOR " -Smooth", "100")
}


appendBack(menuGui, parentId){
    menuGui.SetFont(TEXT_SIZE " " BACK_COLOR)
    menuGui.Add("Progress", "h1 " DIVIDER_COLOR " -Smooth", "100")
    if (parentId == ""){
        uiComponent := menuGui.Add("Text",,"Закрити")
        uiComponent.OnEvent("Click", (*) => hideAllMenus())
    } else {
        uiComponent := menuGui.Add("Text",,"Назад")
        uiComponent.OnEvent("Click", (*) => _showMenu(parentId))
    }
}

appendItem(menuGui, item){
    menuGui.SetFont(TEXT_SIZE " " TEXT_COLOR)

    menuName := "?????"
    if (item.Has("name")){
        menuName := item["name"]
    }

    if (item.Has("type")){
        uiComponent := menuGui.Add("Text",,menuName)


        if(item["type"] == ELEMENT_REFERENCE && item.Has("id")) {
            uiComponent.OnEvent("Click", (*) => _showMenu(item["id"]))
        } else if(item["type"] == ELEMENT_SEQUENCE){
            uiComponent.OnEvent("Click", (*) => {})
        }
    }
}

; ====================================================================
; Appends menu GUI Object and shows it
;
buildUiMenu(menu) {
    menuGui := Gui()
    global GTAWindowID := WinActive("A")
    menuGui.Opt("+AlwaysOnTop +SysMenu -Caption -DPIScale +ToolWindow +Border +Parent" GTAWindowID)
    menuGui.BackColor := BACKGROUND_COLOR

    if (menu.Has("name")){
        appendTitle(menuGui, menu["name"])
    }

    if (menu.Has("items")){

        items := menu["items"]
        for index, value in items {
            appendItem(menuGui, value)
        }
    }

    if (menu.Has("parentId")) {
        appendBack(menuGui, menu["parentId"])
    } else {
        appendBack(menuGui, "")
    }

    menuGui.Show("NoActivate")  ; NoActivate avoids deactivating the currently active window.
    WinSetTransparent(100, menuGui)
    
    menuGui.GetPos(&X, &Y, &Width, &Height)
    
    xx:=A_ScreenWidth - Width
    yy:=(A_ScreenHeight - Height) / 2
    w:=Width
    h:=Height
    menuGui.Move(xx, yy, w, h)

    return menuGui
}

