#Requires AutoHotkey v2.0
#Include traymenu.ahk

#SuspendExempt
!h::ToggleSuspend
#SuspendExempt False


ToggleSuspend(*) {
    tray.ToggleCheck("Suspend IME")
    Suspend
}

RegisterPrefixHostrings() {
    ; TODO
}