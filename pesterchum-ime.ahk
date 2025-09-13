#Requires AutoHotkey v2.0
#SingleInstance Force
; TODO entry file, note this in readme

#include settings.ahk
#Include input.ahk
#Include quirks.ahk
#Include traymenu.ahk

Main() {
    ImportQuirks()
    InitTray()
    SetActiveQuirk()
    RegisterAppHotstrings()

    ToggleSuspend()
}

Main()