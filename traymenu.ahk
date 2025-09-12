#Requires AutoHotkey v2.0
#Include hotstrings.ahk

tray := A_TrayMenu

QuirkSelectCallback(ItemName, *) {
    MsgBox("Selected " ItemName "!")
}

InitTray() {
    ; Clear default menu
    tray.Delete()

    ; Construct typing quirks menu
    QuirkListMenu := Menu()
    QuirkListMenu.Add("Nepeta", QuirkSelectCallback)
    QuirkListMenu.Add("Eridan", QuirkSelectCallback)
    QuirkListMenu.Add("Karkat", QuirkSelectCallback)
    tray.Add("Typing quirks", QuirkListMenu)

        tray.Add() ; separator line

    tray.Add("Suspend IME", ToggleSuspend)
    tray.Add("Reload", (*) => Reload())
    tray.Add("Exit", (*) => ExitApp(0))

    tray.Show()
}
    