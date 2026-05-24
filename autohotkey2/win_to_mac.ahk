#Requires AutoHotkey v2.0
#SingleInstance


; Force enable NumLock, pressing NumLock key does nothing!
Persistent
SetNumLockState("AlwaysOn")


; ------------
; Introduction
; ------------

; In this script "RCtrl" is treated as logical "Cmd" from MacOS.

; Syntax of AutoHotkey:
; ! = Alt (Any)
; ^ = Ctrl (Any)
; <^ = LCtrl
; >^ = RCtrl
; + = Shift (Any)
; <+ = LShift
; >+ RShift

; "&" syntax doesn't support 3 keys. The codes from above should be used in in this case.

; This script requires some keys to be remapped in "KeyTweak" app.
; 1. Remap "Caps Lock" to "Left Control".
; 2. Remap "Left Win" to "Left Alt".
; 3. Remap "Left Alt" to "Right Control" (RCtrl).

; Remap CapsLock to Control - Currently remapped in "KeyTweak"!
; CapsLock::LCtrl


; Kill Start Menu completely.
Control & Esc::vkE8
LWin::return
RWin::return
LAlt & Tab::vkE8



; ------------
; Key Bindings
; ------------

; Session
>^<^Q:: Send("#l") ; TODO: nik / doesn't work, must check this.
>^+Q:: Send("#{x}{u}{i}") ; TODO: nik / doesn't work, must check this.

; "Alt"-"Tab"
>^Tab:: {
    Send("{Alt down}{Tab}")
    try {
        KeyWait("RCtrl", "T5")
    }
    Send("{Alt up}")
}

>^+Tab:: {
    Send("{Alt down}{Shift down}{Tab}")
    try {
        KeyWait("RCtrl", "T5")
        KeyWait("Shift", "T5")
    }
    Send("{Shift up}{Alt up}")
}

; Keyboard layout.
RCtrl & Space::Send "#{Space}"

; Window management.
RCtrl & Q::Send "!{F4}"

; Tabs cycling.
>^+sc01A::Send("^+{Tab}")
>^+sc01B::Send("^{Tab}")

; Text editing.
RCtrl & A::Send "^a"

LCtrl & A::Send "{Home}"
LCtrl & E::Send "{End}"
LCtrl & P::Send "{Up}"
LCtrl & N::Send "{Down}"

LCtrl & D::Send "{Delete}"
LCtrl & W::Send "{LCtrl up}^{Backspace}"

Alt & Left::Send "^{Left}"
Alt & Right::Send "^{Right}"

; Arrows

RCtrl & Up:: Send "{Home}"
RCtrl & Down:: Send "{End}"



; ------------------
; App-specific stuff
; ------------------

; ----------
; "Terminal"
; ----------

; Operations below must be binded to Alt+* keys in Terminal app.
#HotIf WinActive("ahk_exe WindowsTerminal.exe")

RCtrl & C::Send("!c")
RCtrl & D::Send("!d")
RCtrl & W::Send("!w")
LCtrl & W::Send("{LCtrl up}!{Backspace}")

#HotIf


; ----------------
; "Android Studio"
; ----------------

; Operations below must be binded to Alt+* keys in Terminal app.
#HotIf WinActive("timers_flutter")

;; RCtrl & R::Send("+{F10}")

#HotIf
