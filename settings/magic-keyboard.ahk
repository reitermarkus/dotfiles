#Requires AutoHotkey v2.0
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force

SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

$#a::Send "^a"             ; Select all
$#c::Send "^c"             ; Copy
$#v::Send "^v"             ; Paste
$#x::Send "^x"             ; Cut
$#s::Send "^s"             ; Save
$#o::Send "^o"             ; Open
$#p::Send "^p"             ; Print
$#w::Send "^w"             ; Close window
$#z::Send "^z"             ; Undo
$#+z::Send "^y"            ; Redo
$#q::Send "!{f4}"          ; Close application
$#f::Send "^f"             ; Find
$#t::Send "^t"             ; New tab
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
#HotIf not WinActive("ahk_class" "SDL_app") ; Disable in Counter Strike
$^e::Send "{End}"                           ; Jump to beginning of line
#HotIf not WinActive("ahk_class" "SDL_app") ; Disable in Counter Strike
$^+a::Send "+{Home}"                        ; Select to beginning of line
#HotIf not WinActive("ahk_class" "SDL_app") ; Disable in Counter Strike
$^+e::Send "+{End}"                         ; Select to end of line
#HotIf not WinActive("ahk_class" "SDL_app") ; Disable in Counter Strike
$^k::Send "{ShiftDown}{End}{ShiftUp}{Del}"  ; Delete rest of line

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

<::^
>::°
^::<
°::>
