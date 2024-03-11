#Requires AutoHotkey v2.0

#Include "libCommon.ahk"
#Include "textMedic.ahk"

REPORT_DIR := DEFAULT_SCREENSHOT_DIR_PATH . "\report"
REPORT_REANIMATIONS_PATH := "\reanimations"
REPORT_DRUGS_PATH := "\drugs"

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

; ====================================================================
; Plays text variation from given array
;
PlainTextSay(variationsArray) {
    global isActionsLocked := true

    variation := RandomItem(variationsArray)
    Loop variation.Length
    {
       map := variation[A_Index]

       if (!isActionsLocked)
        return

       if (map["type"] == "text") {
            PlainPlayText(map)    
       }
       else if (map["type"] == "delay") {
            PlainPlayDelay(map)
       } else if (map["type"] == "screenshot") {
            PlainPlayScreenshot(map)
       }
    }

    global isActionsLocked := false
}


; ====================================================================
; Plays text variation
;
PlainPlayText(map) {
    global isActionsLocked

    if (!isActionsLocked)
        return

    if map["delay_before"] > 0
        Sleep(map["delay_before"])

    if (!isActionsLocked)
        return

    Chat_Say(GenderReplace(map["text"]))

    if (!isActionsLocked)
        return

    if map["delay_after"] > 0
        Sleep(map["delay_after"])
}


; ====================================================================
; Plays delay variation
;
PlainPlayDelay(map) {
    global isActionsLocked

    if (!isActionsLocked)
        return

    if map["delay_before"] > 0
        Sleep(map["delay_before"])
}


; ====================================================================
; Plays screenshot variation
;
PlainPlayScreenshot(map) {
    global isActionsLocked

    if (!isActionsLocked)
        return

    if map["delay_before"] > 0
        Sleep(map["delay_before"])

    if (!isActionsLocked)
        return

    Sleep(200)

    if (!isActionsLocked)
        return

    Take_ScreenShot()

    if (!isActionsLocked)
        return

    if map["delay_after"] > 0
        Sleep(map["delay_after"])
}


; ====================================================================
; Replaces gender related texts
;
GenderReplace(input) {
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

        return GenderReplace(StrReplace(input, origin, replace))
    }

    return input
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
    Take_ScreenShot_DateDir(GetReportWeekDir(REPORT_DRUGS_PATH))
    PlainTextSay(DRUGS_BLISTER_VARIATIONS)
}


; ====================================================================
; Plays selling vitamins random variation
;
Medic_SellVitamins() {
    Log("Selling vitamins triggred")
    Take_ScreenShot_DateDir(GetReportWeekDir(REPORT_DRUGS_PATH))
    PlainTextSay(DRUGS_VITAMIN_VARIATIONS)
}


; ====================================================================
; Plays blood donation random variation
;
Medic_BloodDonation() {
    Log("Blood donation triggred")
    PlainTextSay(BLOOD_DONATION_VARIATIONS)
    PlaySound_Start()
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
    screenshotFile := Take_ScreenShot(GetReportWeekDir())

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

    outputDir := GetReportWeekDir(REPORT_REANIMATIONS_PATH "\" dayShift)
    
    if not DirExist(outputDir)
        DirCreate outputDir

    outputFile := outputDir "\*.*"

    FileCopy screenshotFile, outputFile

    FileDelete screenshotFile
}


; Sun Mon Tue Wen Thu Fri Sat


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
    PlaySound_Start()
}


; ====================================================================
; Plays random text variation for medcard throat check
;
Medic_MedCard_Throat(){
    Log("Med Card throat triggered")
    PlainTextSay(MED_CARD_THROAT_CHECK_VARIATIONS )
    PlaySound_Start()
}


; ====================================================================
; Plays random text variation for medcard lungs check
;
Medic_MedCard_Lungs(){
    Log("Med Card fonendoscope triggered")
    PlainTextSay(MED_CARD_LUNGS_CHECK_VARIATIONS)
    PlaySound_Start()
}


; ====================================================================
; Plays random text variation for medcard signing
;
Medic_MedCard_Sign(){
    Log("Med Card sign triggered")
    PlainTextSay(MED_CARD_SIGN_VARIATIONS)
    PlaySound_Start()
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
    PlaySound_Start()
}


; ====================================================================
; Plays random text variation for blood pressure check
;
Medic_Analysis_BloodPressure() {
    Log("Medic_Analysis_BloodPressure")
    PlainTextSay(ANALYSIS_BLOOD_PRESSURE_VARIATIONS)
    PlaySound_Start()
}


