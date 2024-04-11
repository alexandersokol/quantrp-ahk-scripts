#Requires AutoHotkey v2.0

#Include "libCommon.ahk"
#Include "libMedicSetup.ahk"

; GENDER := "M" ; M - Male, F - Female

; DOCTOR_RANK := "7"
; DOCTOR_NAME := "Alex Aspero"
; STATIC_ID := "46746"

DOCTOR_RANK := medicPreferences["rank"]
DOCTOR_NAME := medicPreferences["name"] " " medicPreferences["surname"]
STATIC_ID := medicPreferences["staticId"]
GENDER := medicPreferences["gender"]

DOCTORS_BADGE := "[EMS | " DOCTOR_RANK " | " DOCTOR_NAME " | № " STATIC_ID "]"

BADGE_PLAY_TEXT := "/b Йой! Я забув налаштувати бейджик в біндері!"
if (Preferences_IsValid()) {
    BADGE_PLAY_TEXT := "/do На грудях закріплений бейджик " DOCTORS_BADGE
}

REPORT_DIR := DEFAULT_SCREENSHOT_DIR_PATH . "\report"
REANIMATIONS_DIR := "reanimations"
SURGEON_DIR := "surgeon"
DRUGS_DIR := "drugs"

TEXT_CONST_YEAR := "{year}" ; year 2024
TEXT_CONST_DAY := "{day}" ; day 7
TEXT_CONST_DAY2 := "{day2}" ; day 07
TEXT_CONST_MONTH := "{month}" ; month 2
TEXT_CONST_MONTH2 := "{month2}" ; month 02
TEXT_CONST_HOURS := "{hours}" ; hours 9
TEXT_CONST_HOURS2 := "{hours2}" ; hours 09
TEXT_CONST_MINUTES := "{minutes}" ; minutes 2
TEXT_CONST_MINUTES2 := "{minutes2}" ; minutes 02
TEXT_CONST_SECONDS := "{seconds}" ; seconds 2
TEXT_CONST_SECONDS2 := "{seconds2}" ; seconds 02
TEXT_CONST_DATE := "{date}" ; 10.04.2024
TEXT_CONST_TIME := "{time}" ; 11:30
TEXT_CONST_DATE_TIME := "{datetime}" ; 11:30 10.04.2024
TEXT_CONST_RANDOM_10 := "{random_10}" ; 10
TEXT_CONST_RANDOM_100 := "{random_100}" ; 10
TEXT_CONST_RANDOM_1000 := "{random_1000}" ; 100

Medic_GetReportWeekName() {
    currentDayOfWeek := A_WDay

    workWeekDir := "-"
    startTimeDiff := 0
    endTimeDiff := 0

    if (currentDayOfWeek == 7) { ; Saturday
        startTimeDiff := 0
        endTimeDiff := 6
    } else {
        startTimeDiff := currentDayOfWeek
        endTimeDiff := 6 - currentDayOfWeek
    }

    weekStartTime := DateAdd(A_Now, -startTimeDiff, "Days")
    weekEndTime := DateAdd(A_Now, endTimeDiff, "Days")

    startFormat := FormatTime(weekStartTime ,"dd.MM")
    endFormat := FormatTime(weekEndTime ,"dd.MM.yyyy")

    return startFormat "-" endFormat
}

GetReportWeekDir(subdir := 0) {
    if (subdir == 0) {
        return REPORT_DIR "\" Medic_GetReportWeekName()
    }
    return REPORT_DIR "\" Medic_GetReportWeekName() "\" subdir
}


