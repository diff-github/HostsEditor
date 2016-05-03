#Region     #pragma
#pragma compile(x64, false)
#EndRegion  #pragma

#Region     #...
#RequireAdmin
#NoTrayIcon
#EndRegion  #...

#Region     AutoItSetOption
Opt("MustDeclareVars", 1)
Opt("GUICloseOnESC",   0)
#EndRegion  AutoItSetOption

#Region     #include
#include <String.au3>
#include <Process.au3>
#include <GUIConstants.au3>
#include <FontConstants.au3>
#EndRegion  #include

;; allow only one instance
If @Compiled Then
Local $procList

    $procList = ProcessList(@ScriptName)
    If @error Then
    ElseIf $procList[0][0] <> 1 Then
        Exit(1)
    EndIf
EndIf

Const $_HOSTS_FILE      = @WindowsDir & _HexToString(StringReverse("374737F686C5364756C537275667962746C52333D65647379735C5"))
Const $_LOG_STDOUT      = @ScriptDir  & _HexToString(StringReverse("458545E274F4C4C5"))

Local $hGUI = GUICreate(_HexToString(StringReverse("27F64796465402374737F684")), 780, 570, Default, Default, $WS_CAPTION)
GUISetFont(8, $FW_NORMAL, $GUI_FONTNORMAL, "Courier", $hGUI)

Local $lblHosts     = GUICtrlCreateLabel("File:",       10, 15)
Local $btnReload    = GUICtrlCreateButton("Reload",    490, 10,  80)
Local $btnSave      = GUICtrlCreateButton("Save",      590, 10,  80)
Local $btnExit      = GUICtrlCreateButton("Exit",      690, 10,  80)
Local $txtHosts     = GUICtrlCreateInput($_HOSTS_FILE,  10, 40, 760,  20, $ES_READONLY)
Local $txtHostsContents = GUICtrlCreateEdit("",          0, 65, 780, 325)

Local $lblName      = GUICtrlCreateLabel("Name:",       10, 400)
Local $txtName      = GUICtrlCreateInput("",            60, 398, 600)
Local $btnPing      = GUICtrlCreateButton("Ping",      690, 395,  80)
Local $txtPing      = GUICtrlCreateEdit("",              0, 425, 780, 145)

GUISetState(@SW_SHOW, $hGUI)
btnReloadClick()
While True
    Switch GUIGetMsg()
        Case $btnExit, $GUI_EVENT_CLOSE
            btnExitClick()
        Case $btnSave
            btnSaveClick()
        Case $btnReload
            btnReloadClick()
        Case $btnPing
            btnPingClick()
        Case Else
    EndSwitch
WEnd

Func btnExitClick()
    Exit
EndFunc
Func btnSaveClick()
Local $hFile

    $hFile = FileOpen($_HOSTS_FILE, 2) ;$FO_OVERWRITE
    FileWrite($hFile, GUICtrlRead($txtHostsContents))
    FileClose($hFile)
EndFunc
Func btnReloadClick()
    GUICtrlSetData($txtHostsContents, FileRead($_HOSTS_FILE))
EndFunc
Func btnPingClick()
    GUICtrlSetData($txtPing, "")
    _RunDos(StringFormat("ping.exe %s > ""%s""", GUICtrlRead($txtName), $_LOG_STDOUT))
    If @error Then
        Return
    EndIf
    GUICtrlSetData($txtPing, FileRead($_LOG_STDOUT))
EndFunc
