#Requires AutoHotkey v2.0
#Include traymenu.ahk
#Include quirks.ahk

#SuspendExempt
!h::ToggleSuspend
:*:hs;suspend"::{
    ToggleSuspend()
}
#SuspendExempt False

ToggleSuspend(*) {
    tray.ToggleCheck("Suspend IME")
    Suspend
}

PrefixHotstring(str, value, enabled := "on") {
    Hotstring(":*:" Settings.CommandPrefix str, value, enabled)
}

RegisterAppHotstrings() {
    PrefixHotstring("reload", (*) => Reload()) 
    PrefixHotstring("exit", (*) => ExitApp(0)) 
    
    PrefixHotstring("te", ToggleEnterConversion)
    PrefixHotstring("tr", ToggleRememberLast)

    Hotstring(":*:`n", (*) => ProcessWithReturn())
    PrefixHotstring("p", ProcessCurrentLine)
    
    PrefixHotstring("s`snone", (*) => SetActiveQuirk(UNSET_QUIRK))
    for name, quirk in quirkList {
        if quirk.Abbr != "" {
            PrefixHotstring("s`s" quirk.Abbr, ((name, *) => SetActiveQuirk(name)).Bind(quirk.getPreferredName()))
        }
    }
}

ProcessCurrentLine(*) {
    if(!IsQuirkActive()) {
        return
    }

    A_Clipboard := ""
    Send("{End}")
    Send("+{Home}")
    Sleep(150)
    Send("^x")
    ClipWait(2)
    
    line := A_Clipboard
    for entry in activeQuirk.Replacements {
        line := StrReplace(line, entry.from, entry.to)
    }
    line := activeQuirk.ConvertCase.Call(line)
    line := StrReplace(activeQuirk.FormatTemplate, "{}", line)

    Send("{Text}" line)

}

ProcessWithReturn(*) {
    if(!IsQuirkActive() || !Settings.ConvertOnEnter) {
        Send("{Enter}")
        return
    }

    processcurrentline()
    Sleep(150)
    Send("{Enter}")
}
