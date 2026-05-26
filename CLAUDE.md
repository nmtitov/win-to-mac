# CLAUDE.md — win-to-mac

AutoHotkey v2 script that emulates macOS keyboard layout on Windows.

## Architecture

Physical keys are remapped at scancode level via **KeyTweak** (registry):
1. Caps Lock → Left Control
2. Left Win → Left Alt (Option)
3. Left Alt → Right Control (used as "Cmd" in AHK)

AHK then maps:
- **RCtrl (Cmd)** → full set of Cmd shortcuts (A–Z, arrows, backspace) mapped to Ctrl equivalents
- **LCtrl (physical CapsLock)** → Emacs-style bindings (Ctrl+A → Home, Ctrl+E → End, etc.)
- **Alt (physical LWin → LAlt)** → Option key (word navigation, word deletion)

### Why every Cmd+Key needs explicit mapping

When a key is used as prefix in `&` combos (e.g., `RCtrl & A`), AHK disables its native modifier function. This means RCtrl **cannot** act as a normal Ctrl modifier for unmapped keys. Pressing RCtrl+Key for a key NOT listed in the script will just type the key without Ctrl. Every common Cmd shortcut must be explicitly listed.

### Cmd+Shift shortcuts must use GetKeyState, not `>^+`

Because RCtrl is a `&` prefix, `>^+P::` (RCtrl+Shift+P) **never fires** — AHK matches `RCtrl & P` first and ignores Shift. The fix: check `GetKeyState("Shift")` inside the `RCtrl & X` hotkey block. This applies to any key that has both a `RCtrl & X` combo and a Cmd+Shift variant. `>^+` syntax only works for keys that do NOT have a `RCtrl &` combo (e.g., `>^Tab`, `>^+sc01A`).

### Terminal section

Terminal intercepts Ctrl+Key for shell signals (Ctrl+C = SIGINT, Ctrl+Z = SIGTSTP). The `#HotIf WinActive("ahk_exe WindowsTerminal.exe")` section overrides global Cmd shortcuts to send Alt+Key combos instead. These Alt+Key combos are bound to Terminal actions in the Windows Terminal `settings.json` keybindings.

**Terminal keybindings required** (in `settings.json`):

| Alt+Key | Terminal Action ID | Purpose |
|---------|-------------------|---------|
| alt+c | Terminal.CopyToClipboard | Copy |
| alt+d | Terminal.ClosePane | Close pane |
| alt+w | Terminal.CloseTab | Close tab |
| alt+t | Terminal.DuplicateTab | New tab (same profile/dir) |
| alt+n | Terminal.OpenNewWindow | New window |
| alt+f | Terminal.FindText | Find/search |

Shell-native shortcuts (no Terminal binding needed):
- Cmd+K → Ctrl+L (clear screen)
- Cmd+Backspace → Ctrl+U (kill line backward)

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

`A_MenuMaskKey := "vkE8"` prevents Start Menu from appearing when AHK suppresses Win/Alt key events (e.g., during rapid Cmd+Space language switching). `LWin`/`RWin` hotkeys send `{Blind}{vkE8}` instead of `return` because plain `return` doesn't suppress the key-up event on Windows 11. Physical LWin is already remapped to LAlt via KeyTweak so `LWin::` is a safety net. `RWin::` handles the right Win key if the keyboard has one.

These do NOT interfere with `Send("#...")` (Win+Space, Win+L etc.) because AHK's `Send` doesn't re-trigger its own hotkeys.

## Known issues

- Session lock (`>^<^Q`) and shutdown (`>^+Q`) hotkeys don't work (marked TODO in script)
- Modifier sticking can still happen occasionally with Alt+Tab — the T5 timeout limits it to 5 seconds max
