;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; geany.nsi - this file is part of Geany, a fast and lightweight IDE
;
; Copyright 2007-2009 Enrico Tröger <enrico(dot)troeger(at)uvena(dot)de>
; Copyright 2007-2009 Nick Treleaven <nick(dot)treleaven(at)btinternet(dot)com>
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
;
; $Id$
;
; Installer script for Geany (Windows Installer)
; (Script originally generated by the HM NIS Edit Script Wizard)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Do a Cyclic Redundancy Check to make sure the installer was not corrupted by the download
CRCCheck force
RequestExecutionLevel user ; set execution level for Windows Vista

;;;;;;;;;;;;;;;;;;;
; helper defines  ;
;;;;;;;;;;;;;;;;;;;
!define PRODUCT_NAME "Geany"
!define PRODUCT_VERSION "0.17"
!define PRODUCT_VERSION_ID "0.17.0.0"
!define PRODUCT_PUBLISHER "The Geany developer team"
!define PRODUCT_WEB_SITE "http://www.geany.org/"
!define PRODUCT_DIR_REGKEY "Software\Geany"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_EXE "$INSTDIR\bin\Geany.exe"
!define PRODUCT_REGNAME "Geany.ProjectFile"
!define PRODUCT_EXT ".geany"
!define RESOURCEDIR "geany-${PRODUCT_VERSION}"

;;;;;;;;;;;;;;;;;;;;;
; Version resource  ;
;;;;;;;;;;;;;;;;;;;;;
VIProductVersion "${PRODUCT_VERSION_ID}"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "FileVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "LegalCopyright" "Copyright 2005-2009 by the Geany developer team"
VIAddVersionKey "FileDescription" "${PRODUCT_NAME} Installer"

BrandingText "$(^NAME) installer (NSIS 2.44)"
InstallDir "$PROGRAMFILES\Geany"
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
SetCompressor /SOLID lzma
ShowInstDetails hide
ShowUnInstDetails hide
XPStyle on
!ifdef INCLUDE_GTK
OutFile "geany-${PRODUCT_VERSION}_setup.exe"
!else
OutFile "geany-${PRODUCT_VERSION}_nogtk_setup.exe"
!endif

Var Answer
Var UserName
Var StartmenuFolder
Var UNINSTDIR

;;;;;;;;;;;;;;;;
; MUI Settings ;
;;;;;;;;;;;;;;;;
!include "MUI2.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON "pixmaps\geany.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-full.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
;!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "${RESOURCEDIR}\Copying.txt"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE OnDirLeave
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "Geany"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
!insertmacro MUI_PAGE_STARTMENU ${PRODUCT_NAME} "$StartmenuFolder"
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\News.txt"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Show Release Notes"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_RUN "$INSTDIR\bin\Geany.exe"
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_INSTFILES ; Uninstaller page
!insertmacro MUI_LANGUAGE "English" ; Language file

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sections and InstTypes  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
InstType "Full"
InstType "Minimal"

Section "!Program Files" SEC01
	SectionIn RO 1 2
	SetOverwrite ifnewer

	SetOutPath "$INSTDIR"
	File "${RESOURCEDIR}\*.txt"

	SetOutPath "$INSTDIR\bin"
	File "${RESOURCEDIR}\bin\Geany.exe"

	SetOutPath "$INSTDIR\data"
	File "${RESOURCEDIR}\data\GPL-2"
	File "${RESOURCEDIR}\data\file*"
	File "${RESOURCEDIR}\data\snippets.conf"
	File "${RESOURCEDIR}\data\ui_toolbar.xml"

	SetOutPath "$INSTDIR\share\icons"
	File /r "${RESOURCEDIR}\share\icons\*"

	SetOutPath "$INSTDIR"

	CreateShortCut "$INSTDIR\Geany.lnk" "$INSTDIR\bin\Geany.exe"
	!insertmacro MUI_STARTMENU_WRITE_BEGIN ${PRODUCT_NAME}
	CreateDirectory "$SMPROGRAMS\$StartmenuFolder"
	CreateShortCut "$SMPROGRAMS\$StartmenuFolder\Geany.lnk" "$INSTDIR\bin\Geany.exe"
	!insertmacro MUI_STARTMENU_WRITE_END

	; register the extension .geany
	; write information about file type
	WriteRegStr SHCTX "Software\Classes\${PRODUCT_REGNAME}" "" "${PRODUCT_NAME} Project File"
	WriteRegStr SHCTX "Software\Classes\${PRODUCT_REGNAME}\DefaultIcon" "" "${PRODUCT_EXE},0"
	WriteRegStr SHCTX "Software\Classes\${PRODUCT_REGNAME}\Shell\open\command" "" '"${PRODUCT_EXE}" "%1"'
	; write information about file extensions
	WriteRegStr SHCTX "Software\Classes\${PRODUCT_EXT}" "" "${PRODUCT_REGNAME}"
	; refresh shell
	System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) (0x08000000, 0, 0, 0)'
