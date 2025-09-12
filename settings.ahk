#Requires AutoHotkey v2.0
#Include quirks.ahk

class Settings {
    static NameDisplay := StrLower(IniRead("settings.ini", "settings", "NameDisplay", "full"))
    static CommandPrefix := IniRead("settings.ini", "settings", "CommandPrefix", "hs;")
    static DefaultQuirk := IniRead("settings.ini", "settings", "DefaultQuirk", UNSET_QUIRK)
    static ConvertOnEnter := Integer(IniRead("settings.ini", "settings", "ConvertOnEnter", "0"))
    static RememberLast := Integer(IniRead("settings.ini", "settings", "RememberLast", "1"))
    static LastUsed := IniRead("settings.ini", "settings", "LastUsed", UNSET_QUIRK)
}

ToggleEnterConversion(*) {
    Settings.ConvertOnEnter := Settings.ConvertOnEnter ? 0 : 1
    tray.ToggleCheck("Convert on Enter")
    IniWrite(Settings.ConvertOnEnter, "settings.ini", "settings", "ConvertOnEnter")
}

ToggleRememberLast(*) {
    Settings.RememberLast := Settings.RememberLast ? 0 : 1
    tray.ToggleCheck("Remember last used")
    IniWrite(Settings.RememberLast, "settings.ini", "settings", "RememberLast")
}

SetCurrentQuirkAsDefault(*) {
    Settings.DefaultQuirk := IsQuirkActive() ? activeQuirk.getPreferredName() : UNSET_QUIRK
    IniWrite(Settings.DefaultQuirk, "settings.ini", "settings", "DefaultQuirk")
}

SetCurrentQuirkAsLast(*) {
    Settings.LastUsed := IsQuirkActive() ? activeQuirk.getPreferredName() : UNSET_QUIRK
    IniWrite(Settings.LastUsed, "settings.ini", "settings", "LastUsed")
}