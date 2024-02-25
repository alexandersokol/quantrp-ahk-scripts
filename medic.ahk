#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "lib\libCommon.ahk"
#Include "lib\libMedic.ahk"
#Include "lib\guiMedic.ahk"

Persistent true
requestAdminRights()

#HotIf IsGameActive()
    >^R::Chat_Type("/rb ")         ; LCtrl + R - Open chat and print /rb 

    \::Take_ScreenShot()
    >^q::Medic_ShowBadge()
    >^=::Medic_SellBlister()
    >^-::Medic_SellVitamins()
    >^0::Medic_BloodDonation()
    >^9::Medic_Reanimation()
    >^h::Chat_Type("/heal ")
    >^b::Chat_Type("/blood ")
    XButton1::Medic_ReanimationClick()

    >^PgUp::Medic_MedCard_Temperature()
    >^PgDn::Medic_MedCard_Throat()
    >^Home::Medic_MedCard_Lungs()
    >^End::Medic_MedCard_Sign()

    >^x::Medic_CantFindABody()
#HotIf