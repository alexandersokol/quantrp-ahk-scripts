#Requires AutoHotkey v2.0

TITLE_TEXT_COLOR := "cffffff"
TITLE_TEXT_SIZE := "s12"

TEXT_COLOR := "cffffff"
TEXT_SIZE := "s12"

BACK_COLOR := "cffffff"
TEXT_SIZE := "s12"

DIVIDER_COLOR := "c515151"
BACKGROUND_COLOR := "c000000"

mainMenuComponents := [
    uiText("Загальне", () => handleMenuClick("common")),
    uiText("Мед. карта", () => handleMenuClick("medcard")),
    uiText("Прайс лист", () => handleMenuClick("prices")),
    uiText("Хірургія", () => handleMenuClick("surgeon")),
    uiText("Скріншот"),
    uiDivider(),
    uiText("Закрити", () => hideAllMenus())
]
 
commonMenuComponents := [
    uiTitle("Загальне"),
    uiText("Жетон {LCtrl + Q}"),
    uiText("Реанімація {LCtrl + 9}"),
    uiText("Приняти кров {LCtrl + 0}"),
    uiText("Вітамінка {LCtrl + -}"),
    uiText("Блістер {LCtrl + =}"),
    uiText("Немає тіла {LCtrl + X}"),
    uiBack("main")
]

medCardMenuComponents := [
    uiTitle("Загальне"),
    uiText("Температура"),
    uiText("Горло"),
    uiText("Легені"),
    uiText("Виписати Мед. Карту"),
    uiBack("main")
]

pricesMenuComponents := [
    uiTitle("Прайс лист"),
    uiText("Вітамінка:"),
    uiText("   Громадяни - 500$"),
    uiText("   Співробітники EMS - 100$"),
    uiText("Вітамінка (/heal):"),
    uiText("   Громадяни - 500$"),
    uiText("   Співробітники EMS - 1$"),
    uiText("Блістер (5шт):"),
    uiText("   Громадяни - 2000$"),
    uiText("   Співробітники EMS - 1000$"),
    uiText("Мед. карта:"),
    uiText("   Громадяни - 20.000$"),
    uiText("   GOV/LSPD/NG - 15.000$"),
    uiText("   Співробітники EMS - 10.000$"),
    uiBack("main")
]

surgeonComponents := [
    uiTitle("Хірургія"),
    uiText("Дослідження"),
    uiText("Гінекологія"),
    uiText("Проктологія"),
    uiText("Урологія"),
    uiText("Отоларингологія"),
    uiText("Офтальмологія"),
    uiText("Наркологія"),
    uiText("Стоматологія"),
    uiText("Операційна"),
    uiBack("main")
]

stomatologyComponents := [
    uiText("Огляд | 10k"),
    uiText("Пломбування | 20k"),
    uiText("Огляд. Установ. брекетів"),
    uiText("Установка беркетів | 75k"),
    uiText("Професійна чистка"),
    uiText("Видалення зуба | 35k"),
    uiText("Онтопантомограма"),
]

analysisComponents := [
    uiText("Аналіз Крові"),
    uiText("Флюорографія"),
    uiText("Рентген"),
    uiText("ДНК Тест"),
]

global mainGui := 0
global surgeonMenu := 0
global stomatologyMenu := 0

global menus := Map(
    "main", Map(
        "components", mainMenuComponents,
        "gui", 0,
        "isVisible", false
    ),
    "common", Map(
        "components", commonMenuComponents,
        "gui", 0,
        "isVisible", false
    ),
    "medcard", Map(
        "components", medCardMenuComponents,
        "gui", 0,
        "isVisible", false
    ),
    "prices", Map(
        "components", pricesMenuComponents,
        "gui", 0,
        "isVisible", false
    ),
    "surgeon", Map(
        "components", surgeonComponents,
        "gui", 0,
        "isVisible", false
    ),
)

AppsKey::toggleMedicUiVisibility()

toggleMedicUiVisibility(){
    global menus

    if (isAnyMenuVisible()){
        hideAllMenus()
    } else {
        showMenu("main")
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
; Shows menu with name defined
; 
showMenu(name) {
    global menus

    hideAllMenus()

    if (IsObject(menus[name]["gui"])) {
        menus[name]["gui"].Show()
        menus[name]["isVisible"] := true
    } else {
        menus[name]["gui"] := buildUiMenu(menus[name]["components"])
        menus[name]["isVisible"] := true
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


; ====================================================================
; Returns map for text UI component build
;
uiText(text, onClickHandler := 0){
    return Map(
        "type", "text",
        "text", text,
        "onClickHandler", onClickHandler
    )
}


; ====================================================================
; Returns map for title UI component build
;
uiTitle(text) {
    return Map(
        "type", "title",
        "text", text,
        "onClickHandler", unset
    )
}


; ====================================================================
; Returns map for back button UI component build
;
uiBack(backMenuName) {
    return Map(
        "type", "back",
        "text", "Назад",
        "onClickHandler", () => handleMenuClick(backMenuName)
    )
}


; ====================================================================
; Returns map for divider UI component build
;
uiDivider() {
    return Map(
        "type", "divider",
        "text", "",
        "onClickHandler", unset
    )
}


; ====================================================================
; Appends Text widget to GUI Object
;
appendText(menuGui, component){
    menuGui.SetFont(TEXT_SIZE " " TEXT_COLOR)
    uiComponent := menuGui.Add("Text",,component["text"])
    if (IsObject(component["onClickHandler"])) {
        uiComponent.OnEvent("Click", (*) => component["onClickHandler"].Call())
    }
}


; ====================================================================
; Appends Title widget to GUI Object
;
appendTitle(menuGui, component){
    menuGui.SetFont(TITLE_TEXT_SIZE " " TITLE_TEXT_COLOR)
    menuGui.Add("Text",,component["text"])
    menuGui.Add("Progress", "h1 " DIVIDER_COLOR " -Smooth", "100")
}


; ====================================================================
; Appends Back widget to GUI Object
;
appendBack(menuGui, component){
    menuGui.SetFont(TEXT_SIZE " " BACK_COLOR)
    menuGui.Add("Progress", "h1 " DIVIDER_COLOR " -Smooth", "100")
    uiComponent := menuGui.Add("Text",,component["text"])
    if (IsObject(component["onClickHandler"])) {
        uiComponent.OnEvent("Click", (*) => component["onClickHandler"].Call())
    }
}


; ====================================================================
; Appends Divider widget to GUI Object
;
appendDivider(menuGui, component){
    menuGui.Add("Progress", "h1 " DIVIDER_COLOR " -Smooth", "100")
}


; ====================================================================
; Appends menu GUI Object and shows it
;
buildUiMenu(components) {
    menuGui := Gui()
    menuGui.Opt("+AlwaysOnTop +SysMenu -Caption -DPIScale +ToolWindow +Border +Owner")
    menuGui.BackColor := BACKGROUND_COLOR

    Loop components.Length
        {
            component := components[A_Index]
            if (component["type"] == "text") {
                appendText(menuGui, component)
            } else if (component["type"] == "title"){
                appendTitle(menuGui, component)
            } else if (component["type"] == "back"){
                appendBack(menuGui, component)
            } else if (component["type"] == "divider"){
                appendDivider(menuGui, component)
            }
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


; ====================================================================
; Closes all visible GUI menus and opens a new one by name passed.
;
handleMenuClick(name){
    hideAllMenus()
    showMenu(name)
}
