#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

$#a::Send ^a             ; Select all
$#c::Send ^c             ; Copy
$#v::Send ^v             ; Paste
$#x::Send ^x             ; Cut
$#s::Send ^s             ; Save
$#o::Send ^o             ; Open
$#p::Send ^p             ; Print
$#w::Send ^w             ; Close window
$#z::Send ^z             ; Undo
$#+z::Send ^y            ; Redo
$#q::Send !{f4}          ; Close application
$#f::Send ^f             ; Find
$#t::Send ^t             ; New tab
$#l::Send ^l             ; Jump to address bar
$#r::Send ^r             ; Reload page
LWin & Tab::AltTab       ; Switch application
RWin & Tab::AltTab       ; Switch application

$LWin::Return            ; Don't open start menu
$RWin::Return            ; Don't open start menu
LWin & RWin::Return      ; Don't open start menu
$#Space::LWin            ; Open start menu

$!Left::Send ^{Left}     ; Move one word left
$!Right::Send ^{Right}   ; Move one word right
$!+Left::Send ^+{Left}   ; Select one word left
$!+Right::Send ^+{Right} ; Select one word right

$^a::Send {Home}         ; Jump to beginning of line
$^e::Send {End}          ; Jump to beginning of line
$^+a::Send +{Home}       ; Select to beginning of line
$^+e::Send +{End}        ; Select to end of line

$^k::Send {ShiftDown}{End}{ShiftUp}{Del} ; Delete rest of line

$#^q::DllCall("LockWorkStation") ; Lock screen

$!1::Send ¡
$!2::Send “
$!+2::Send ”
$!+w::Send „
$!q::Send «
$!+q::Send »
$!3::Send ¶
$!4::Send ¢
$!5::Send [
$!6::Send ]
$!7::Send |
$!+7::Send \
$!8::Send {{}
$!9::Send {}}
$!0::Send ≠
$!ß::Send ¿

$!#::Send ‘
$!+#::Send ’
$!e::Send €
$!p::Send π
$!+p::Send Π
$!n::Send ~
$!m::Send μ
$!.::Send …
$!l::Send @
$!$+::Send ±
$!a::Send å
$!+a::Send Å

<::^
>::°
^::<
°::>
