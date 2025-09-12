#Requires AutoHotkey v2.0
#Include traymenu.ahk
#Include quirks.ahk

#SuspendExempt
!h::ToggleSuspend
#SuspendExempt False

ToggleSuspend(*) {
    tray.ToggleCheck("Suspend IME")
    Suspend
}

PrefixHotstring(str, value) {
    Hotstring(":*:" Settings.CommandPrefix str, value)
}

RegisterQuirkHotstrings() {
    PrefixHotstring("s`snone", (*) => SetActiveQuirk(UNSET_QUIRK))

    for name, quirk in quirkList {
        if quirk.Abbr != "" {
            PrefixHotstring("s`s" quirk.Abbr, ((name, *) => SetActiveQuirk(name)).Bind(quirk.getPreferredName()))
        }
    }
}