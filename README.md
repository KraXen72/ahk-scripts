# my ahk scripts
this repo is mostly for backup purposes for me or if someone asks me what i'm using. other than lwm, nothing here is too useful.

## lwm
layout window manager, inspired by tam's programatic floating, but for windows and for the second monitor.
this adds a few quick hotkeys to instantly change what app is on the second monitor.  
![lwm preview](https://cdn.discordapp.com/attachments/704792091955429426/936287124259504198/ezgif-2-21e6864d46.gif)  

### notes on lwm:
* if you don't have some of the apps, don't worry it will just work with what it has
* if you use discord canary or ptb, just replace all occurences of ``Discord.exe`` with ``DiscordCanary.exe`` or ``DiscordPTB.exe``
* you have to position aimp to the top right corner of secondary monitor and use a theme like [Urania](http://www.aimp.ru/?do=catalog&rec_id=762) or [Messa](http://www.aimp.ru/?do=catalog&rec_id=1205)
* change your primary monitor width in the code, variable monitor_width.
* change the path in ``RunAimp()`` function to a valid exe or lnk path that opens aimp
* in aimp settings, change the ``Minimize/Maximize`` hotkey to ``Ctrl + Shift + F6``
  
![lwm hotkeys](https://cdn.discordapp.com/attachments/704792091955429426/936281755198062653/Capture_2022_m01.d27_1628.png)
  
## micscript.ahk
requires mathisvicke's packet choker. if you don't know what that is or don't have access to it, then this script is only two hotkeys for toggling the mic which don't really work half the time

## numpaddot.ahk
remaps the numpad comma to be a dot bc it's better

