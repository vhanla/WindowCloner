WindowCloner
------------

WindowCloner is a window cloner like Picture-in-Picture feature offered by web browsers like Firefox or Chrome that
allows users to pop out HTML5 video canvas in a small window always on top in order to enjoy the video without
having to focus the browser.

In this case, it will use DWMThumbnail API to copy any window's rendering to a small Picture-In-Picture like small
window, with the following planned features:

- [x] Easy to pick list of running windows
- [x] Capable to mute/unmute audio in application's window
- [x] Easy to switch selected windows 
- [x] Clickthrough feature
- [x] Resizable on mousewheel
- [x] FullScreen mode 
- [ ] Remember size settings for specific applications
- [x] Opacity level adjustable
- [ ] Multiple Picture-In-Picture windows
- [ ] Click forwarding 
- [ ] Keyboard forwarding
- [x] Hidden from taskbar, system tray icon
- [ ] Easy to switch among Picture-In-Picture windows (ctrl-tab)
- [x] Hotkeys actions
- [x] Follow mouse cursor

These are planned features, some might change or disappear, it is only a plan.

### Hotkeys

- F, F11 or Alt-Enter to toggle FullScreen mode
- M to mute or unmute if selected window has audio
- Ctrl-Alt-Shift disables follow mouse cursor while holding them

### Known Issues

- Hiding from taskbar disables clickthrough feature, it needs application restart

### Hint

- Setting Hide from taskbar + follow cursor + Clickthrough it will make it hide from Alt-Tab 

