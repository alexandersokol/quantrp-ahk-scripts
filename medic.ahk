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

TIMER_DELAY := 10

Alarm_Chat_Type() {
    SetTimer , 0
    Chat_Type("/rb ") 
}

Alarm_Badge() {
    SetTimer , 0
    Sequence_Play("\medic-menu\1. Загальне\5. Бейджик.txt")
}


Alarm_Blister() {
    SetTimer , 0
    Sequence_Play("\medic-menu\1. Загальне\4. Блістер.txt")
}

Alarm_Tablet() {
    SetTimer , 0
    Sequence_Play("\medic-menu\1. Загальне\3. Вітамінка.txt")
}

Alarm_Donor() {
    SetTimer , 0
    Sequence_Play("\medic-menu\1. Загальне\2. Донор крові.txt")
}

Alarm_Reanimation() {
    SetTimer , 0
    Sequence_Play("\medic-menu\1. Загальне\1. Реанімація.txt")
}

Alarm_Heal() {
    SetTimer , 0
    Chat_Type("/heal ")
}

Alarm_Blood() {
    SetTimer , 0
    Chat_Type("/blood ")
}

Alarm_Me() {
    SetTimer , 0
    Chat_Type("/me ")
}

Alarm_Do() {
    SetTimer , 0
    Chat_Type("/do ")
}

Alarm_Try() {
    SetTimer , 0
    Chat_Type("/try ")
}

Alarm_Click_And_Reanimate() {
    SetTimer , 0
    Click_And_Reanimate()
}

#HotIf IsGameActive()
    <^::return
    \::Take_ScreenShot()

    ; *^R::SetTimer(Alarm_Chat_Type, TIMER_DELAY)

    AppsKey & R::SetTimer(Alarm_Chat_Type, TIMER_DELAY)

    ; *^q::SetTimer(Alarm_Badge, TIMER_DELAY)
    ; *^=::SetTimer(Alarm_Blister, TIMER_DELAY)
    ; *^-::SetTimer(Alarm_Tablet, TIMER_DELAY)
    ; *^0::SetTimer(Alarm_Donor, TIMER_DELAY)
    ; *^9::SetTimer(Alarm_Reanimation, TIMER_DELAY)

    AppsKey & q::SetTimer(Alarm_Badge, TIMER_DELAY)
    AppsKey & =::SetTimer(Alarm_Blister, TIMER_DELAY)
    AppsKey & -::SetTimer(Alarm_Tablet, TIMER_DELAY)
    AppsKey & 0::SetTimer(Alarm_Donor, TIMER_DELAY)
    AppsKey & 9::SetTimer(Alarm_Reanimation, TIMER_DELAY)


    ; *^h::SetTimer(Alarm_Heal, TIMER_DELAY)
    ; *^b::SetTimer(Alarm_Blood, TIMER_DELAY)
    ; *^m::SetTimer(Alarm_Me, TIMER_DELAY)
    ; *^d::SetTimer(Alarm_Do, TIMER_DELAY)
    ; *^t::SetTimer(Alarm_Try, TIMER_DELAY)

    AppsKey & h::SetTimer(Alarm_Heal, TIMER_DELAY)
    AppsKey & b::SetTimer(Alarm_Blood, TIMER_DELAY)
    AppsKey & m::SetTimer(Alarm_Me, TIMER_DELAY)
    AppsKey & d::SetTimer(Alarm_Do, TIMER_DELAY)
    AppsKey & t::SetTimer(Alarm_Try, TIMER_DELAY)

    XButton1::SetTimer(Alarm_Click_And_Reanimate, TIMER_DELAY)

    ; ^PgUp::Sequence_Play("\medic-menu\2. Мед. Карта\1. Температура.txt")
    ; ^PgDn::Sequence_Play("\medic-menu\2. Мед. Карта\2. Горло.txt")
    ; ^Home::Sequence_Play("\medic-menu\2. Мед. Карта\3. Легені.txt")
    ; ^End::Sequence_Play("\medic-menu\2. Мед. Карта\4. Виписати карту.txt")

    ; >^x::Sequence_Play("\medic-menu\1. Загальне\6. Немає тіла.txt")

    AppsKey & PgUp::Sequence_Play("\medic-menu\2. Мед. Карта\1. Температура.txt")
    AppsKey & PgDn::Sequence_Play("\medic-menu\2. Мед. Карта\2. Горло.txt")
    AppsKey & Home::Sequence_Play("\medic-menu\2. Мед. Карта\3. Легені.txt")
    AppsKey & End::Sequence_Play("\medic-menu\2. Мед. Карта\4. Виписати карту.txt")

    AppsKey & x::Sequence_Play("\medic-menu\1. Загальне\6. Немає тіла.txt")

    `::toggleMedicUiVisibility()
#HotIf

; ^q::Sequence_Log_All()

Click_And_Reanimate(){
    Click
    Sleep(700)
    Sequence_Play("\medic-menu\1. Загальне\1. Реанімація.txt")
}

