#Requires AutoHotkey v2.0
#Include input.ahk
#Include settings.ahk

tray := A_TrayMenu
quirkListMenu := Menu()

QuirkSelectCallback(ItemName, *) {
    if (ItemName == "<none>") {
        SetActiveQuirk(UNSET_QUIRK)
    }
    else {
        SetActiveQuirk(ItemName)
    }
}

InitTray() {
    ; Clear default menu
    tray.Delete()

    ; Construct typing quirks menu
    quirkListMenu.Add("<none>", QuirkSelectCallback)
    for name, quirk in quirkList {
        quirkListMenu.Add(name, QuirkSelectCallback)
    }
    tray.Add("Typing quirks", quirkListMenu)

    tray.Add("Active quirk: <none>", (*) => {})
    tray.Disable("2&")

    tray.Add() ; separator line

    tray.Add("Name display: " Settings.NameDisplay, (*) => {})
    tray.Disable("Name display: " Settings.NameDisplay)
    
    tray.Add("Prefix: " Settings.CommandPrefix, (*) => {})
    tray.Disable("Prefix: " Settings.CommandPrefix)

    tray.Add("Set current as default", SetCurrentQuirkAsDefault)
    
    tray.Add("Remember last used", ToggleRememberLast)
    if Settings.RememberLast {
        tray.Check("Remember last used")
    }
    
    tray.Add("Convert on Enter", ToggleEnterConversion)
    if Settings.ConvertOnEnter {
        tray.Check("Remember last used")
    }

    tray.Add()

    tray.Add("Suspend IME", ToggleSuspend)
    tray.Add("Reload", (*) => Reload())
    tray.Add("Exit", (*) => ExitApp(0))
}