SectionEnd

Section "Plugins" SEC02
	SectionIn 1
	SetOverwrite ifnewer
	SetOutPath "$INSTDIR\lib"
	File "${RESOURCEDIR}\lib\*.dll"
SectionEnd

Section "Language Files" SEC03
	SectionIn 1
	SetOutPath "$INSTDIR\share\locale"
	File /r "${RESOURCEDIR}\share\locale\*"
!ifdef INCLUDE_GTK
	SetOutPath "$INSTDIR\share"
	File /r "gtk\share\*"
!endif
SectionEnd

Section "Documentation" SEC04
	SectionIn 1
	SetOverwrite ifnewer
	SetOutPath "$INSTDIR"
	File /r "${RESOURCEDIR}\doc"
	WriteIniStr "$INSTDIR\Documentation.url" "InternetShortcut" "URL" "$INSTDIR\doc\Manual.html"
	!insertmacro MUI_STARTMENU_WRITE_BEGIN ${PRODUCT_NAME}
	CreateShortCut "$SMPROGRAMS\$StartmenuFolder\Documentation.lnk" "$INSTDIR\Documentation.url"
	!insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "Autocompletion Tags" SEC05
	SectionIn 1
	SetOutPath "$INSTDIR\data"
	SetOverwrite ifnewer
	File "${RESOURCEDIR}\data\php.tags"
	File "${RESOURCEDIR}\data\pascal.tags"
	File "${RESOURCEDIR}\data\latex.tags"
	File "${RESOURCEDIR}\data\python.tags"
	File "${RESOURCEDIR}\data\html_entities.tags"
	File "${RESOURCEDIR}\data\c99.tags"
SectionEnd

; Include GTK runtime library but only if desired from command line
!ifdef INCLUDE_GTK
Section "GTK 2.16 Runtime Environment" SEC06
	SectionIn 1
	SetOverwrite ifnewer
	SetOutPath "$INSTDIR\bin"
	File /r "gtk\bin\*"
	SetOutPath "$INSTDIR\etc"
	File /r "gtk\etc\*"
	SetOutPath "$INSTDIR\lib"
	File /r "gtk\lib\*"
SectionEnd
!endif

Section "Context Menus" SEC07
	SectionIn 1
	WriteRegStr HKCR "*\shell\OpenWithGeany" "" "Open with Geany"
	WriteRegStr HKCR "*\shell\OpenWithGeany\command" "" '$INSTDIR\bin\geany.exe "%1"'
SectionEnd

Section "Desktop Shortcuts" SEC08
	SectionIn 1
	CreateShortCut "$DESKTOP\Geany.lnk" "$INSTDIR\bin\Geany.exe"
	CreateShortCut "$QUICKLAUNCH\Geany.lnk" "$INSTDIR\bin\Geany.exe"
SectionEnd