Medic_Analysis_Blood_Random() {
    Log("Medic_Analysis_Blood triggered")
    Sleep(1000)

    ; Hb
    gemoglobin_min := 12.1
    gemoglobin_max := 17.2
    gemoglobin_min_v := 10.0
    gemoglobin_max_v := 20.0

    gemoglobin_value := Round(Random(gemoglobin_min_v * 10, gemoglobin_max_v * 10) / 10.0, 2)
    gemoglobin_result := "Норма"

    if (gemoglobin_value > gemoglobin_max) {
        gemoglobin_result := "Гіпергемія - недостатня гідратація організму"
    } else if (gemoglobin_value < gemoglobin_min){
        gemoglobin_result := "Анемія: Залізодефіцит/мало вітаміну B12"
    }

    gemoglobin_text := "Гемоглобін (Hb): " gemoglobin_value "г/дл (" Round(gemoglobin_min, 2) " - " Round(gemoglobin_max, 2) ") - " gemoglobin_result

    ; RBC
    eretrotzit_min := 3.9
    eretrotzit_max := 5.72
    eretrotzit_min_v := 3.0
    eretrotzit_max_v := 6.5

    eretrotzit_value := Round(Random(eretrotzit_min_v * 10, eretrotzit_max_v * 10) / 10.0, 2)
    eretrotzit_result := "Норма"

    if (eretrotzit_value > eretrotzit_max) {
        eretrotzit_result := "Гіпергемія - недостатня гідратація організму" ;гіпергемія
    } else if (eretrotzit_value < eretrotzit_min){
        eretrotzit_result := "Анемія: Залізодефіцит/мало вітаміну B12" ;анемія
    }

    eretrotzit_text := "Еритроцити (RBC): " eretrotzit_value "млн/мкл (" Round(eretrotzit_min, 2) " - " Round(eretrotzit_max, 2) ") - " eretrotzit_result

    ; WBC
    leikozit_min := 4.5
    leikozit_max := 11.0
    leikozit_min_v := 4.0
    leikozit_max_v := 12.0

    leikozit_value := Round(Random(leikozit_min_v * 10, leikozit_max_v * 10) / 10.0, 2)
    leikozit_result := "Норма"

    if (leikozit_value > leikozit_max) {
        leikozit_result := "Лейкоцитоз: Інфекція/Стрес/Алергія" ; лейкоцитоз
    } else if (leikozit_value < leikozit_min){
        leikozit_result := "Лейкопенія: Інфекція/Препарати" ; лейкопенія
    }

    leikozit_text := "Лейкоцити (WBC): " leikozit_value "тис./мкл (" Round(leikozit_min, 2) " - " Round(leikozit_max, 2) ") - " leikozit_result

    ; PLT
    trombozit_min := 150
    trombozit_max := 450
    trombozit_min_v := 100
    trombozit_max_v := 550

    trombozit_value := Round(Random(trombozit_min_v * 10, trombozit_max_v * 10) / 10)
    trombozit_result := "Норма"

    if (trombozit_value > trombozit_max) {
        trombozit_result := "Tромбоцитоз: Травми/Запальні захворювання" ; тромбоцитоз
    } else if (trombozit_value < trombozit_min){
        trombozit_result := "Tромбоцитопенія: Хрон. Хвороби/Препарати" ; тромбоцитопенія
    }

    trombozit_text := "Тромбоцити (PLT): " trombozit_value "тис./мкл (" trombozit_min " - " trombozit_max ") - " trombozit_result

    ; Hct
    gematocrit_min := 35
    gematocrit_max := 49
    gematocrit_min_v := 33
    gematocrit_max_v := 52

    gematocrit_value := Round(Random(gematocrit_min_v, gematocrit_max_v ))
    gematocrit_result := "Норма"

    if (gematocrit_value > gematocrit_max) {
        gematocrit_result := "Первинна поліцитемія" ; поліцитемія
    } else if (gematocrit_value < gematocrit_min){
        gematocrit_result := "Анемія: Залізодефіцитн/мало вітаміну B12" ; анемія
    }

    gematocrit_text := "Гематокрит (Hct): " gematocrit_value "% (" gematocrit_min " - " gematocrit_max ") - " gematocrit_result

    Chat_Do(gemoglobin_text)
    Sleep(1500)
    Chat_Do(eretrotzit_text)
    Sleep(1500)
    Chat_Do(leikozit_text)
    Sleep(1500)
    Chat_Do(trombozit_text)
    Sleep(1500)
    Chat_Do(gematocrit_text)
    Sleep(1500)
    Take_ScreenShot()
    PlaySound_Start()
}


