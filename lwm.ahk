#Warn
#SingleInstance, force
SendMode, event
CoordMode, Mouse, Screen
#NoTrayIcon
#WinActivateForce
; aimp = ahk_class
; scriptver = 1.0.3
; latest update: completely rework ms teams

htk = 0 ;prevent running multiple hotkeys at once - 1 hotkey is running - 0 you can run hotkey
monitor_width = 2560 ; 2560 if you have a 1440p main monitor, 1920 if you have a 1080p monitor - this is offset that this script considers second monitor
top_offset = 0

;hotkeys
F13::
^#Numpad0:: ;minimize all
    if (htk == 0) {
        htk = 1
        WinMinimize, ahk_exe Discord.exe
        AimpMinimize()
        WinGet, teamswins, List, ahk_exe Teams.exe
        Loop, % teamswins {
            PostMessage, 0x0112, 0xF020,,, % "ahk_id " teamswins%A_Index%
            Sleep, 50
        }
        htk = 0
    }
return

F14::
^#Numpad1:: ; discord fullscreen
    if (htk == 0) {
        htk = 1
        AimpMinimize()
        WinGet, teamswins, List, ahk_exe Teams.exe
        Loop, % teamswins {
            PostMessage, 0x0112, 0xF020,,, % "ahk_id " teamswins%A_Index%
            Sleep, 50
        }
        EnsureDiscordIsOnSecondaryMonitor(monitor_width)
        WinMove, ahk_exe Discord.exe,,% monitor_width, % top_offset
        WinMaximize, ahk_exe Discord.exe
        WinActivate, ahk_exe Discord.exe
        htk = 0
    }
return

F15::
^#Numpad2:: ;discord + aimp
    if (htk == 0) {
        htk = 1
        WinGet, teamswins, List, ahk_exe Teams.exe
        Loop, % teamswins {
            PostMessage, 0x0112, 0xF020,,, % "ahk_id " teamswins%A_Index%
            Sleep, 50
        }
        WinRestore, ahk_exe Discord.exe
        WinMove, ahk_exe Discord.exe,, % monitor_width , % top_offset, 1318, 1040
        if !WinExist("ahk_exe AIMP.exe") {
            RunAimp()
        }
        AimpMaximize()
        WinRestore, ahk_exe Discord.exe
        WinMove, ahk_exe Discord.exe,, % monitor_width, % top_offset, 1318, 1040
        WinActivate, ahk_exe AIMP.exe
        htk = 0
    }
return

F16::
^#Numpad3:: ;teams
    if (htk == 0) {
        htk = 1
        WinMinimize, ahk_exe Discord.exe
        AimpMinimize()
        SetTitleMatchMode, 2
        WinGet, teamswins, List, Microsoft Teams
        ; sanity check restore all windows
        Loop, % teamswins {
            WinGet, Minmaxed, MinMax, % "ahk_id " teamswins%A_Index%
            if (Minmaxed == -1)
                WinRestore, % "ahk_id " teamswins%A_Index%
            WinGet, Minmaxed, MinMax, % "ahk_id " teamswins%A_Index%
            if (Minmaxed == 1)
                WinRestore, % "ahk_id " teamswins%A_Index%

        }
        if (teamswins == 1) { ;only one main window open
            hasmax := 0
            Loop, % teamswins { ;Loops to see if the window is maximised
                WinGet, Minmaxed, MinMax, % "ahk_id " teamswins%A_Index%
                if (Minmaxed == 1)
                    hasmax := 1
            }
            if (hasmax == 0) { ; if it's not maximised, maximise it.
                WinRestore, % "ahk_id " teamswins1
                WinMove, % "ahk_id " teamswins1,, % monitor_width, % top_offset, 1920, 1040
                WinMaximize, % "ahk_id " teamswins1
            }
        } else if (teamswins > 1) {
            hasmax := 0
            Loop, % teamswins { ;restore maximised windows
                WinGet, Minmaxed, MinMax, % "ahk_id " teamswins%A_Index%
                if (Minmaxed == 1)
                    WinRestore, % "ahk_id " teamswins%A_Index%
            }
            tallest := 0
            tallestwin := 0
            secondtallest := 0
            secondtallestwin := 0
            shortest := 100000000000000000 ;a smaller value will replace this
            shortestwin := 0

            Loop, % teamswins { ;Loops to get all heights, max and second largest height
                WinGetPos,,,,height,% "ahk_id " teamswins%A_Index%
                if (height >= tallest){
                    secondtallest := tallest
                    secondtallestwin := tallestwin
                    tallest := height
                    tallestwin := A_Index
                } else if (height < tallest && secondtallest == 0) {
                    secondtallest := height
                    secondtallestwin := A_Index
                }
                if (height < shortest) {
                    shortest := height
                    shortestwin := A_Index
                }
            }
            WinGetTitle, tallesttitle, % "ahk_id " teamswins%tallestwin%
            WinGetTitle, secondtitle, % "ahk_id " teamswins%secondtallestwin%

            WinMove, % "ahk_id " teamswins%tallestwin%,, % monitor_width, % top_offset, 720, 1040
            WinMove, % "ahk_id " teamswins%secondtallestwin%,, % monitor_width + 725, % top_offset + 5, 1190, 1030

            ;MsgBox, tallest: %tallesttitle% - secondtallest: %secondtitle%
        }
        htk = 0
    }
return

^#F1::
    if !WinExist("lwm_hotkeys") {
        Gui, New, -MinimizeBox, lwm_hotkeys
        Gui, Font, s20,
        Gui, add, Text,, lwm
        Gui, font, s10,
        Gui, add, Text,, layout window manager `n`nby KraXen72
        Gui, add, Text,, F13 / ctrl + win + num0 - lwm: hideall `nF14 / ctrl + win + num1 - lwm: discord fullscreen`nF15 / ctrl + win + num2 - lwm: discord + aimp`nF16 / ctrl + win + num3 - lwm: ms teams`n`nctrl + win + num7 - Teams connection throttle`nctrl + win + num8 - mic: unmute`nctrl + win + num9 - mic: mute`nF24 - obs: toggle freeze
        Gui, Show
    }
return

;functions

AimpMinimize()
{
    WinGetPos, aimpx, aimpy, aimpw, aimph, ahk_class TAIMPMainForm
    if (aimph > 200) {
        Send, ^+{F6}
    } 
}

AimpMaximize()
{
    WinGetPos, aimpx, aimpy, aimpw, aimph, ahk_class TAIMPMainForm
    if (aimph < 200) {
        Send, ^+{F6}
    } 
}

RunAimp() {
    Run, "D:\coding\ahk\Aimp.lnk"
    Tooltip, waiting for aimp..., 1921, 0
        SLeep, 2500
    Tooltip, 
    AimpMaximize()
}

EnsureDiscordIsOnSecondaryMonitor(monitor_width)
{
    WinGetPos, discx, discy, discw, disch, ahk_exe Discord.exe
    ;Tooltip, %discx%
    if (discx < (monitor_width - 8)) {
        WinRestore, ahk_exe Discord.exe
    }
}