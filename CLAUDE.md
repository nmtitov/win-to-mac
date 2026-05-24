# CLAUDE.md — win-to-mac

AutoHotkey v2 script that emulates macOS keyboard layout on Windows.

## Architecture

Physical keys are remapped at scancode level via **KeyTweak** (registry):
1. Caps Lock → Left Control
2. Left Win → Left Alt (Option)
3. Left Alt → Right Control (used as "Cmd" in AHK)

AHK then maps RCtrl-based combos to Cmd-like behavior (Cmd+Q → Alt+F4, Cmd+A → Ctrl+A, etc.) and LCtrl-based combos to terminal-style Emacs bindings (Ctrl+A → Home, Ctrl+E → End, etc.).

## Performance — critical lessons

### DO NOT add `{XCtrl up}` / `{Alt up}` to every `&` hotkey

Adding explicit modifier release (`{LCtrl up}`, `{RCtrl up}`, `{Alt up}`) before `Send` in ALL `&` combo hotkeys causes noticeable input lag — keys feel sluggish, like they need to be pressed harder. The extra virtual key events per keystroke add up.

Only add `{LCtrl up}` where it's strictly necessary (currently: `LCtrl & W` for word deletion, because `^{Backspace}` and `!{Backspace}` combine with the held LCtrl otherwise).

### DO NOT use `InstallKeybdHook`

Forces ALL keystrokes through AHK's hook, not just the ones involved in `&` combos. Adds latency to every key.

### `&` combo prefix delay is inherent

When a key is used as prefix in `&` combos (e.g., `LCtrl & A`), AHK suppresses it on press and waits for the suffix key. This adds a small delay to the prefix key. This is unavoidable and expected — don't try to fix it.

## Terminal matching

Use `ahk_exe WindowsTerminal.exe`, not window title. The `PROMPT_COMMAND` in `.bash_profile` sets the title to the current directory, so `WinActive("Terminal")` won't match.

## Alt+Tab handler

Uses `KeyWait("RCtrl", "T5")` with a 5-second timeout. Without timeout, if AHK loses track of the RCtrl state, Alt stays stuck forever.

## Start Menu suppression

`LWin::return` and `RWin::return` suppress both Win keys. Physical LWin is already remapped to LAlt via KeyTweak so `LWin::return` is a safety net. `RWin::return` handles the right Win key if the keyboard has one.

These do NOT interfere with `Send("#...")` (Win+Space, Win+L etc.) because AHK's `Send` doesn't re-trigger its own hotkeys.

## Known issues

- Session lock (`>^<^Q`) and shutdown (`>^+Q`) hotkeys don't work (marked TODO in script)
- Modifier sticking can still happen occasionally with Alt+Tab — the T5 timeout limits it to 5 seconds max
