#Requires AutoHotkey v2.0

#Include "_JXON.ahk"
#Include "libCommon.ahk"

MEDIC_PREFERENCES_FILE_PATH := A_WorkingDir . "\preferences.json"

global medicPreferences := Map()

Preferences_IsValid() {
    global medicPreferences

    return medicPreferences.Has("name") && 
        medicPreferences.Has("surname") &&
        medicPreferences.Has("rank") &&
        medicPreferences.Has("staticId") &&
        medicPreferences.Has("gender") &&
        StrLen(medicPreferences.Get("name")) > 0 &&
        StrLen(medicPreferences.Get("surname")) > 0 &&
        StrLen(medicPreferences.Get("rank")) > 0 &&
        StrLen(medicPreferences.Get("staticId")) > 0 &&
        StrLen(medicPreferences.Get("gender")) > 0
}

Preferences_Load() {
    global medicPreferences
    
    try {
        json := FileRead(MEDIC_PREFERENCES_FILE_PATH, "UTF-8")
        medicPreferences := Jxon_Load(&json)
    }

    if (!Preferences_IsValid()) {
        medicPreferences.Set("name", "")
        medicPreferences.Set("surname", "")
        medicPreferences.Set("rank", "")
        medicPreferences.Set("staticId", "")
        medicPreferences.Set("gender", "")
    }
}

Preferences_Save(name, surname, rank, staticId, gender) {
    global medicPreferences := Map(
        "name", name,
        "surname", surname,
        "rank", rank,
        "staticId", staticId,
        "gender", gender
    )

    json := Jxon_Dump(medicPreferences, indent := 0)

    try {
        FileDelete MEDIC_PREFERENCES_FILE_PATH
    }
    FileAppend(json, MEDIC_PREFERENCES_FILE_PATH, "UTF-8")
}

Preferences_Load()