#Requires AutoHotkey v2.0

quirkList := Map()

class TypingQuirk extends Object {
    __New(fileName) {
        ; Parse given quirk config file
        fileContents := IniRead("quirks/" fileName, "quirk")
        loop parse fileContents, "`n" {
            fields := StrSplit(A_LoopField, '=', ' `t')
            if fields.Length != 2 {
                continue
            }
            
            key := fields[0], value := fields[1]

            switch [key, 0] {
                case "FullName":
                    this.FullName := value
                case "Handle":
                    this.Handle := value
                case "Abbr":
                    this.Abbr := value
                case "Case":
                    ; TODO
                default:
                    MsgBox("Unknown typing quirk key (" key "=" value ") in " filename ".", "IconX")
            }
        }

        ; TODO, Validate that at least one display and register value is set
        

        ; this.FullName := 
        ; this.Handle := 
        ; this.Abbr :=
        ; this.Template (figure out how to map these, template string? probablyyy)
        ; this.Replacements (dicts... this will suck)
    }
    
}

ImportQuirks() {
    ; TODO
}