Medic_Analysis_Blood_Ok() {
    Log("Medic_Analysis_Ok triggered")
    Sleep(1000)

    ; Hb
    gemoglobin_min := 12.1
    gemoglobin_max := 17.2
    gemoglobin_min_v := gemoglobin_min
    gemoglobin_max_v := gemoglobin_max

    gemoglobin_value := Round(Random(gemoglobin_min_v * 10, gemoglobin_max_v * 10) / 10.0, 2)
    gemoglobin_result := "Норма"

    if (gemoglobin_value > gemoglobin_max) {
        gemoglobin_result := "Гіпергемія - недостатня гідратація організму"
    } else if (gemoglobin_value < gemoglobin_min){
        gemoglobin_result := "Анемія: Залізодефіцит/мало вітаміну B12"
    }

    gemoglobin_text := "Гемоглобін (Hb): " gemoglobin_value "г/дл (" Round(gemoglobin_min, 2) " - " Round(gemoglobin_max, 2) ") - " gemoglobin_result

    ; RBC
    eretrotzit_min := 3.9
    eretrotzit_max := 5.72
    eretrotzit_min_v := eretrotzit_min
    eretrotzit_max_v := eretrotzit_max

    eretrotzit_value := Round(Random(eretrotzit_min_v * 10, eretrotzit_max_v * 10) / 10.0, 2)
    eretrotzit_result := "Норма"

    if (eretrotzit_value > eretrotzit_max) {
        eretrotzit_result := "Гіпергемія - недостатня гідратація організму" ;гіпергемія
    } else if (eretrotzit_value < eretrotzit_min){
        eretrotzit_result := "Анемія: Залізодефіцит/мало вітаміну B12" ;анемія
    }

    eretrotzit_text := "Еритроцити (RBC): " eretrotzit_value "млн/мкл (" Round(eretrotzit_min, 2) " - " Round(eretrotzit_max, 2) ") - " eretrotzit_result

    ; WBC
    leikozit_min := 4.5
    leikozit_max := 11.0
    leikozit_min_v := leikozit_min
    leikozit_max_v := leikozit_max

    leikozit_value := Round(Random(leikozit_min_v * 10, leikozit_max_v * 10) / 10.0, 2)
    leikozit_result := "Норма"

    if (leikozit_value > leikozit_max) {
        leikozit_result := "Лейкоцитоз: Інфекція/Стрес/Алергія" ; лейкоцитоз
    } else if (leikozit_value < leikozit_min){
        leikozit_result := "Лейкопенія: Інфекція/Препарати" ; лейкопенія
    }

    leikozit_text := "Лейкоцити (WBC): " leikozit_value "тис./мкл (" Round(leikozit_min, 2) " - " Round(leikozit_max, 2) ") - " leikozit_result

    ; PLT
    trombozit_min := 150
    trombozit_max := 450
    trombozit_min_v := trombozit_min
    trombozit_max_v := trombozit_max

    trombozit_value := Round(Random(trombozit_min_v * 10, trombozit_max_v * 10) / 10)
    trombozit_result := "Норма"

    if (trombozit_value > trombozit_max) {
        trombozit_result := "Tромбоцитоз: Травми/Запальні захворювання" ; тромбоцитоз
    } else if (trombozit_value < trombozit_min){
        trombozit_result := "Tромбоцитопенія: Хрон. Хвороби/Препарати" ; тромбоцитопенія
    }

    trombozit_text := "Тромбоцити (PLT): " trombozit_value "тис./мкл (" trombozit_min " - " trombozit_max ") - " trombozit_result

    ; Hct
    gematocrit_min := 35
    gematocrit_max := 49
    gematocrit_min_v := gematocrit_min
    gematocrit_max_v := gematocrit_max

    gematocrit_value := Round(Random(gematocrit_min_v, gematocrit_max_v ))
    gematocrit_result := "Норма"

    if (gematocrit_value > gematocrit_max) {
        gematocrit_result := "Первинна поліцитемія" ; поліцитемія
    } else if (gematocrit_value < gematocrit_min){
        gematocrit_result := "Анемія: Залізодефіцитн/мало вітаміну B12" ; анемія
    }

    gematocrit_text := "Гематокрит (Hct): " gematocrit_value "% (" gematocrit_min " - " gematocrit_max ") - " gematocrit_result

    Chat_Do(gemoglobin_text)
    Sleep(1500)
    Chat_Do(eretrotzit_text)
    Sleep(1500)
    Chat_Do(leikozit_text)
    Sleep(1500)
    Chat_Do(trombozit_text)
    Sleep(1500)
    Chat_Do(gematocrit_text)
    Sleep(1500)
    Take_ScreenShot()
    PlaySound_Start()
}