Section -AdditionalIcons
	SetOutPath $INSTDIR
	!insertmacro MUI_STARTMENU_WRITE_BEGIN ${PRODUCT_NAME}
	WriteIniStr "$INSTDIR\Website.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
	CreateShortCut "$SMPROGRAMS\$StartmenuFolder\Website.lnk" "$INSTDIR\Website.url"
	CreateShortCut "$SMPROGRAMS\$StartmenuFolder\Uninstall.lnk" "$INSTDIR\uninst.exe"
	!insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
	WriteUninstaller "$INSTDIR\uninst.exe"
	WriteRegStr SHCTX "${PRODUCT_DIR_REGKEY}" Path "$INSTDIR"
	WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "StartMenu" "$SMPROGRAMS\$StartmenuFolder"
	${if} $Answer == "yes" ; if user is admin
		WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
		WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
		WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\bin\Geany.exe"
		WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
		WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
		WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "URLUpdateInfo" "${PRODUCT_WEB_SITE}"
		WriteRegStr SHCTX "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
		WriteRegDWORD SHCTX "${PRODUCT_UNINST_KEY}" "NoModify" 0x00000001
		WriteRegDWORD SHCTX "${PRODUCT_UNINST_KEY}" "NoRepair" 0x00000001
	${endif}
SectionEnd

Section Uninstall
	Delete "$INSTDIR\Website.url"
	Delete "$INSTDIR\Documentation.url"
	Delete "$INSTDIR\uninst.exe"
	Delete "$INSTDIR\News.txt"
	Delete "$INSTDIR\ReadMe.txt"
	Delete "$INSTDIR\Thanks.txt"
	Delete "$INSTDIR\ToDo.txt"
	Delete "$INSTDIR\Authors.txt"
	Delete "$INSTDIR\ChangeLog.txt"
	Delete "$INSTDIR\Copying.txt"
	Delete "$INSTDIR\Geany.lnk"

	; delete start menu entry
	ReadRegStr $0 SHCTX "${PRODUCT_UNINST_KEY}" "StartMenu"
	RMDir /r "$0"

	Delete "$QUICKLAUNCH\Geany.lnk"
	Delete "$DESKTOP\Geany.lnk"

	RMDir /r "$INSTDIR\bin"
	RMDir /r "$INSTDIR\doc"
	RMDir /r "$INSTDIR\data"
	RMDir /r "$INSTDIR\etc"
	RMDir /r "$INSTDIR\lib"
	RMDir /r "$INSTDIR\share"
	RMDir "$INSTDIR"

	; remove .geany file extension
	ReadRegStr $R0 SHCTX "Software\Classes\${PRODUCT_EXT}" ""
	${if} $R0 == "${PRODUCT_REGNAME}"
		DeleteRegKey SHCTX "${PRODUCT_EXT}"
		DeleteRegKey HKCR "${PRODUCT_EXT}"
		DeleteRegKey SHCTX "${PRODUCT_REGNAME}"
		DeleteRegKey HKCR "${PRODUCT_REGNAME}"
	${endif}

	DeleteRegKey HKCR "*\shell\OpenWithGeany"

	DeleteRegKey SHCTX "${PRODUCT_UNINST_KEY}"
	DeleteRegKey HKCU "${PRODUCT_UNINST_KEY}"
	DeleteRegKey SHCTX "${PRODUCT_DIR_REGKEY}"
	DeleteRegKey HKCU "${PRODUCT_DIR_REGKEY}"

	SetAutoClose true
SectionEnd

;;;;;;;;;;;;;;;;;;;;;;;;;
; Section descriptions  ;
;;;;;;;;;;;;;;;;;;;;;;;;;
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "Required program files. You cannot skip these files."
!insertmacro MUI_DESCRIPTION_TEXT ${SEC02} "Available plugins like 'Version Diff', 'Class Builder' and 'Insert Special Characters'."
!insertmacro MUI_DESCRIPTION_TEXT ${SEC03} "Various translations of Geany's interface."
!insertmacro MUI_DESCRIPTION_TEXT ${SEC04} "Manual in Text and HTML format."
!insertmacro MUI_DESCRIPTION_TEXT ${SEC05} "Symbol lists necessary for auto completion of symbols."
!ifdef INCLUDE_GTK
!insertmacro MUI_DESCRIPTION_TEXT ${SEC06} "You need this files to run Geany. If you have already installed a GTK Runtime Environment (2.8 or higher), you can skip it."
!endif
!insertmacro MUI_DESCRIPTION_TEXT ${SEC07} "Add context menu item 'Open With Geany'"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC08} "Create shortcuts for Geany on the desktop and in the Quicklaunch Bar"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;;;;;;;;;;;;;;;;;;;;;
; helper functions  ;
;;;;;;;;;;;;;;;;;;;;;

