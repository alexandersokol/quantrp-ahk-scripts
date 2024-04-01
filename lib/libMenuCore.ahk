#Requires AutoHotkey v2.0

#Include "libCommon.ahk"

ENTRY_NODE := "node"
ENTRY_TEXT := "text"
ENTRY_FLOW := "flow"

menuLoad(menuDir) {
    Log("Root: " menuDir)
    Loop Files, menuDir "\*", "D" {
        ; Log("Dir: " A_LoopFileName)
        Log("A_LoopFileName: " A_LoopFileName)
        ; Log("A_LoopFilePath: " A_LoopFilePath)
        menuLoad(A_LoopFilePath)
    }
    
    Loop Files, menuDir "\*.txt"
        Log("File: " A_LoopFileName)
}

menuLoad("C:\Users\rraze\OneDrive\Documents\AutoHotkey\quantrp-ahk-scripts\medic-menu")
ExitApp