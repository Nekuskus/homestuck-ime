#Requires AutoHotkey v2.0
#SingleInstance Force
; entry file, note this in readme

#include options.ahk
#Include hotstrings.ahk
#Include quirks.ahk
#Include traymenu.ahk

Main() {
    ImportQuirks() ; Construct an array of typing quirks
    InitTray()
}

Main()