; (from http://jabref.svn.sourceforge.net/viewvc/jabref/trunk/jabref/src/windows/nsis/setup.nsi)
!macro IsUserAdmin Result UName
	ClearErrors
	UserInfo::GetName
	IfErrors Win9x
	Pop $0
	StrCpy ${UName} $0
	UserInfo::GetAccountType
	Pop $1
	${if} $1 == "Admin"
		StrCpy ${Result} "yes"
	${else}
		StrCpy ${Result} "no"
	${endif}
	Goto done

Win9x:
	StrCpy ${Result} "yes"
done:
!macroend

Function .onInit
	StrCpy "$StartmenuFolder" "Geany"

	; (from http://jabref.svn.sourceforge.net/viewvc/jabref/trunk/jabref/src/windows/nsis/setup.nsi)
	; If the user does *not* have administrator privileges, abort
	StrCpy $Answer ""
	StrCpy $UserName ""
	!insertmacro IsUserAdmin $Answer $UserName ; macro from LyXUtils.nsh
	${if} $Answer == "yes"
		SetShellVarContext all ; set that e.g. shortcuts will be created for all users
	${else}
		SetShellVarContext current
		; TODO is this really what we want? $PROGRAMFILES is not much better because
		; probably the unprivileged user can't write it anyways
		StrCpy $INSTDIR "$PROFILE\$(^Name)"
	${endif}

	; prevent running multiple instances of the installer
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "geany_installer") i .r1 ?e'
	Pop $R0
	StrCmp $R0 0 +3
	MessageBox MB_OK|MB_ICONEXCLAMATION "The installer is already running." /SD IDOK
	Abort
	; warn about a new install over an existing installation
	ReadRegStr $R0 SHCTX "${PRODUCT_UNINST_KEY}" "UninstallString"
	StrCmp $R0 "" finish

	MessageBox MB_YESNO|MB_ICONEXCLAMATION \
	"Geany has already been installed. $\nDo you want to remove the previous version before installing $(^Name) ?" \
		/SD IDYES IDYES remove IDNO finish

remove:
	; run the uninstaller
	ClearErrors
	; we read the installation path of the old installation from the Registry
	ReadRegStr $UNINSTDIR SHCTX "${PRODUCT_DIR_REGKEY}" "Path"
	IfSilent dosilent nonsilent
dosilent:
	ExecWait '$R0 /S _?=$UNINSTDIR' ;Do not copy the uninstaller to a temp file
	Goto finish
nonsilent:
	ExecWait '$R0 _?=$UNINSTDIR' ;Do not copy the uninstaller to a temp file
finish:
FunctionEnd

Function un.onUninstSuccess
	HideWindow
	MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer." \
		/SD IDOK
FunctionEnd

Function un.onInit
	; If the user does *not* have administrator privileges, abort
	StrCpy $Answer ""
	!insertmacro IsUserAdmin $Answer $UserName
	${if} $Answer == "yes"
		SetShellVarContext all
	${else}
		; check if the Geany has been installed with admin permisions
		ReadRegStr $0 HKLM "${PRODUCT_UNINST_KEY}" "Publisher"
		${if} $0 != ""
			MessageBox MB_OK|MB_ICONSTOP "You need administrator privileges to uninstall Geany!" \
				/SD IDOK
			Abort
		${endif}
		SetShellVarContext current
	${endif}

	MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" \
		/SD IDYES IDYES +2
	Abort
FunctionEnd

Function OnDirLeave
	ClearErrors
	SetOutPath "$INSTDIR" ; what about IfError creating $INSTDIR?
	GetTempFileName $1 "$INSTDIR" ; creates tmp file (or fails)
	FileOpen $0 "$1" "w" ; error to open?
	FileWriteByte $0 "0"
	IfErrors notPossible possible

notPossible:
	RMDir "$INSTDIR" ; removes folder if empty
	MessageBox MB_OK "The given directory is not writeable. Please choose another one!" /SD IDOK
	Abort
possible:
	FileClose $0
	Delete "$1"
FunctionEnd
