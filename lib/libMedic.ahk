#Requires AutoHotkey v2.0

#Include "libCommon.ahk"
#Include "textMedic.ahk"

SCREENSHOT_DRUGS_DIR := DEFAULT_SCREENSHOT_DIR_PATH . "\drugs"
SCREENSHOT_VITAMIN_DIR := SCREENSHOT_DRUGS_DIR
SCREENSHOT_REANIMATION_DIR := DEFAULT_SCREENSHOT_DIR_PATH . "\reanimation"
SCREENSHOT_BLOOD_DONATION_DIR := DEFAULT_SCREENSHOT_DIR_PATH . "\blood-donation"
SCREENSHOT_PREMIUM_DIR := DEFAULT_SCREENSHOT_DIR_PATH . "\premium"


; ====================================================================
; Plays text variation from given array
;
PlainTextSay(variationsArray) {
    variation := RandomItem(variationsArray)
    Loop variation.Length
    {
        map := variation[A_Index]

       if (map["type"] == "text") {
            PlainPlayText(map)    
       }
       else if (map["type"] == "delay") {
            PlainPlayDelay(map)
       } else if (map["type"] == "screenshot") {
            PlainPlayScreenshot(map)
       }
    }
}


; ====================================================================
; Plays text variation
;
PlainPlayText(map) {
    if map["delay_before"] > 0
        Sleep(map["delay_before"])

    Chat_Say(map["text"])

    if map["delay_after"] > 0
        Sleep(map["delay_after"])
}


; ====================================================================
; Plays delay variation
;
PlainPlayDelay(map) {
    if map["delay_before"] > 0
        Sleep(map["delay_before"])
}


; ====================================================================
; Plays screenshot variation
;
PlainPlayScreenshot(map) {
    if map["delay_before"] > 0
        Sleep(map["delay_before"])

    Sleep(200)
    Take_ScreenShot()

    if map["delay_after"] > 0
        Sleep(map["delay_after"])
}


; ====================================================================
; Plays show doctors badge random variation
;
Medic_ShowBadge() {
    Log("Showing doctor's badge triggred")
    PlainTextSay(BADGE_VARIATIONS)
}


; ====================================================================
; Plays selling drugs blister random variation
;
Medic_SellBlister() {
    Log("Selling drugs blister triggred")
    Take_ScreenShot_DateDir(SCREENSHOT_DRUGS_DIR)
    PlainTextSay(DRUGS_BLISTER_VARIATIONS)
}


; ====================================================================
; Plays selling vitamins random variation
;
Medic_SellVitamins() {
    Log("Selling vitamins triggred")
    Take_ScreenShot_DateDir(SCREENSHOT_VITAMIN_DIR)
    PlainTextSay(DRUGS_VITAMIN_VARIATIONS)
}


; ====================================================================
; Plays blood donation random variation
;
Medic_BloodDonation() {
    Log("Blood donation triggred")
    PlainTextSay(BLOOD_DONATION_VARIATIONS)
}


; ====================================================================
; Plays random random variation.
; Saves screenshot for permium and report.
;
Medic_Reanimation()
{
    Log("Reanimation triggred")
    PlainTextSay(REANIMATION_VARIATIONS)
    Sleep(300)
    screenshotFile := Take_ScreenShot_DateDir(SCREENSHOT_REANIMATION_DIR)

    currentDayOfWeek := A_WDay
    currentHour := A_Hour
    currentMinute := A_Min

    minuteTrail := 0
    if (currentDayOfWeek == 1 || currentDayOfWeek == 7) ; 1 - Sunday, 7 - Saturday
    {
        minuteTrail := 59
    }

    dayShift := "night"

    if (currentHour >= 11 && currentHour < 23){
        dayShift := "day"
    } else {
        if (currentHour == 23 && currentMinute <= minuteTrail){
            dayShift := "day"
        } else {
            dayShift := "night"
        }
    }

    CurrentDate := FormatTime(A_Now ,"dd.MM.yyyy")
    outputDir := SCREENSHOT_PREMIUM_DIR . "\" . CurrentDate . "\" . dayShift
    
    if not DirExist(outputDir)
        DirCreate outputDir

    outputFile := SCREENSHOT_PREMIUM_DIR . "\" . CurrentDate . "\" . dayShift . "\*.*"

    FileCopy screenshotFile, outputFile
}


