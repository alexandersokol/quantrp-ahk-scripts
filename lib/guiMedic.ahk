#Requires AutoHotkey v2.0

#Include "libMedic.ahk"

TITLE_TEXT_COLOR := "cffffff"
TITLE_TEXT_SIZE := "s12"

TEXT_COLOR := "cffffff"
TEXT_SIZE := "s12"

BACK_COLOR := "cffffff"
TEXT_SIZE := "s12"

DIVIDER_COLOR := "c515151"
BACKGROUND_COLOR := "c000000"

global GTAWindowID := 0

mainMenuComponents := [
    uiText("Загальне", () => GuiHandle_MenuClick("common")),
    uiText("Мед. карта", () => GuiHandle_MenuClick("medcard")),
    uiText("Прайс лист", () => GuiHandle_MenuClick("prices")),
    uiText("Хірургія", () => GuiHandle_MenuClick("surgeon")),
    uiText("Музика", () => GuiHandle_MenuClick("music"))
    uiText("Скріншот", () => GuiHandle_ClickAndHide(Take_ScreenShot)),
    uiDivider(),
    uiText("Закрити", () => hideAllMenus())
]
 
commonMenuComponents := [
    uiTitle("Загальне"),
    uiText("Жетон {LCtrl + Q}", () => GuiHandle_ClickAndHide(Medic_ShowBadge)),
    uiText("Реанімація {LCtrl + 9}", () => GuiHandle_ClickAndHide(Medic_Reanimation)),
    uiText("Приняти кров {LCtrl + 0}", () => GuiHandle_ClickAndHide(Medic_BloodDonation)),
    uiText("Вітамінка {LCtrl + -}", () => GuiHandle_ClickAndHide(Medic_SellVitamins)),
    uiText("Блістер {LCtrl + =}", () => GuiHandle_ClickAndHide(Medic_SellBlister)),
    uiText("Немає тіла {LCtrl + X}", () => GuiHandle_ClickAndHide(Medic_CantFindABody)),
    uiBack("main")
]

medCardMenuComponents := [
    uiTitle("Загальне"),
    uiText("Температура", () => GuiHandle_ClickAndActive(Medic_MedCard_Temperature)),
    uiText("Горло", () => GuiHandle_ClickAndActive(Medic_MedCard_Throat)),
    uiText("Легені",  () => GuiHandle_ClickAndActive(Medic_MedCard_Lungs)),
    uiText("Виписати Мед. Карту",  () => GuiHandle_ClickAndActive(Medic_MedCard_Sign)),
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
    uiText("Дослідження", () => GuiHandle_MenuClick("analysis")),
    uiText("Гінекологія"),
    uiText("Проктологія"),
    uiText("Урологія"),
    uiText("Отоларингологія"),
    uiText("Офтальмологія", () => GuiHandle_MenuClick("analysis")),
    uiText("Наркологія"),
    uiText("Стоматологія",  () => GuiHandle_MenuClick("stomatology")),
    uiText("Операційна", () => GuiHandle_MenuClick("operation")),
    uiBack("main")
]

stomatologyComponents := [
    uiTitle("Стоматологія")
    uiText("Огляд | 10k", () => GuiHandle_ClickAndHide(Medic_Stomatology_ToothCheck)),
    uiText("Пломбування | 20k"),
    uiText("Огляд. Установ. брекетів",  () => GuiHandle_ClickAndHide(Medic_Stomatology_BracketCheck)),
    uiText("Установка беркетів | 75k"),
    uiText("Професійна чистка",  () => GuiHandle_ClickAndHide(Medic_Stomatology_ToothCleaning)),
    uiText("Видалення зуба | 35k", () => GuiHandle_ClickAndHide(Medic_Stomatology_ToothRemoval)),
    uiText("Онтопантомограма", () => GuiHandle_ClickAndHide(Medic_Stomatology_ToothXRay)),
    uiBack("surgeon")
]

