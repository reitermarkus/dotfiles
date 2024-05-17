#Requires AutoHotkey v2.0
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force

SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

$#1::Send "^1" ; Switch to tab 1
$#2::Send "^2" ; Switch to tab 2
$#3::Send "^3" ; Switch to tab 3
$#4::Send "^4" ; Switch to tab 4
$#5::Send "^5" ; Switch to tab 5
$#6::Send "^6" ; Switch to tab 6
$#7::Send "^7" ; Switch to tab 7
$#8::Send "^8" ; Switch to tab 8
$#9::Send "^9" ; Switch to last tab

$#LButton::Send "^{LButton}" ; Open Link in new tab

$#a::Send "^a"             ; Select all
$#c::Send "^c"             ; Copy
$#v::Send "^v"             ; Paste
$#x::Send "^x"             ; Cut
$#s::Send "^s"             ; Save
$#o::Send "^o"             ; Open
$#p::Send "^p"             ; Print
$#z::Send "^z"             ; Undo
$#+z::Send "^y"            ; Redo
$#q::Send "!{f4}"          ; Quit
$#r::Send "^r"             ; Reload
$#f::Send "^f"             ; Find
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
$#t::Send "^+t"            ; New tab
$#w::Send "^+w"            ; Close window or tab
#HotIf
$#t::Send "^t"             ; New tab
$#w::Send "^w"             ; Close window or tab

$#l::Send "^l"             ; Jump to address bar
LWin & Tab::AltTab         ; Switch application
RWin & Tab::AltTab         ; Switch application
 
$~LWin::vkE8                ; Don't open start menu
$~RWin::vkE8                ; Don't open start menu
$#Space::LWin               ; Open start menu

$!Left::Send "^{Left}"     ; Move one word left
$!Right::Send "^{Right}"   ; Move one word right
$!+Left::Send "^+{Left}"   ; Select one word left
$!+Right::Send "^+{Right}" ; Select one word right

#HotIf not WinActive("ahk_class" "SDL_app") ; Disable in Counter Strike
$^a::Send "{Home}"                          ; Jump to beginning of line
$^e::Send "{End}"                           ; Jump to beginning of line
$^+a::Send "+{Home}"                        ; Select to beginning of line
$^+e::Send "+{End}"                         ; Select to end of line
$^k::Send "{ShiftDown}{End}{ShiftUp}{Del}"  ; Delete rest of line
#HotIf

$#^q::DllCall("LockWorkStation") ; Lock screen

$!1::Send "¡"
$!2::Send "“"
$!+2::Send "”"
$!+w::Send "„"
$!q::Send "«"
$!+q::Send "»"
$!3::Send "¶"
$!4::Send "¢"
$!5::Send "["
$!6::Send "]"
$!7::Send "|"
$!8::Send "{{}"
$!9::Send "{}}"
$!0::Send "≠"
$!ß::Send "¿"

$!#::Send "‘"
$!+#::Send "’"
$!e::Send "€"
$!p::Send "π"
$!+p::Send "Π"
$!n::Send "~"
$!m::Send "μ"
$!.::Send "…"
$!l::Send "@"
$!$+::Send "±"
$!a::Send "å"
$!+a::Send "Å"

$#$+::Send "^{+}" ; Zoom in
$#$-::Send "^{-}" ; Zoom out
$#0::Send "^0"    ; Reset zoom

$#+3::Send "#{PrintScreen}" ; Fullscreen screenshot
$#+4::Send "#+S"            ; Selection screenshot

<::^
>::°
^::<
°::>