; ====================================================================
; Clicks on current mouse position and starts reanimation
;
Medic_ReanimationClick(){
    Click
    Sleep(700)
    Medic_Reanimation()
}


; ====================================================================
; Plays random text variation for medcard temperature check
;
Medic_MedCard_Temperature(){
    Log("Med Card pyrometer triggered")
    PlainTextSay(MED_CARD_TEMPERATURE_CHECK_VARIATIONS)
}


; ====================================================================
; Plays random text variation for medcard throat check
;
Medic_MedCard_Throat(){
    Log("Med Card throat triggered")
    PlainTextSay(MED_CARD_THROAT_CHECK_VARIATIONS )
}


; ====================================================================
; Plays random text variation for medcard lungs check
;
Medic_MedCard_Lungs(){
    Log("Med Card fonendoscope triggered")
    PlainTextSay(MED_CARD_LUNGS_CHECK_VARIATIONS)
}


; ====================================================================
; Plays random text variation for medcard signing
;
Medic_MedCard_Sign(){
    Log("Med Card sign triggered")
    PlainTextSay(MED_CARD_SIGN_VARIATIONS)
}


; ====================================================================
; Plays random text variation while can't find a body on acident
;
Medic_CantFindABody(){
    Log("Medic_CantFindABody triggered")
    PlainTextSay(CANT_FIND_A_BODY_VARIATIONS)
}


; ====================================================================
; Plays random text variation for blood analysis and shows result
;
Medic_Analysis_Blood() {
    Log("Medic_Analysis_Blood triggered")
    PlainTextSay(ANALYSIS_BLOOD_VARIATIONS)
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
}


; ====================================================================
; Plays random text variation for plastic surgery
;
Medic_Surgery_Plastic() {
    Log("Medic_Surgery_Plastic triggered")
    PlainTextSay(PLASCTIC_SURGERY_VARIATIONS)
}


; ====================================================================
; Plays random text variation for oculist right eye check
;
Medic_Oculist_RightEyeCheck() {
    Log("Medic_Oculist_RightEyeCheck triggered")
    PlainTextSay(OCULIST_RIGHT_EYE_CHECK_VARIATIONS)
}


; ====================================================================
; Plays random text variation for oculist right eye check
;
Medic_Oculist_LeftEyeCheck() {
    Log("Medic_Oculist_LeftEyeCheck triggered")
    PlainTextSay(OCULIST_LEFT_EYE_CHECK_VARIATIONS)
}


; ====================================================================
; Plays random text variation for stomatology tooth check
;
Medic_Stomatology_ToothCheck() {
    Log("Medic_Stomatology_ToothCheck triggered")
    PlainTextSay(STOMATOLOGY_TOOTH_CHECK_VARIATIONS)
}


; ====================================================================
; Plays random text variation for stomatology bracket check
;
Medic_Stomatology_BracketCheck() {
    Log("Medic_Stomatology_BracketCheck triggered")
    PlainTextSay(STOMATOLOGY_BRACKETS_CHECK_VARIATIONS)
}


; ====================================================================
; Plays random text variation for stomatology tooth cleaning
;
Medic_Stomatology_ToothCleaning() {
    Log("Medic_Stomatology_ToothCleaning triggered")
    PlainTextSay(STOMATOLOGY_TOOTH_CLEANING_VARIATIONS)
}


; ====================================================================
; Plays random text variation for stomatology tooth removal
;
Medic_Stomatology_ToothRemoval() {
    Log("Medic_Stomatology_ToothRemoval triggered")
    PlainTextSay(STOMATOLOGY_TOOTH_REMOVAL_VARIATIONS)
}


; ====================================================================
; Plays random text variation for stomatology tooth X-RAY
;
Medic_Stomatology_ToothXRay() {
    Log("Medic_Stomatology_ToothXRay triggered")
    PlainTextSay(STOMATOLOGY_TOOTH_X_RAY)
}


; ====================================================================
; Plays random text variation for stomatology brackets setup
;
Medic_Stomatology_BracketSetups() {
    Log("Medic_Stomatology_BracketSetup triggered")
    PlainTextSay(STOMATOLOGY_BRACKETS_SETUP)
}


; ====================================================================
; Plays random text variation for stomatology tooth heal
;
Medic_Stomatology_ToothHeal() {
    Log("Medic_Stomatology_ToothHeal triggered")
    PlainTextSay(STOMATOLOGY_TOOTH_HEAL)
}