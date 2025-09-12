#Requires AutoHotkey v2.0
#Include quirks.ahk

class Settings {
    static NameDisplay := StrLower(IniRead("options.ini", "options", "NameDisplay", "full"))
    static CommandPrefix := IniRead("options.ini", "options", "CommandPrefix", "hs;")
    static DefaultQuirk := IniRead("options.ini", "options", "DefaultQuirk", UNSET_QUIRK)
    static ConvertOnEnter := Integer(IniRead("options.ini", "options", "ConvertOnEnter", "0"))
    static RememberLast := Integer(IniRead("options.ini", "options", "RememberLast", "1"))
    static LastUsed := IniRead("options.ini", "options", "LastUsed", UNSET_QUIRK)
}

ToggleEnterConversion(*) {
    Settings.ConvertOnEnter := Settings.ConvertOnEnter ? 0 : 1
    tray.ToggleCheck("Convert on Enter")
    IniWrite(Settings.ConvertOnEnter, "settings.ini", "options", "ConvertOnEnter")
}

ToggleRememberLast(*) {
    Settings.RememberLast := Settings.RememberLast ? 0 : 1
    tray.ToggleCheck("Remember last used")
    IniWrite(Settings.RememberLast, "settings.ini", "options", "RememberLast")
}

SetCurrentQuirkAsDefault(*) {
    Settings.DefaultQuirk := IsQuirkActive() ? activeQuirk.getPreferredName() : UNSET_QUIRK
    IniWrite(Settings.DefaultQuirk, "settings.ini", "options", "DefaultQuirk")
}

SetCurrentQuirkAsLast(*) {
    Settings.LastUsed := IsQuirkActive() ? activeQuirk.getPreferredName() : UNSET_QUIRK
    IniWrite(Settings.LastUsed, "settings.ini", "options", "LastUsed")
}