#NoEnv
Sendmode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance, force
#NoTrayIcon 

muted = 0
injected = 0
monitor_width = 2560

^#Numpad9:: ;mute
    IF !WinExist("ahk_exe Teams.exe") {
            injected = 0
        }
    Run D:\coding\ahk\micmute\nircmd.exe mutesysvolume 1 microphone
    Return

^#Numpad8:: ;unmute
    IF !WinExist("ahk_exe Teams.exe") {
            injected = 0
        }
    Run D:\coding\ahk\micmute\nircmd.exe mutesysvolume 0 microphone
    Run D:\coding\ahk\micmute\nircmd.exe setsysvolume 65535 microphone
    Tooltip,,,,2
    Return

^#Numpad7:: ;throttle
    IF !WinExist("ahk_exe Teams.exe") {
        injected = 0
    }
    if !WinExist("micscript_lag") {
        GUi, New,+AlwaysOnTop -Resize -MinimizeBox, micscript_lag
        GuiControl, -Default, OK
        GUi, Add, Text,, ConnectionThrottler
        Gui, Font, w700 s12
        Gui, Add, Text, vStatus, Not injected
        Gui, Font, w400 s11
        GUi, Add, Button, w200, Inject
        Gui, Font, w700 s12
        if (InStr(FileExist("D:\t"), "D") == True) {
            Gui, Add, Text, vTEnabled +cGreen, Enabled    
        }else {
            Gui, Add, Text, vTEnabled +cRed , Disabled    
        }
        Gui, Font, w400 s11
        Gui, Add, Button, w200, Enable
        Gui, Add, Button, w200, Disable
        Gui, Add, Text, vSonyTitle, BT Headphones Connected:
        ;Gui, Add, Text, vState, getting info...
        Gui, Add, Button, w200, Connect
        Gui, Add, Button, w200, Disconnect
        Gui, Show, % "x" . monitor_width - 240 . " Y50"
        if (injected == 1) {
            GuiControl,, Status, Injected
        }
    }
Return

ButtonEnable:
    if (InStr(FileExist("D:\t"), "D") == False) {
        FileCreateDir, D:\t
    }
    GuiControl, +cGreen, TEnabled
    GuiControl,, TEnabled, Enabled
    SetTimer, ClearTooltip, -2000
return

ButtonDisable:
    if (InStr(FileExist("D:\t"), "D") == True) {
        FileRemoveDir, D:\t
    }
    GuiControl, +cRed, TEnabled
    GuiControl,, TEnabled, Disabled
    SetTimer, ClearTooltip, -2000

return

ButtonInject:
    if WinExist("ahk_exe Teams.exe") {
        Tooltip, injecting,,,2
        Run, "D:\coding\ahk\fuckmyconnection\start.lnk"
        injected = 1
        GuiControl,, Status, Injected
        Tooltip,,,,2
    } else {
        Tooltip, Teams not running. Injection not possible.,,,2
        SetTimer, ClearTooltip, -2000
    }
return

ButtonConnect:
    Tooltip, Attempting to connect to headphones...,,,2
    SetTimer, ClearTooltip, -2000
    Run, D:\coding\ahk\tools\bt\btcom.exe -b"14:3F:A6:47:23:8F" -c -s110b
    Run, D:\coding\ahk\tools\bt\btcom.exe -b"14:3F:A6:47:23:8F" -c -s111e
    ;getBT()
return

ButtonDisconnect:
    Tooltip, Attempting to disconnect headphones...,,,2
    SetTimer, ClearTooltip, -2000
    Run, D:\coding\ahk\tools\bt\btcom.exe -b"14:3F:A6:47:23:8F" -r -s110b
    Run, D:\coding\ahk\tools\bt\btcom.exe -b"14:3F:A6:47:23:8F" -r -s111e
    ;getBT()
return

ClearTooltip:
    Tooltip,,,,2
return

getBT() {
    FileDelete, D:\coding\ahk\bt\test.txt
    Run, D:\coding\ahk\bt\bruh.lnk,,Min
    WinWait, ahk_exe cmd.exe
    WinWaitClose
    
    FileRead, BTState, D:\coding\ahk\bt\test.txt
    ;MsgBox, %State%
    GuiControl,, State, %BTState%
}