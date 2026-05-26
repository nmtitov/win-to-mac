#Requires AutoHotkey v2.0
#SingleInstance

; Prevent Start Menu from appearing when AHK suppresses Win/Alt key events.
A_MenuMaskKey := "vkE8"

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

; "&" syntax doesn't support 3 keys. The codes from above should be used in this case.

; This script requires some keys to be remapped in "KeyTweak" app.
; 1. Remap "Caps Lock" to "Left Control".
; 2. Remap "Left Win" to "Left Alt".
; 3. Remap "Left Alt" to "Right Control" (RCtrl).

; Remap CapsLock to Control - Currently remapped in "KeyTweak"!
; CapsLock::LCtrl


; Kill Start Menu completely.
Control & Esc::vkE8
LWin::Send("{Blind}{vkE8}")
RWin::Send("{Blind}{vkE8}")
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

; Standard Cmd shortcuts → Ctrl equivalents.
; RCtrl loses its native modifier function when used in & combos,
; so every Cmd+Key must be mapped explicitly.
RCtrl & A::Send "^a"
RCtrl & B::Send "^b"
RCtrl & C::Send "^c"
RCtrl & D::Send "^d"
RCtrl & F::Send "^f"
RCtrl & I::Send "^i"
RCtrl & L::Send "^l"
RCtrl & N::Send "^n"
RCtrl & O::Send "^o"
RCtrl & P::Send "^p"
RCtrl & R::Send "^r"
RCtrl & S::Send "^s"
RCtrl & T::Send "^t"
RCtrl & U::Send "^u"
RCtrl & V::Send "^v"
RCtrl & W::Send "^w"
RCtrl & X::Send "^x"
RCtrl & Z::Send "^z"

; Cmd+Shift shortcuts.
>^+Z::Send "^y"
>^+N::Send "^+n"
>^+T::Send "^+t"
>^+F::Send "^+f"
>^+P::Send "^+p"
>^+S::Send "^+s"

; Emacs-style editing (LCtrl = physical CapsLock).
LCtrl & A::Send "{Home}"
LCtrl & E::Send "{End}"
LCtrl & P::Send "{Up}"
LCtrl & N::Send "{Down}"
LCtrl & D::Send "{Delete}"
LCtrl & W::Send "{LCtrl up}^{Backspace}"

; Option+Arrow / Option+Backspace → word navigation and deletion.
Alt & Left::Send "^{Left}"
Alt & Right::Send "^{Right}"
Alt & Backspace::Send "^{Backspace}"

; Cmd+Arrow → line/document navigation.
RCtrl & Left::Send "{Home}"
RCtrl & Right::Send "{End}"
RCtrl & Up::Send "^{Home}"
RCtrl & Down::Send "^{End}"

; Cmd+Backspace → delete to beginning of line.
RCtrl & Backspace::Send "+{Home}{Delete}"



; ------------------
; App-specific stuff
; ------------------

; ----------
; "Terminal"
; ----------

; Terminal intercepts Ctrl+Key for shell signals (Ctrl+C = SIGINT, etc.).
; These overrides send Alt+Key combos that are bound in Terminal settings,
; or use shell-native shortcuts (Ctrl+L for clear, Ctrl+U for kill line).
#HotIf WinActive("ahk_exe WindowsTerminal.exe")

RCtrl & C::Send("!c")
RCtrl & D::Send("!d")
RCtrl & W::Send("!w")
LCtrl & W::Send("{LCtrl up}!{Backspace}")
RCtrl & T::Send("!t")
RCtrl & N::Send("!n")
RCtrl & F::Send("!f")
RCtrl & K::Send("^l")
RCtrl & Backspace::Send("^u")

#HotIf


; ----------------
; "Android Studio"
; ----------------

#HotIf WinActive("timers_flutter")

;; RCtrl & R::Send("+{F10}")

#HotIf
