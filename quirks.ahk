#Requires AutoHotkey v2.0
#Include settings.ahk
; TODO exclude emoji from replacement

/**
 * @default equal to `UNSET_QUIRK`
 */
activeQuirk := ""
UNSET_QUIRK := "" 

SetActiveQuirk(name?) {
    global activeQuirk

    if (IsSet(name)) {
        activeQuirk := GetQuirkByAnyName(name)
    } else {
        if Settings.RememberLast {
            activeQuirk := GetQuirkByAnyName(Settings.LastUsed)
        } else {
            activeQuirk := GetQuirkByAnyName(Settings.DefaultQuirk)
        }
    }

    if Settings.RememberLast {
        SetCurrentQuirkAsLast()
    }

    tray.Rename("2&", "Active quirk: " (IsQuirkActive() ? activeQuirk.getPreferredName() : "<none>"))
}

IsQuirkActive() {
    return activeQuirk != UNSET_QUIRK
}

quirkList := Map()
quirkList.CaseSense := 0

caseConversions := Map()
caseConversions.CaseSense := 0
caseConversions.Set("lowercase", (str) => StrLower(str))
caseConversions.Set("uppercase", (str) => StrUpper(str))
caseConversions.Set("title", (str) => StrTitle(str))
caseConversions.Set("revtitle", (str) => StrInvertCase(StrTitle(str)))
caseConversions.Set("random", (str) => StrRandomCase(str))
caseConversions.Set("preserve", (str) => str)

StrRandomCase(str) {
    ret := ""
    
    loop parse, str {
        if Random(0, 1) == 0 {
            ret .= StrLower(A_LoopField)
        } else {
            ret .= StrUpper(A_LoopField)
        }
    }

    return ret
}

StrInvertCase(str) {
    inverted := ""
    loop parse str
        inverted .= Format("{:" (IsUpper(A_LoopField) ? "L" : "U") "}", A_LoopField)
    return inverted
}

class TypingQuirk extends Object {
    FullName := ""
    Handle := ""
    Abbr := ""
    ConvertCase := caseConversions["preserve"]
    FormatTemplate := "{}"
    Replacements := []

    __New(fileName) {
        ; Parse given quirk config file
        fileContents := IniRead("quirks/" fileName, "quirk")
        loop parse fileContents, "`n" {
            fields := StrSplit(A_LoopField, '=', ' `t')
            if fields.Length != 2 {
                continue
            }
            
            key := Trim(fields[1]), value := Trim(fields[2])
            switch key, 0 {
                case "FullName":
                    this.FullName := value
                case "Handle":
                    this.Handle := value
                case "Abbr":
                    if value == "none" {
                        MsgBox("Invalid abbr (none is a reserved value) in " filename ".", "Homestuck IME", "IconX")
                        ExitApp(-1)
                    }

                    this.Abbr := value
                case "Case":
                    if caseConversions.Has(value) {
                        this.ConvertCase := caseConversions[value]
                    } else {
                        MsgBox("Unknown conversion type (" key "=" value ") in " filename ".", "Homestuck IME", "Icon!")
                    }
                case "FormatTemplate":
                    this.FormatTemplate := value
                case "Replacements":
                    loop parse value, ',', ' `t' {
                        parts := StrSplit(A_LoopField, '|')
                        if parts.Length != 2 {
                            MsgBox("Invalid replacement (" A_LoopField ") in " filename ".", "Homestuck IME", "Icon!")
                            continue
                        }

                        this.Replacements.Push({
                            from: Trim(parts[1]),
                            to: Trim(parts[2])
                        })
                    }
                default:
                    MsgBox("Unknown typing quirk key (" key "=" value ") in " filename ".", "Homestuck IME", "Icon!")
            }
        }

        if !(StrLen(this.FullName) != 0 || StrLen(this.Handle) != 0 || StrLen(this.Abbr) != 0) {
            MsgBox("No register/display property (FullName|Handle|Abbr) set in " filename ".", "Homestuck IME", "IconX")
            ExitApp(-1)
        }
    }
    
    getPreferredName() {
        ; ?? does not work with properties, checking for string length instead
        switch Settings.NameDisplay {
            case "full":
                return StrLen(this.FullName) != 0 ? this.FullName : StrLen(this.Handle) != 0 ? this.Handle : this.Abbr
            case "handle":
                return StrLen(this.Handle) != 0 ? this.Handle : StrLen(this.FullName) != 0 ? this.FullName : this.Abbr
            case "abbr":
                return StrLen(this.Abbr) != 0 ? this.Abbr : StrLen(this.FullName) != 0 ? this.FullName : this.Handle
            default:
                MsgBox("Invalid NameDisplay value in settings (" Settings.NameDisplay ")")
        }
    }
}

ImportQuirks() {
    loop files "quirks\*.ini", 'FR' {
        if SubStr(A_LoopField, 1, 1) == '_' {
            continue
        }

        quirk := TypingQuirk(A_LoopFileName)
        quirkList.Set(quirk.getPreferredName(), quirk)
    }
}

/**
* @returns
* TypingQuirk instance of if found, UNSET_QUIRK if given UNSET_QUIRK
*/
GetQuirkByAnyName(name) {
    if name == UNSET_QUIRK {
        return UNSET_QUIRK
    }

    if quirkList.Has(name) {
        return quirkList[name]
    } else {
        for name, quirk in quirkList {
            if quirk.FullName == name || quirk.Handle == name || quirk.Abbr == name {
                return quirk
            }
        }
    }

    MsgBox("Quirk " name " not found!",, "IconX")
    ExitApp(-1)
}