ConstantTextReplace(input){

    CurrentDateTime := FormatTime(A_Now ,"yyyy-MM-dd HH:mm:ss")

    result := StrReplace(input, TEXT_CONST_YEAR, A_YYYY)
    result := StrReplace(result, TEXT_CONST_DAY, FormatTime(A_Now ,"d"))
    result := StrReplace(result, TEXT_CONST_DAY2, A_DD)
    result := StrReplace(result, TEXT_CONST_MONTH, FormatTime(A_Now ,"M"))
    result := StrReplace(result, TEXT_CONST_MONTH2, A_MM)
    result := StrReplace(result, TEXT_CONST_HOURS, FormatTime(A_Now ,"H"))
    result := StrReplace(result, TEXT_CONST_HOURS2, A_Hour)
    result := StrReplace(result, TEXT_CONST_MINUTES, FormatTime(A_Now ,"m"))
    result := StrReplace(result, TEXT_CONST_MINUTES2, A_Min)
    result := StrReplace(result, TEXT_CONST_SECONDS, FormatTime(A_Now ,"s"))
    result := StrReplace(result, TEXT_CONST_SECONDS2, A_Sec)
    result := StrReplace(result, TEXT_CONST_DATE, FormatTime(A_Now ,"dd.MM.yyyy"))
    result := StrReplace(result, TEXT_CONST_TIME, FormatTime(A_Now ,"HH:mm"))
    result := StrReplace(result, TEXT_CONST_DATE_TIME, FormatTime(A_Now ,"HH:mm dd.MM.yyyy"))
    result := StrReplace(result, TEXT_CONST_RANDOM_10, Random(0, 10))
    result := StrReplace(result, TEXT_CONST_RANDOM_100, Random(0, 100))
    result := StrReplace(result, TEXT_CONST_RANDOM_1000, Random(0, 1000))

    return result
}

; ====================================================================
; Replaces gender related texts
;
GenderTextReplace(input) {
    start := InStr(input, "{")
    delimeter := InStr(input, "|")
    end := InStr(input, "}")

    if (start > 0 && delimeter > 0 && end > 0){
        origin := SubStr(input, start, end - start + 1)
        replace := ""

        if (GENDER == "M" || GENDER == "m") {
            replace := SubStr(input, start + 1, delimeter - start - 1)
        }
        else if  (GENDER == "F" || GENDER == "f"){
            replace := SubStr(input, delimeter + 1, end - delimeter - 1)
        } else {
            return input
        }

        return GenderTextReplace(StrReplace(input, origin, replace))
    }

    return input
}


; ====================================================================
; Replaces random related texts
;
RandomTextReplace(input) {
    start := InStr(input, "[")
    end := InStr(input, "]")

    if (start > 0 && end > 0){
        origin := SubStr(input, start, end - start + 1)

        replace := ""
        content := StrReplace(StrReplace(origin, "[", ""), "]", "") 

        if (StrLen(content) > 0){
            if (InStr(content, "|")){
                items := StrSplit(content, "|")
                if (items.Length > 0){
                    replace := RandomItem(items)
                }
            } else {
                replace := content
            }
        }
        
        return RandomTextReplace(StrReplace(input, origin, replace))
    }

    return input
}