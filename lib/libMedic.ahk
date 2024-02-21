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

        if map["delay_before"] > 0
            Sleep(map["delay_before"])

        Chat_Say(map["text"])

        if map["delay_after"] > 0
            Sleep(map["delay_after"])
    }
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
    Log("CantFindABody triggered")
    PlainTextSay(CANT_FIND_A_BODY_VARIATIONS)
}
