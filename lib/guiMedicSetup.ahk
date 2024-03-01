#Requires AutoHotkey v2.0

#Include "libMedicSetup.ahk"

Medic_PreferencesSetup(callback) {
    myGui := Constructor()
    myGui.Show("w431 h496")

    Constructor()
    {
        global medicPreferences

        myGui := Gui()
        Edit1 := myGui.Add("Edit", "x48 y64 w328 h21", medicPreferences["name"])
        myGui.Add("Text", "x48 y32 w326 h23 +0x200", "Ім'я")
        myGui.Add("Text", "x48 y96 w329 h23 +0x200", "Призвище")
        Edit2 := myGui.Add("Edit", "x48 y128 w330 h21", medicPreferences["surname"])
        myGui.Add("Text", "x48 y160 w329 h23 +0x200", "Посада чи ранг")
        Edit3 := myGui.Add("Edit", "x48 y192 w327 h21", medicPreferences["rank"])
        myGui.Add("Text", "x48 y224 w327 h23 +0x200", "Static ID")
        Edit4 := myGui.Add("Edit", "x48 y256 w328 h21", medicPreferences["staticId"])
        myGui.Add("GroupBox", "x48 y288 w327 h109", "Стать")
        Radio1 := myGui.Add("Radio", "x64 y320 w120 h23", "Чоловіча")
        Radio2 := myGui.Add("Radio", "x64 y352 w120 h23", "Жіноча")
        Button := myGui.Add("Button", "x128 y424 w152 h38", "Зберегти")

        isMaleChecked := 0
        if (medicPreferences["gender"] == "M" || medicPreferences["gender"] == "m") {
            isMaleChecked := 1
        }
        Radio1.Value := isMaleChecked

        isFemaleChecked := 0
        if (medicPreferences["gender"] == "F" || medicPreferences["gender"] == "f") {
            isFemaleChecked := 1
        }
        Radio2.Value := isFemaleChecked

        Button.OnEvent("Click", OnSaveHandler)
        myGui.OnEvent('Close', (*) => ExitApp())
        myGui.Title := "Налаштування"

        OnSaveHandler(*) {
            myGui.Hide()

            genderValue := ""

            if (Radio1.Value == 1) {
                genderValue := "M"
            }
            else if (Radio2.Value == 1) {
                genderValue := "F"
            }

            Preferences_Save(name := Edit1.Value,
                surname := Edit2.Value,
                rank := Edit3.Value,
                staticId := Edit4.Value,
                gender := genderValue
            )

            if (Preferences_IsValid()) {
                callback.Call()
            } else {
                ToolTip("Не всі поля заповнені!", 77, 277)
                SetTimer () => ToolTip(), -3000 ; tooltip timer
            }
        }

        return myGui
    }
}