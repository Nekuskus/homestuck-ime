#Requires AutoHotkey v2.0

class Settings {
    static NameDisplay := IniRead("options.ini", "options", "NameDisplay", "full")
    static CommandPrefix := IniRead("options.ini", "options", "CommandPrefix", "hs;")
}