#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "lib\libCommon.ahk"
#Include "lib\guiMedic.ahk"
#Include "lib\guiMedicSetup.ahk"

Persistent true

if (Preferences_IsValid()) {
    requestAdminRights()
} else {
    Medic_PreferencesSetup(() => requestAdminRights())
}


#HotIf IsGameActive()
    ^R::Chat_Type("/rb ")         ; Ctrl + R - Open chat and print /rb 

    \::Take_ScreenShot()
    ^q::Sequence_Play("\medic-menu\1. Загальне\5. Бейджик.txt")
    ^=::Sequence_Play("\medic-menu\1. Загальне\4. Блістер.txt")
    ^-::Sequence_Play("\medic-menu\1. Загальне\3. Вітамінка.txt")
    ^0::Sequence_Play("\medic-menu\1. Загальне\2. Донор крові.txt")
    ^9::Sequence_Play("\medic-menu\1. Загальне\1. Реанімація.txt")
    ^h::Chat_Type("/heal ")
    ^b::Chat_Type("/blood ")
    ^m::Chat_Type("/me ")
    ^d::Chat_Type("/do ")
    ^t::Chat_Type("/try ")
    XButton1::Click_And_Reanimate()

    ^PgUp::Sequence_Play("\medic-menu\2. Мед. Карта\1. Температура.txt")
    ^PgDn::Sequence_Play("\medic-menu\2. Мед. Карта\2. Горло.txt")
    ^Home::Sequence_Play("\medic-menu\2. Мед. Карта\3. Легені.txt")
    ^End::Sequence_Play("\medic-menu\2. Мед. Карта\4. Виписати карту.txt")

    >^x::Sequence_Play("\medic-menu\1. Загальне\6. Немає тіла.txt")

    `::toggleMedicUiVisibility()
#HotIf

; ^q::Sequence_Log_All()

Click_And_Reanimate(){
    Click
    Sleep(700)
    Sequence_Play("\medic-menu\1. Загальне\1. Реанімація.txt")
}