; ====================================================================
; Plays random text variation for plastic surgery
;
Medic_Surgery_Plastic() {
    Log("Medic_Surgery_Plastic triggered")
    PlainTextSay(PLASCTIC_SURGERY_VARIATIONS)
    PlaySound_Start()
}


; ====================================================================
; Plays random text variation for oculist right eye check
;
Medic_Oculist_RightEyeCheck() {
    Log("Medic_Oculist_RightEyeCheck triggered")
    PlainTextSay(OCULIST_RIGHT_EYE_CHECK_VARIATIONS)
    PlaySound_Start()
}


; ====================================================================
; Plays random text variation for oculist right eye check
;
Medic_Oculist_LeftEyeCheck() {
    Log("Medic_Oculist_LeftEyeCheck triggered")
    PlainTextSay(OCULIST_LEFT_EYE_CHECK_VARIATIONS)
    PlaySound_Start()
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


; ====================================================================
; Plays random text variation for otaryngology rhinoscopy
;
Medic_Otalaryngology_Rhinoscopy() {
    Log("Medic_Otalaryngology_Rhinoscopy triggered")
    PlainTextSay(OTOLARYNGOLOGY_RHINOSCOPY)
}


; ====================================================================
; Plays random text variation for otaryngology endocscopy
;
Medic_Otalaryngology_Endoscopy() {
    Log("Medic_Otalaryngology_Endoscopy triggered")
    PlainTextSay(OTOLARYNGOLOGY_ENDOSCOPY)
}


; ====================================================================
; Plays random text variation for otaryngology otoscopy
;
Medic_Otalaryngology_Otoscopy() {
    Log("Medic_Otalaryngology_Endoscopy triggered")
    PlainTextSay(OTOLARYNGOLOGY_ENDOSCOPY)
}


; ====================================================================
; Plays random text variation for gynecology prepare
;
Medic_Gynecology_Prepare() {
    Log("Medic_Gynecology_Prepare triggered")
    PlainTextSay(GYNECOLOGY_PREPARE_VARIATIONS)
}


; ====================================================================
; Plays random text variation for gynecology take analysis
;
Medic_Gynecology_TakeAnalysis() {
    Log("Medic_Gynecology_TakeAnalysis triggered")
    PlainTextSay(GYNECOLOGY_TAKE_ANALISYS_VARIATIONS)
}


; ====================================================================
; Plays random text variation for gynecology analysis
;
Medic_Gynecology_Analysis() {
    Log("Medic_Gynecology_Analysis triggered")
    PlainTextSay(GYNECOLOGY_ANALISYS_VARIATIONS)
}


; ====================================================================
; Plays random text variation for gynecology ultrasonic start analysis
;
Medic_Gynecology_UltrasonicStart_Analysis() {
    Log("Medic_Gynecology_Ultrasonic_Analysis triggered")
    PlainTextSay(GYNECOLOGY_ULTRASONIC_START_ANALISYS_VARIATIONS)
}


; ====================================================================
; Plays random text variation for gynecology pregnancy results analysis
;
Medic_Gynecology_Ultrasonic_Pregnancy_Analysis() {
    Log("Medic_Gynecology_Ultrasonic_Pregnancy_Analysis( triggered")
    PlainTextSay(GYNECOLOGY_ULTRASONIC_ANALISYS_PREGNANCY_VARIATIONS)
}


; ====================================================================
; Plays random text variation for gynecology pathology results analysis
;
Medic_Gynecology_Ultrasonic_Pathology_Analysis() {
    Log("Medic_Gynecology_Ultrasonic_Pregnancy_Analysis( triggered")
    PlainTextSay(GYNECOLOGY_ULTRASONIC_ANALISYS_PATHOLOGY_VARIATIONS)
}


; ====================================================================
; Plays random text variation for gynecology ultrasonic finish analysis
;
Medic_Gynecology_UltrasonicFinish_Analysis() {
    Log("Medic_Gynecology_UltrasonicFinish_Analysis triggered")
    PlainTextSay(GYNECOLOGY_ULTRASONIC_FINISH_ANALISYS_VARIATIONS)
}


; ====================================================================
; Plays random text variation for surgery kidney donor
;
Medic_Surgery_KidneyDonor() {
    Log("Medic_Surgery_KidneyDonor triggered")
    PlainTextSay(KIDNEY_DONOR_VARIATIONS)
}


; ====================================================================
; Plays random text variation for surgery preparation
;
Medic_Surgery_Preparation() {
    Log("Medic_Surgery_Preparation triggered")
    PlainTextSay(SURGERY_PREPARATION_VARIATIONS)
}


; ====================================================================
; Plays random text variation for surgery start
;
Medic_Surgery_Start() {
    Log("Medic_Surgery_Preparation triggered")
    PlainTextSay(SURGERY_START_VARIATIONS)
}


; ====================================================================
; Plays random text variation for surgery anasthesia
;
Medic_Surgery_Anasthesia() {
    Log("Medic_Surgery_Anasthesia triggered")
    PlainTextSay(SURGERY_ANASTHESIA_VARIATIONS)
}


; ====================================================================
; Plays random text variation for surgery anasthesia
;
Medic_Surgery_AnasthesiaLocal() {
    Log("Medic_Surgery_AnasthesiaLocal triggered")
    PlainTextSay(SURGERY_ANASTHESIA_LOCAL_VARIATIONS)
}


; ====================================================================
; Plays random text variation for surgery appendix removal
;
Medic_Surgery_AppendixRemoval() {
    Log("Medic_Surgery_AppendixRemoval triggered")
    PlainTextSay(SURGERY_APPENDIX_REMOVAL)
}


; ====================================================================
; Plays random text variation for analysis MRT Processing
;
Medic_Analysis_MRTProcessing() {
    Log("Medic_Analysis_MRTProcessing triggered")
    PlainTextSay(ANALYSIS_MRT_PRECESSING)
}


; ====================================================================
; Plays random text variation for analysis MRT Results
;
Medic_Analysis_MRTResults() {
    Log("Medic_Analysis_MRTResults triggered")
    PlainTextSay(ANALYSIS_MRT_RESULTS)
}


; ====================================================================
; Plays random text variation for analysis MRT Print results
;
Medic_Analysis_MRTPrintResults() {
    Log("Medic_Analysis_MRTPrintResults triggered")
    PlainTextSay(ANALYSIS_MRT_PRINT_RESULTS)
}


; ====================================================================
; Plays random text variation for narcologyst alko test
;
Medic_Narcologyst_AlcoTest() {
    Log("Medic_Narcologyst_AlcoTest triggered")
    PlainTextSay(NARCOLOGYST_ALKO_TEST)
}


; ====================================================================
; Plays random text variation for narcologyst alko test
;
Medic_Narcologyst_DrugsTest() {
    Log("Medic_Narcologyst_DrugsTest triggered")
    PlainTextSay(NARCOLOGYST_DRUGS_TEST)
}


; ====================================================================
; Plays random text variation for proctology insert meds
;
Medic_Proctology_InsertMeds() {
    Log("Medic_Proctology_InsertMeds triggered")
    PlainTextSay(PROCTOLOGY_INSERT_MEDS)
}


; ====================================================================
; Plays random text variation for proctology hemorrhoids healing
;
Medic_Proctology_HemorrhoidsHealing() {
    Log("Medic_Proctology_HemorrhoidsHealing triggered")
    PlainTextSay(PROCTOLOGY_HEMORRHOIDS_HEALING)
}


; ====================================================================
; Plays random text variation for proctology enema
;
Medic_Proctology_ProctologyEnema() {
    Log("Medic_Proctology_ProctologyEnema triggered")
    PlainTextSay(PROCTOLOGY_ENEMA)
}


; ====================================================================
; Plays random text variation for proctology check
;
Medic_Proctology_Check() {
    Log("Medic_Proctology_Check triggered")
    PlainTextSay(PROCTOLOGY_CHECK)
}


; ====================================================================
; Plays random text variation for analysis fluorography
;
Medic_Analysis_Fluorography() {
    Log("Medic_Analysis_Fluorography triggered")
    PlainTextSay(ANALYSIS_FLUOROGRAPHY)
}


; ====================================================================
; Plays random text variation for analysis xray
;
Medic_Analysis_XRay() {
    Log("Medic_Analysis_XRay triggered")
    PlainTextSay(ANALYSIS_X_RAY)
}


; ====================================================================
; Plays random text variation for analysis DNA
;
Medic_Analysis_DNA() {
    Log("Medic_Analysis_DNA triggered")
    PlainTextSay(ANALYSIS_DNA)
}