analysisComponents := [
    uiTitle("Дослідження")
    uiText("Аналіз Крові", () => GuiHandle_ClickAndHide(Medic_Analysis_Blood)),
    uiText("Флюорографія"),
    uiText("Рентген"),
    uiText("ДНК Тест"),
    uiText("МРТ"),
    uiBack("surgeon")
]

operationComponents := [
    uiTitle("Операційна")
    uiText("Пластична операція | 200k", () => GuiHandle_ClickAndHide(Medic_Surgery_Plastic())),
    uiBack("surgeon")
]

oftalmologyComponents := [
    uiTitle("Офтальмологія")
    uiText("Перевірка очного дна праве око | 7.5k", () => GuiHandle_ClickAndHide(Medic_Oculist_RightEyeCheck)),
    uiText("Перевірка очного дна ліве око | 7.5k", () => GuiHandle_ClickAndHide(Medic_Oculist_LeftEyeCheck)),
    uiBack("surgeon")
]

musicComponents := [
    uiTitle("Музика"),
    uiText("Mashle and Mucles Intro", () => GuiHandle_ClickAndSend("https://audio.jukehost.co.uk/rfBTjOGmE5fWNIyP4Gb7BhOeYjpGOFck")),
    uiText("Royel Otis - Murder on the dancefloor", () => GuiHandle_ClickAndSend("https://audio.jukehost.co.uk/0IhrREN0Sx40JrlWTb5sP5s5WLHxqMaI")),
    uiText("Metallica - Playlist", () => GuiHandle_ClickAndSend("https://audio.jukehost.co.uk/PcV56mwN95FdoNAbNbxRtzFKGIZRKocq")),
    uiText("Synthwave Retro - Playlist", () => GuiHandle_ClickAndSend("https://audio.jukehost.co.uk/IYGPz6HlkjZKruhQDnceJeGcUGDvw04S")),
    uiText("", () => GuiHandle_ClickAndSend("")),
    uiBack("main")
]

emojiComponents := [
    uiText("❤"),
    uiText(""),
    uiText(""),
    uiText(""),
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
    "analysis", Map(
        "components", analysisComponents,
        "gui", 0,
        "isVisible", false
    ),
    "operation", Map(
        "components", operationComponents,
        "gui", 0,
        "isVisible", false
    ),
    "oftalmology", Map(
        "components", oftalmologyComponents,
        "gui", 0,
        "isVisible", false
    ),
    "music", Map(
        "components", musicComponents,
        "gui", 0,
        "isVisible", false
    ),
    "stomatology", Map(
        "components", stomatologyComponents,
        "gui", 0,
        "isVisible", false
    ),
)

`::toggleMedicUiVisibility()

toggleMedicUiVisibility(){
    global menus

    Sleep(200)

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
        "onClickHandler", () => GuiHandle_MenuClick(backMenuName)
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
    global GTAWindowID := WinActive("A")
    menuGui.Opt("+AlwaysOnTop +SysMenu -Caption -DPIScale +ToolWindow +Border +Parent" GTAWindowID)
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
; Activate GTA 5 Game and hides menus
;
activateAndHideMenu(){
    global GTAWindowID
    WinActivate(GTAWindowID)
    hideAllMenus()
}


; ====================================================================
; Closes all visible GUI menus and opens a new one by name passed.
;
GuiHandle_MenuClick(name){
    hideAllMenus()
    showMenu(name)
}


; ====================================================================
; Takes screenshot from menu
;
GuiHandle_Screenshot() {
    activateAndHideMenu()
    Take_ScreenShot()
}


; ====================================================================
; Hides menu and calls a function
;
GuiHandle_ClickAndHide(func) {
    activateAndHideMenu()
    func.Call()
}


; ====================================================================
; Makes game active and calls a function
;
GuiHandle_ClickAndActive(func) {
    global GTAWindowID
    WinActivate(GTAWindowID)
    func.Call()
}


; ====================================================================
; Hides menu and sends a message
;
GuiHandle_ClickAndSend(message) {
    activateAndHideMenu()
    Sleep(100)
    SendInput(message)
}