; ============================================================================
; bamsx - Frontend para o emulador fMSX
; Linguagem e ambiente utilizados neste projeto:
;   - PureBasic 6.40
;   - Windows 11 64 bits
;   - PowerShell 7.7
;   - Visual Studio Code
;   - SQLite 3
;
; Compilacao via pbcompiler.exe (ajuste o caminho do compilador se necessario):
;   pbcompiler.exe "E:\bamsx\main.pb" /EXE "E:\bamsx\bamsx.exe"
; Exemplo com caminho absoluto tipico:
;   "C:\Program Files\PureBasic\Compilers\pbcompiler.exe" "E:\bamsx\main.pb" /EXE "E:\bamsx\bamsx.exe"
;
; O programa abre uma interface grafica para configurar o fMSX, persiste as
; preferencias em SQLite e monta a linha de comando final antes de executar o
; emulador com os arquivos e opcoes escolhidos pelo usuario.
; ============================================================================

EnableExplicit

UseSQLiteDatabase()

; Identificadores numericos usados para janelas da aplicacao.
Enumeration
#Window_Main
#Window_Setup
#Window_CLI
#Window_Keys
#Window_About
EndEnumeration

; Identificadores numericos usados pelo menu principal.
Enumeration
#Menu_File_Exit = 100
#Menu_Tools_Setup
#Menu_Help_CLI
#Menu_Help_Keys
#Menu_Help_About
EndEnumeration

; Identificadores numericos dos gadgets da janela de configuracao e da janela principal.
Enumeration
#Gadget_Setup_PathLabel = 200
#Gadget_Setup_PathInput
#Gadget_Setup_Browse
#Gadget_Setup_ModeLabel
#Gadget_Setup_ModeCombo
#Gadget_Setup_ThemeLabel
#Gadget_Setup_ThemeCombo
#Gadget_Setup_VideoLabel
#Gadget_Setup_VideoCombo
#Gadget_Setup_MonoLabel
#Gadget_Setup_MonoCombo
#Gadget_Setup_ScaleLabel
#Gadget_Setup_ScaleCombo
#Gadget_Setup_AutoLabel
#Gadget_Setup_AutoCombo
#Gadget_Setup_RAMLabel
#Gadget_Setup_RAMCombo
#Gadget_Setup_VRAMLabel
#Gadget_Setup_VRAMCombo
#Gadget_Setup_ROM1Label
#Gadget_Setup_ROM1Combo
#Gadget_Setup_ROM2Label
#Gadget_Setup_ROM2Combo
#Gadget_Setup_Joy1Label
#Gadget_Setup_Joy1Combo
#Gadget_Setup_Joy2Label
#Gadget_Setup_Joy2Combo
#Gadget_Setup_DiskLabel
#Gadget_Setup_DiskCombo
#Gadget_Setup_SoundLabel
#Gadget_Setup_SoundCombo
#Gadget_Setup_VerboseLabel
#Gadget_Setup_VerboseCombo
#Gadget_Setup_SkipLabel
#Gadget_Setup_SkipCombo
#Gadget_Setup_PrinterLabel
#Gadget_Setup_PrinterInput
#Gadget_Setup_PrinterBrowse
#Gadget_Setup_PrinterCreate
#Gadget_Setup_SerialLabel
#Gadget_Setup_SerialInput
#Gadget_Setup_SerialBrowse
#Gadget_Setup_SerialCreate
#Gadget_Setup_DiskALabel
#Gadget_Setup_DiskAInput
#Gadget_Setup_DiskABrowse
#Gadget_Setup_DiskACreate
#Gadget_Setup_DiskBLabel
#Gadget_Setup_DiskBInput
#Gadget_Setup_DiskBBrowse
#Gadget_Setup_DiskBCreate
#Gadget_Setup_TapeLabel
#Gadget_Setup_TapeInput
#Gadget_Setup_TapeBrowse
#Gadget_Setup_TapeCreate
#Gadget_Setup_FontLabel
#Gadget_Setup_FontInput
#Gadget_Setup_FontBrowse
#Gadget_Setup_FontCreate
#Gadget_Setup_LogSndLabel
#Gadget_Setup_LogSndInput
#Gadget_Setup_LogSndBrowse
#Gadget_Setup_LogSndCreate
#Gadget_Setup_StateLabel
#Gadget_Setup_StateInput
#Gadget_Setup_StateBrowse
#Gadget_Setup_StateCreate
#Gadget_Setup_Save
#Gadget_Setup_Cancel
#Gadget_Main_Run = 300
#Gadget_Main_HeroPanel
#Gadget_Main_Title
#Gadget_Main_Subtitle
#Gadget_Main_ThemeBadge
#Gadget_Main_ThemeValue
#Gadget_Main_FontBadge
#Gadget_Main_FontValue
#Gadget_Main_Hint
#Gadget_Keys_Title
#Gadget_Keys_Subtitle
#Gadget_Keys_FilterLabel
#Gadget_Keys_FilterCombo
#Gadget_Keys_SearchLabel
#Gadget_Keys_SearchInput
#Gadget_Keys_Scroll
#Gadget_Keys_Canvas
#Gadget_Keys_Copy
#Gadget_Keys_Close
#Gadget_CLI_Title
#Gadget_CLI_Subtitle
#Gadget_CLI_FilterLabel
#Gadget_CLI_FilterCombo
#Gadget_CLI_SearchLabel
#Gadget_CLI_SearchInput
#Gadget_CLI_Scroll
#Gadget_CLI_Canvas
#Gadget_CLI_Copy
#Gadget_CLI_Close
#Gadget_About_Title
#Gadget_About_Subtitle
#Gadget_About_Scroll
#Gadget_About_Canvas
#Gadget_About_Close
#StatusBar_Main = 400
    #Gadget_Setup_4x3 = 500
EndEnumeration

; Estado global da configuracao do frontend. Cada grupo abaixo representa um
; conjunto de opcoes do fMSX e o argumento de linha de comando correspondente.
Global gFMSXPath.s
Global gFMSXMachineMode.s = "MSX"
Global gFMSXMachineArg.s = ""
Global gFMSXVideoStandard.s = "PAL"
Global gFMSXVideoArg.s = ""
Global gFMSXMonitorType.s = ""
Global gFMSXMonitorArg.s = ""
Global gFMSXForce4x3.i = 0
Global gFMSXForce4x3Arg.s = ""
Global gFMSXScaleFilter.s = ""
Global gFMSXScaleFilterArg.s = ""
Global gFMSXAutoFire.i = 0
Global gFMSXAutoFireArg.s = " -noauto"
Global gFMSXRamPages.i = 4
Global gFMSXRamArg.s = " -ram 4"
Global gFMSXVRamPages.i = 2
Global gFMSXVRamArg.s = " -vram 2"
Global gFMSXRomType1.i = -1
Global gFMSXRomType2.i = -1
Global gFMSXRomArg.s = ""
Global gFMSXJoyType1.i = 0
Global gFMSXJoyType2.i = 0
Global gFMSXJoyArg.s = " -joy 0 -joy 0"
Global gFMSXDiskMode.s = "WD1793"
Global gFMSXDiskArg.s = " -wd1793"
Global gFMSXSoundQuality.i = 44100
Global gFMSXSoundArg.s = " -sound 44100"
Global gFMSXVerboseLevel.i = 1
Global gFMSXVerboseArg.s = " -verbose 1"
Global gFMSXSkipPercent.i = 25
Global gFMSXSkipArg.s = " -skip 25"
Global gFMSXPrinterFile.s = ""
Global gFMSXPrinterArg.s = ""
Global gFMSXSerialFile.s = ""
Global gFMSXSerialArg.s = ""
Global gFMSXDiskAFiles.s = ""
Global gFMSXDiskAArg.s = ""
Global gFMSXDiskBFiles.s = ""
Global gFMSXDiskBArg.s = ""
Global gFMSXTapeFile.s = ""
Global gFMSXTapeArg.s = ""
Global gFMSXFontFile.s = ""
Global gFMSXFontArg.s = ""
Global gFMSXLogSndFile.s = ""
Global gFMSXLogSndArg.s = ""
Global gFMSXStateFile.s = ""
Global gFMSXStateArg.s = ""

#App_Name = "bamsx"
#App_Version = "0.1.5"
#App_Build = "0x6A0D0A96"
#App_CreationYear = "2026"
#App_Programmer = "Wilson 'Barney' Pilon"
#App_Company = "Cybernostra, Inc."
#App_Division = "WIB Projetos Ltda"
#App_Copyright = "(C)1972"
#Timer_KeysHover = 1
#About_CardCount = 10
#FR_PRIVATE = $10
Global gThemeName.s = "VS Code Dark+"

Global gThemeWindowBack.i
Global gThemePanelBack.i
Global gThemeInputBack.i
Global gThemeInputFront.i
Global gThemeText.i
Global gThemeMutedText.i
Global gThemeAccent.i
Global gThemeAccentText.i
Global gThemeBorder.i

Global gUIFontNormal.i
Global gUIFontTitle.i
Global gUIFontCaption.i
Global gUIFontMono.i
Global gUIFontSourceReady.i
Global gUIFontSourcePath.s
Global gUIFontRuntimeSource.s = "Not initialized"

Structure KeyShortcut
    keyA.s
    keyB.s
    description.s
    category.s
EndStructure

Structure CLIOption
    option.s
    description.s
    category.s
EndStructure

Global NewList gKeyShortcuts.KeyShortcut()
Global NewList gCLIOptions.CLIOption()
Global gKeysFilterCategory.s = "All"
Global gKeysSearchText.s = ""
Global gKeysHoverIndex.i = -1
Global gKeysSelectedIndex.i = -1
Global gCLIFilterCategory.s = "All"
Global gCLISearchText.s = ""
Global gCLIHoverIndex.i = -1
Global gCLISelectedIndex.i = -1
Global gAboutHoverIndex.i = -1
Global gKeysVisibleCount.i
Global gCLIVisibleCount.i
Global Dim gKeysVisibleIndex.i(255)
Global Dim gKeysCardGlow.f(255)
Global Dim gCLIVisibleIndex.i(511)

Import "gdi32.lib"
    AddFontResourceExW(lpszFilename.p-unicode, fl.i, pdv.i)
    RemoveFontResourceExW(lpszFilename.p-unicode, fl.i, pdv.i)
EndImport

Declare ApplyThemeToCLIWindow()

Procedure.s ResolveSourceCodeProFontPath()
    Protected basePath.s
    Protected candidate.s

    basePath = GetPathPart(ProgramFilename())
    candidate = basePath + "fonts\\static\\SourceCodePro-Bold.ttf"
    If FileSize(candidate) <> -1
        ProcedureReturn candidate
    EndIf

    basePath = GetPathPart(#PB_Compiler_File)
    candidate = basePath + "fonts\\static\\SourceCodePro-Bold.ttf"
    If FileSize(candidate) <> -1
        ProcedureReturn candidate
    EndIf

    basePath = GetCurrentDirectory()
    candidate = basePath + "fonts\\static\\SourceCodePro-Bold.ttf"
    If FileSize(candidate) <> -1
        ProcedureReturn candidate
    EndIf

    ProcedureReturn ""
EndProcedure

Procedure EnsureSourceCodeProFont()
    If gUIFontSourceReady
        ProcedureReturn
    EndIf

    gUIFontSourcePath = ResolveSourceCodeProFontPath()
    If gUIFontSourcePath <> ""
        ; Registra a fonte apenas para este processo, sem instalar no Windows.
        If AddFontResourceExW(gUIFontSourcePath, #FR_PRIVATE, 0)
            gUIFontSourceReady = #True
        EndIf
    EndIf
EndProcedure

Procedure EnsureUIFont()
    EnsureSourceCodeProFont()

    If gUIFontNormal = 0
        gUIFontNormal = LoadFont(#PB_Any, "Source Code Pro", 10, #PB_Font_Bold)
        If gUIFontNormal = 0
            gUIFontNormal = LoadFont(#PB_Any, "SourceCodePro", 10, #PB_Font_Bold)
        EndIf
        If gUIFontNormal = 0
            gUIFontNormal = LoadFont(#PB_Any, "Segoe UI", 10)
            gUIFontRuntimeSource = "Fallback (Segoe UI)"
        Else
            If gUIFontSourceReady And gUIFontSourcePath <> ""
                gUIFontRuntimeSource = "Source Code Pro local (" + gUIFontSourcePath + ")"
            Else
                gUIFontRuntimeSource = "Source Code Pro installed on Windows"
            EndIf
        EndIf
    EndIf
    If gUIFontTitle = 0
        gUIFontTitle = LoadFont(#PB_Any, "Source Code Pro", 22, #PB_Font_Bold)
        If gUIFontTitle = 0
            gUIFontTitle = LoadFont(#PB_Any, "SourceCodePro", 22, #PB_Font_Bold)
        EndIf
        If gUIFontTitle = 0
            gUIFontTitle = LoadFont(#PB_Any, "Segoe UI", 22, #PB_Font_Bold)
        EndIf
    EndIf
    If gUIFontCaption = 0
        gUIFontCaption = LoadFont(#PB_Any, "Source Code Pro", 9, #PB_Font_Bold)
        If gUIFontCaption = 0
            gUIFontCaption = LoadFont(#PB_Any, "SourceCodePro", 9, #PB_Font_Bold)
        EndIf
        If gUIFontCaption = 0
            gUIFontCaption = LoadFont(#PB_Any, "Segoe UI", 9)
        EndIf
    EndIf
    If gUIFontMono = 0
        gUIFontMono = LoadFont(#PB_Any, "Source Code Pro", 10, #PB_Font_Bold)
        If gUIFontMono = 0
            gUIFontMono = LoadFont(#PB_Any, "SourceCodePro", 10, #PB_Font_Bold)
        EndIf
        If gUIFontMono = 0
            gUIFontMono = LoadFont(#PB_Any, "Consolas", 10)
        EndIf
    EndIf
EndProcedure

Procedure ApplyFontToAllGadgets(defaultFontID.i)
    Protected gadgetID.i

    ; Aplica a fonte padrao em toda a faixa de IDs usada pelo projeto.
    For gadgetID = 200 To 600
        If IsGadget(gadgetID)
            SetGadgetFont(gadgetID, defaultFontID)
        EndIf
    Next

    ; Gadgets da janela principal com hierarquia visual.
    If IsGadget(#Gadget_Main_Title)
        SetGadgetFont(#Gadget_Main_Title, FontID(gUIFontTitle))
    EndIf
    If IsGadget(#Gadget_Main_Subtitle)
        SetGadgetFont(#Gadget_Main_Subtitle, FontID(gUIFontNormal))
    EndIf
EndProcedure

Procedure.s GetRuntimeFontSourceCompact()
    If FindString(gUIFontRuntimeSource, "Source Code Pro local", 1)
        If gUIFontSourcePath <> ""
            ProcedureReturn "Source Code Pro local (" + GetFilePart(gUIFontSourcePath) + ")"
        EndIf
        ProcedureReturn "Source Code Pro local"
    EndIf

    If FindString(gUIFontRuntimeSource, "installed", 1)
        ProcedureReturn "Source Code Pro installed"
    EndIf

    If FindString(gUIFontRuntimeSource, "Fallback", 1)
        ProcedureReturn "Fallback (Segoe UI)"
    EndIf

    ProcedureReturn gUIFontRuntimeSource
EndProcedure

Procedure.s GetAboutCardTitle(index.i)
    Select index
        Case 0 : ProcedureReturn "Application"
        Case 1 : ProcedureReturn "Description"
        Case 2 : ProcedureReturn "Creation year"
        Case 3 : ProcedureReturn "Version"
        Case 4 : ProcedureReturn "Build"
        Case 5 : ProcedureReturn "Runtime font"
        Case 6 : ProcedureReturn "Programmer"
        Case 7 : ProcedureReturn "Company"
        Case 8 : ProcedureReturn "Division"
        Case 9 : ProcedureReturn "Copyright"
    EndSelect
    ProcedureReturn "Info"
EndProcedure

Procedure.s GetAboutCardValue(index.i)
    Select index
        Case 0 : ProcedureReturn #App_Name
        Case 1 : ProcedureReturn "Desktop frontend for fMSX"
        Case 2 : ProcedureReturn #App_CreationYear
        Case 3 : ProcedureReturn #App_Version
        Case 4 : ProcedureReturn #App_Build
        Case 5 : ProcedureReturn GetRuntimeFontSourceCompact()
        Case 6 : ProcedureReturn #App_Programmer
        Case 7 : ProcedureReturn #App_Company
        Case 8 : ProcedureReturn #App_Division
        Case 9 : ProcedureReturn #App_Copyright
    EndSelect
    ProcedureReturn ""
EndProcedure

Procedure.i BlendColor(baseColor.i, targetColor.i, ratio.f)
    Protected rr.i
    Protected gg.i
    Protected bb.i

    If ratio < 0.0
        ratio = 0.0
    EndIf
    If ratio > 1.0
        ratio = 1.0
    EndIf

    rr = Red(baseColor) + Int((Red(targetColor) - Red(baseColor)) * ratio)
    gg = Green(baseColor) + Int((Green(targetColor) - Green(baseColor)) * ratio)
    bb = Blue(baseColor) + Int((Blue(targetColor) - Blue(baseColor)) * ratio)
    ProcedureReturn RGB(rr, gg, bb)
EndProcedure

Procedure.i CalculateAboutCanvasHeight(canvasWidth.i)
    Protected cardHeight.i = 96
    Protected gap.i = 16
    Protected cardsPerRow.i = 1
    Protected rows.i

    If canvasWidth >= 760
        cardsPerRow = 2
    EndIf

    rows = (#About_CardCount + cardsPerRow - 1) / cardsPerRow
    ProcedureReturn 18 + rows * (cardHeight + gap)
EndProcedure

Procedure.i GetAboutCardAtCanvasPosition(mouseX.i, mouseY.i)
    Protected canvasWidth.i
    Protected cardsPerRow.i = 1
    Protected cardGap.i = 16
    Protected cardWidth.i
    Protected cardHeight.i = 96
    Protected margin.i = 14
    Protected col.i
    Protected row.i
    Protected localX.i
    Protected localY.i
    Protected slot.i

    If Not IsGadget(#Gadget_About_Canvas)
        ProcedureReturn -1
    EndIf

    canvasWidth = GadgetWidth(#Gadget_About_Canvas)
    If canvasWidth >= 760
        cardsPerRow = 2
    EndIf
    cardWidth = (canvasWidth - (margin * 2) - (cardGap * (cardsPerRow - 1))) / cardsPerRow

    If mouseX < margin Or mouseY < 18
        ProcedureReturn -1
    EndIf

    col = Int((mouseX - margin) / (cardWidth + cardGap))
    row = Int((mouseY - 18) / (cardHeight + cardGap))
    If col < 0 Or col >= cardsPerRow
        ProcedureReturn -1
    EndIf

    localX = (mouseX - margin) % (cardWidth + cardGap)
    localY = (mouseY - 18) % (cardHeight + cardGap)
    If localX >= cardWidth Or localY >= cardHeight
        ProcedureReturn -1
    EndIf

    slot = row * cardsPerRow + col
    If slot < 0 Or slot >= #About_CardCount
        ProcedureReturn -1
    EndIf

    ProcedureReturn slot
EndProcedure

Procedure DrawAboutCards()
    Protected canvasWidth.i
    Protected canvasHeight.i
    Protected cardsPerRow.i = 1
    Protected cardGap.i = 16
    Protected cardWidth.i
    Protected cardHeight.i = 96
    Protected margin.i = 14
    Protected slot.i
    Protected x.i
    Protected y.i
    Protected cardBack.i
    Protected cardTop.i
    Protected cardBorder.i

    If Not IsGadget(#Gadget_About_Canvas)
        ProcedureReturn
    EndIf

    EnsureUIFont()
    canvasWidth = GadgetWidth(#Gadget_About_Canvas)
    canvasHeight = GadgetHeight(#Gadget_About_Canvas)
    If canvasWidth >= 760
        cardsPerRow = 2
    EndIf
    cardWidth = (canvasWidth - (margin * 2) - (cardGap * (cardsPerRow - 1))) / cardsPerRow

    If StartDrawing(CanvasOutput(#Gadget_About_Canvas))
        Box(0, 0, canvasWidth, canvasHeight, gThemeInputBack)

        For slot = 0 To #About_CardCount - 1
            x = margin + (slot % cardsPerRow) * (cardWidth + cardGap)
            y = 18 + (slot / cardsPerRow) * (cardHeight + cardGap)
            If slot = gAboutHoverIndex
                cardBack = BlendColor(gThemePanelBack, gThemeAccent, 0.18)
                cardTop = BlendColor(gThemeAccent, gThemeAccentText, 0.10)
                cardBorder = BlendColor(gThemeBorder, gThemeAccent, 0.40)
            Else
                cardBack = gThemePanelBack
                cardTop = gThemeAccent
                cardBorder = gThemeBorder
            EndIf

            Box(x, y, cardWidth, cardHeight, cardBack)
            Box(x, y, cardWidth, 3, cardTop)
            Box(x, y + cardHeight - 1, cardWidth, 1, cardBorder)
            Box(x, y, 1, cardHeight, cardBorder)
            Box(x + cardWidth - 1, y, 1, cardHeight, cardBorder)

            DrawingMode(#PB_2DDrawing_Transparent)
            DrawingFont(FontID(gUIFontCaption))
            DrawText(x + 14, y + 12, GetAboutCardTitle(slot), gThemeMutedText, cardBack)
            DrawingFont(FontID(gUIFontNormal))
            DrawText(x + 14, y + 44, GetAboutCardValue(slot), gThemeText, cardBack)
            If slot = gAboutHoverIndex
                DrawingFont(FontID(gUIFontCaption))
                DrawText(x + 14, y + 74, "Click to copy", gThemeAccent, cardBack)
            EndIf
        Next

        StopDrawing()
    EndIf
EndProcedure

Procedure ResizeAboutCanvas()
    Protected canvasWidth.i
    Protected canvasHeight.i

    If Not IsGadget(#Gadget_About_Scroll) Or Not IsGadget(#Gadget_About_Canvas)
        ProcedureReturn
    EndIf

    canvasWidth = GadgetWidth(#Gadget_About_Scroll) - 16
    If canvasWidth < 360
        canvasWidth = 360
    EndIf
    canvasHeight = CalculateAboutCanvasHeight(canvasWidth)

    SetGadgetAttribute(#Gadget_About_Scroll, #PB_ScrollArea_InnerWidth, canvasWidth)
    SetGadgetAttribute(#Gadget_About_Scroll, #PB_ScrollArea_InnerHeight, canvasHeight)
    ResizeGadget(#Gadget_About_Canvas, 0, 0, canvasWidth, canvasHeight)
    DrawAboutCards()
EndProcedure

Procedure.s NormalizeKeysCategory(category.s)
    category = UCase(Trim(category))
    Select category
        Case "ALL", "TODAS"
            ProcedureReturn "All"
        Case "SYSTEM", "SISTEMA"
            ProcedureReturn "System"
        Case "STATE", "ESTADO"
            ProcedureReturn "State"
        Case "VIDEO"
            ProcedureReturn "Video"
        Case "DEBUG"
            ProcedureReturn "Debug"
    EndSelect

    ProcedureReturn "System"
EndProcedure

Procedure AddKeyShortcut(keyA.s, description.s, keyB.s = "", category.s = "System")
    AddElement(gKeyShortcuts())
    gKeyShortcuts()\keyA = keyA
    gKeyShortcuts()\keyB = keyB
    gKeyShortcuts()\description = description
    gKeyShortcuts()\category = NormalizeKeysCategory(category)
EndProcedure

Procedure InitKeyShortcuts()
    If ListSize(gKeyShortcuts()) > 0
        ProcedureReturn
    EndIf

    AddKeyShortcut("CONTROL", "CONTROL (also: joystick FIRE-A)", "", "System")
    AddKeyShortcut("SHIFT", "SHIFT (also: joystick FIRE-B)", "", "System")
    AddKeyShortcut("ALT", "GRAPH (also: swaps joysticks)", "", "System")
    AddKeyShortcut("INSERT", "INSERT", "", "System")
    AddKeyShortcut("DELETE", "DELETE", "", "System")
    AddKeyShortcut("HOME", "HOME/CLS", "", "System")
    AddKeyShortcut("END", "SELECT", "", "System")
    AddKeyShortcut("PGUP", "STOP/BREAK", "", "System")
    AddKeyShortcut("PGDOWN", "COUNTRY", "", "System")
    AddKeyShortcut("F6", "Load emulation state from .STA file", "", "State")
    AddKeyShortcut("F7", "Save emulation state to .STA file", "", "State")
    AddKeyShortcut("F8", "Rewind emulation back in time", "", "State")
    AddKeyShortcut("F9", "Fast-forward emulation", "", "State")
    AddKeyShortcut("F10", "Invoke built-in configuration menu", "", "System")
    AddKeyShortcut("F11", "Reset hardware", "", "System")
    AddKeyShortcut("F12", "Quit emulation", "", "System")
    AddKeyShortcut("CONTROL", "Toggle scanlines on/off", "F8", "Video")
    AddKeyShortcut("ALT", "Toggle screen softening on/off", "F8", "Video")
    AddKeyShortcut("CONTROL", "Go to the built-in debugger", "F10", "Debug")
EndProcedure

Procedure PopulateKeysCategoryCombo(gadgetID.i)
    If Not IsGadget(gadgetID)
        ProcedureReturn
    EndIf

    AddGadgetItem(gadgetID, -1, "All")
    AddGadgetItem(gadgetID, -1, "System")
    AddGadgetItem(gadgetID, -1, "State")
    AddGadgetItem(gadgetID, -1, "Video")
    AddGadgetItem(gadgetID, -1, "Debug")
EndProcedure

Procedure.i GetKeysCategoryComboIndex(category.s)
    Select NormalizeKeysCategory(category)
        Case "All"
            ProcedureReturn 0
        Case "System"
            ProcedureReturn 1
        Case "State"
            ProcedureReturn 2
        Case "Video"
            ProcedureReturn 3
        Case "Debug"
            ProcedureReturn 4
    EndSelect
    ProcedureReturn 0
EndProcedure

Procedure.s NormalizeSearchText(text.s)
    ProcedureReturn LCase(Trim(text))
EndProcedure

Procedure.i ShortcutMatchesSearch(keyA.s, keyB.s, description.s, searchText.s)
    If searchText = ""
        ProcedureReturn #True
    EndIf

    keyA = LCase(keyA)
    keyB = LCase(keyB)
    description = LCase(description)

    If FindString(keyA, searchText, 1) > 0
        ProcedureReturn #True
    EndIf
    If FindString(keyB, searchText, 1) > 0
        ProcedureReturn #True
    EndIf
    If FindString(description, searchText, 1) > 0
        ProcedureReturn #True
    EndIf

    ProcedureReturn #False
EndProcedure

Procedure RebuildVisibleKeyShortcuts()
    Protected idx.i
    Protected normalizedSearch.s

    normalizedSearch = NormalizeSearchText(gKeysSearchText)

    gKeysVisibleCount = 0
    ForEach gKeyShortcuts()
        idx = ListIndex(gKeyShortcuts())
        If (gKeysFilterCategory = "All" Or gKeyShortcuts()\category = gKeysFilterCategory) And ShortcutMatchesSearch(gKeyShortcuts()\keyA, gKeyShortcuts()\keyB, gKeyShortcuts()\description, normalizedSearch)
            If gKeysVisibleCount <= ArraySize(gKeysVisibleIndex())
                gKeysVisibleIndex(gKeysVisibleCount) = idx
                gKeysVisibleCount + 1
            EndIf
        EndIf
    Next

    If gKeysSelectedIndex >= 0
        ResetList(gKeyShortcuts())
        If SelectElement(gKeyShortcuts(), gKeysSelectedIndex) = 0
            gKeysSelectedIndex = -1
        ElseIf gKeysFilterCategory <> "All" And gKeyShortcuts()\category <> gKeysFilterCategory
            gKeysSelectedIndex = -1
        EndIf
    EndIf

    If gKeysHoverIndex >= 0
        ResetList(gKeyShortcuts())
        If SelectElement(gKeyShortcuts(), gKeysHoverIndex) = 0
            gKeysHoverIndex = -1
        ElseIf gKeysFilterCategory <> "All" And gKeyShortcuts()\category <> gKeysFilterCategory
            gKeysHoverIndex = -1
        EndIf
    EndIf
EndProcedure

Procedure.i CalculateKeysCanvasHeight(canvasWidth.i)
    Protected cardHeight.i = 108
    Protected gap.i = 16
    Protected cardsPerRow.i
    Protected rows.i

    cardsPerRow = 1
    If canvasWidth >= 760
        cardsPerRow = 2
    EndIf

    rows = (gKeysVisibleCount + cardsPerRow - 1) / cardsPerRow
    If rows < 1
        rows = 1
    EndIf
    ProcedureReturn 18 + rows * (cardHeight + gap)
EndProcedure

Procedure DrawKeyCap(x.i, y.i, w.i, h.i, caption.s)
    Protected tx.i
    Protected ty.i

    Box(x, y, w, h, gThemeWindowBack)
    Box(x + 1, y + 1, w - 2, h - 2, gThemePanelBack)
    Box(x + 1, y + h - 6, w - 2, 5, gThemeBorder)

    tx = x + (w - TextWidth(caption)) / 2
    ty = y + (h - TextHeight(caption)) / 2 - 1
    DrawText(tx, ty, caption, gThemeText, gThemePanelBack)
EndProcedure

Procedure DrawKeysCards()
    Protected canvasWidth.i
    Protected canvasHeight.i
    Protected cardsPerRow.i
    Protected cardGap.i = 16
    Protected cardWidth.i
    Protected cardHeight.i = 108
    Protected margin.i = 14
    Protected x.i
    Protected y.i
    Protected visibleSlot.i
    Protected itemIndex.i
    Protected combo.i
    Protected keyW.i
    Protected keyH.i = 34
    Protected cardBack.i
    Protected cardTop.i
    Protected cardBorder.i

    If Not IsGadget(#Gadget_Keys_Canvas)
        ProcedureReturn
    EndIf

    EnsureUIFont()
    InitKeyShortcuts()

    canvasWidth = GadgetWidth(#Gadget_Keys_Canvas)
    canvasHeight = GadgetHeight(#Gadget_Keys_Canvas)
    cardsPerRow = 1
    If canvasWidth >= 760
        cardsPerRow = 2
    EndIf
    cardWidth = (canvasWidth - (margin * 2) - (cardGap * (cardsPerRow - 1))) / cardsPerRow

    If StartDrawing(CanvasOutput(#Gadget_Keys_Canvas))
        Box(0, 0, canvasWidth, canvasHeight, gThemeInputBack)
        DrawingMode(#PB_2DDrawing_Transparent)

        For visibleSlot = 0 To gKeysVisibleCount - 1
            itemIndex = gKeysVisibleIndex(visibleSlot)
            If SelectElement(gKeyShortcuts(), itemIndex)
                x = margin + (visibleSlot % cardsPerRow) * (cardWidth + cardGap)
                y = 18 + (visibleSlot / cardsPerRow) * (cardHeight + cardGap)

                cardBack = BlendColor(gThemePanelBack, gThemeAccent, gKeysCardGlow(itemIndex) * 0.20)
                If itemIndex = gKeysSelectedIndex
                    cardBack = BlendColor(cardBack, gThemeAccent, 0.28)
                EndIf
                cardTop = BlendColor(gThemeAccent, gThemeAccentText, gKeysCardGlow(itemIndex) * 0.12)
                cardBorder = BlendColor(gThemeBorder, gThemeAccent, gKeysCardGlow(itemIndex) * 0.30)

                Box(x, y, cardWidth, cardHeight, cardBack)
                Box(x, y, cardWidth, 3, cardTop)
                Box(x, y + cardHeight - 1, cardWidth, 1, cardBorder)
                Box(x, y, 1, cardHeight, cardBorder)
                Box(x + cardWidth - 1, y, 1, cardHeight, cardBorder)

                DrawingFont(FontID(gUIFontCaption))
                DrawText(x + 14, y + 10, "[" + gKeyShortcuts()\category + "] " + gKeyShortcuts()\description, gThemeMutedText, cardBack)

                combo = Bool(gKeyShortcuts()\keyB <> "")
                DrawingFont(FontID(gUIFontNormal))
                If combo
                    keyW = (cardWidth - 60) / 2
                    DrawKeyCap(x + 14, y + 44, keyW, keyH, gKeyShortcuts()\keyA)
                    DrawText(x + 14 + keyW + 10, y + 52, "+", gThemeMutedText, cardBack)
                    DrawKeyCap(x + 14 + keyW + 24, y + 44, keyW, keyH, gKeyShortcuts()\keyB)
                Else
                    keyW = 150
                    If keyW > cardWidth - 28
                        keyW = cardWidth - 28
                    EndIf
                    DrawKeyCap(x + 14, y + 44, keyW, keyH, gKeyShortcuts()\keyA)
                EndIf
            EndIf
        Next

        StopDrawing()
    EndIf
EndProcedure

Procedure.i GetKeyShortcutAtCanvasPosition(mouseX.i, mouseY.i)
    Protected canvasWidth.i
    Protected cardsPerRow.i
    Protected cardGap.i = 16
    Protected cardWidth.i
    Protected cardHeight.i = 108
    Protected margin.i = 14
    Protected col.i
    Protected row.i
    Protected localX.i
    Protected localY.i
    Protected slot.i

    If gKeysVisibleCount <= 0
        ProcedureReturn -1
    EndIf

    canvasWidth = GadgetWidth(#Gadget_Keys_Canvas)
    cardsPerRow = 1
    If canvasWidth >= 760
        cardsPerRow = 2
    EndIf
    cardWidth = (canvasWidth - (margin * 2) - (cardGap * (cardsPerRow - 1))) / cardsPerRow

    If mouseX < margin Or mouseY < 18
        ProcedureReturn -1
    EndIf

    col = Int((mouseX - margin) / (cardWidth + cardGap))
    row = Int((mouseY - 18) / (cardHeight + cardGap))
    If col < 0 Or col >= cardsPerRow
        ProcedureReturn -1
    EndIf

    localX = (mouseX - margin) % (cardWidth + cardGap)
    localY = (mouseY - 18) % (cardHeight + cardGap)
    If localX >= cardWidth Or localY >= cardHeight
        ProcedureReturn -1
    EndIf

    slot = row * cardsPerRow + col
    If slot < 0 Or slot >= gKeysVisibleCount
        ProcedureReturn -1
    EndIf

    ProcedureReturn gKeysVisibleIndex(slot)
EndProcedure

Procedure.s GetShortcutDisplayText(shortcutIndex.i)
    If SelectElement(gKeyShortcuts(), shortcutIndex) = 0
        ProcedureReturn ""
    EndIf

    If gKeyShortcuts()\keyB = ""
        ProcedureReturn "[" + gKeyShortcuts()\keyA + "] - " + gKeyShortcuts()\description
    EndIf
    ProcedureReturn "[" + gKeyShortcuts()\keyA + "]+[" + gKeyShortcuts()\keyB + "] - " + gKeyShortcuts()\description
EndProcedure

Procedure CopySelectedShortcut()
    Protected text.s

    If gKeysSelectedIndex < 0
        MessageRequester("Keys", "Select a card before copying.")
        ProcedureReturn
    EndIf

    text = GetShortcutDisplayText(gKeysSelectedIndex)
    If text = ""
        MessageRequester("Keys", "Invalid shortcut for copy.")
        ProcedureReturn
    EndIf

    SetClipboardText(text)
    MessageRequester("Keys", "Shortcut copied to clipboard:" + Chr(10) + Chr(10) + text)
EndProcedure

Procedure ResizeKeysCanvas()
    Protected canvasWidth.i
    Protected canvasHeight.i

    If Not IsGadget(#Gadget_Keys_Scroll) Or Not IsGadget(#Gadget_Keys_Canvas)
        ProcedureReturn
    EndIf

    canvasWidth = GadgetWidth(#Gadget_Keys_Scroll) - 16
    If canvasWidth < 360
        canvasWidth = 360
    EndIf
    canvasHeight = CalculateKeysCanvasHeight(canvasWidth)

    SetGadgetAttribute(#Gadget_Keys_Scroll, #PB_ScrollArea_InnerWidth, canvasWidth)
    SetGadgetAttribute(#Gadget_Keys_Scroll, #PB_ScrollArea_InnerHeight, canvasHeight)
    ResizeGadget(#Gadget_Keys_Canvas, 0, 0, canvasWidth, canvasHeight)
    DrawKeysCards()
EndProcedure

Procedure UpdateKeysHoverAnimation()
    Protected i.i
    Protected target.f
    Protected delta.f
    Protected changed.i

    For i = 0 To ListSize(gKeyShortcuts()) - 1
        target = 0.0
        If i = gKeysHoverIndex
            target = 1.0
        ElseIf i = gKeysSelectedIndex
            target = 0.35
        EndIf

        delta = target - gKeysCardGlow(i)
        If Abs(delta) > 0.01
            gKeysCardGlow(i) + delta * 0.22
            changed = #True
        ElseIf gKeysCardGlow(i) <> target
            gKeysCardGlow(i) = target
            changed = #True
        EndIf
    Next

    If changed
        DrawKeysCards()
    EndIf
EndProcedure

Procedure.s NormalizeCLICategory(category.s)
    category = UCase(Trim(category))
    Select category
        Case "ALL"
            ProcedureReturn "All"
        Case "GENERAL"
            ProcedureReturn "General"
        Case "FILES"
            ProcedureReturn "Files"
        Case "EMULATION"
            ProcedureReturn "Emulation"
        Case "VIDEO"
            ProcedureReturn "Video"
        Case "DEBUG"
            ProcedureReturn "Debug"
        Case "PLATFORM"
            ProcedureReturn "Platform"
    EndSelect

    ProcedureReturn "General"
EndProcedure

Procedure AddCLIOption(option.s, description.s, category.s = "General")
    AddElement(gCLIOptions())
    gCLIOptions()\option = option
    gCLIOptions()\description = description
    gCLIOptions()\category = NormalizeCLICategory(category)
EndProcedure

Procedure InitCLIOptions()
    If ListSize(gCLIOptions()) > 0
        ProcedureReturn
    EndIf

    AddCLIOption("Usage", "fmsx [-option1 [-option2...]] [filename1] [filename2]", "General")
    AddCLIOption("filename1", "File loaded as cartridge A.", "Files")
    AddCLIOption("filename2", "File loaded as cartridge B.", "Files")
    AddCLIOption("#define ZLIB", "Supports transparent GZIP/PKZIP decompression for singular files.", "Platform")

    AddCLIOption("-verbose <level>", "Debug levels: 0 silent, 1 startup, 2 V9938, 4 disk/tape, 8 memory, 16 illegal Z80.", "Debug")
    AddCLIOption("-skip <percent>", "Percentage of frames to skip [25].", "Video")
    AddCLIOption("-pal / -ntsc", "Set PAL/NTSC HBlank/VBlank periods [NTSC].", "Video")
    AddCLIOption("-help", "Print the original help page.", "General")
    AddCLIOption("-home <dirname>", "Set directory containing system ROM files.", "Files")
    AddCLIOption("-printer <filename>", "Redirect printer output to file [stdout].", "Files")
    AddCLIOption("-serial <filename>", "Redirect serial I/O to file [stdin/stdout].", "Files")
    AddCLIOption("-diska <filename>", "Set drive A disk image (multiple options accepted).", "Files")
    AddCLIOption("-diskb <filename>", "Set drive B disk image (multiple options accepted).", "Files")
    AddCLIOption("-tape <filename>", "Set tape image file.", "Files")
    AddCLIOption("-font <filename>", "Set fixed font for text modes.", "Files")
    AddCLIOption("-logsnd <filename>", "Set soundtrack log file [LOG.MID].", "Files")
    AddCLIOption("-state <filename>", "Set state save file [automatic].", "Files")

    AddCLIOption("-auto / -noauto", "Enable/disable SPACE autofire.", "Emulation")
    AddCLIOption("-ram <pages>", "Number of 16kB RAM pages.", "Emulation")
    AddCLIOption("-vram <pages>", "Number of 16kB VRAM pages.", "Emulation")
    AddCLIOption("-rom <type>", "MegaROM mapper type (two -rom accepted).", "Emulation")
    AddCLIOption("ROM types", "0 Generic8, 1 Generic16, 2 Konami5, 3 Konami4, 4 ASCII8, 5 ASCII16, 6 GM2, 7 FMPAC, >7 guess.", "Emulation")
    AddCLIOption("-msx1 / -msx2 / -msx2+", "Select MSX hardware model.", "Emulation")
    AddCLIOption("-joy <type>", "Joystick type (two -joy accepted): 0 none, 1 normal, 2 mouse-joy, 3 real mouse.", "Emulation")
    AddCLIOption("-simbdos / -wd1793", "DiskROM disk access emulation mode.", "Emulation")
    AddCLIOption("-sound [<quality>]", "Sound emulation quality in Hz [44100].", "Emulation")
    AddCLIOption("-nosound", "Shortcut for -sound 0.", "Emulation")

    AddCLIOption("-sync <frequency>", "Sync screen updates to frequency [60].", "Video")
    AddCLIOption("-nosync", "Disable sync screen updates.", "Video")
    AddCLIOption("-static / -nostatic", "Enable/disable static color palette.", "Video")
    AddCLIOption("-tv / -lcd / -raster", "Simulate TV scanlines or LCD raster.", "Video")
    AddCLIOption("-linear", "Scale display with linear interpolation.", "Video")
    AddCLIOption("-soft / -eagle", "Scale display with 2xSaI or EAGLE.", "Video")
    AddCLIOption("-epx / -scale2x", "Scale display with EPX or Scale2X.", "Video")
    AddCLIOption("-cmy / -rgb", "Simulate CMY/RGB pixel raster.", "Video")
    AddCLIOption("-mono / -sepia", "Simulate monochrome or sepia CRT.", "Video")
    AddCLIOption("-green / -amber", "Simulate green or amber CRT.", "Video")
    AddCLIOption("-4x3", "Force 4:3 television aspect ratio.", "Video")

    AddCLIOption("#define DEBUG", "Build-time debug options.", "Debug")
    AddCLIOption("-trap <address>", "Trap execution when PC reaches address; use 'now' for immediate trap.", "Debug")

    AddCLIOption("#define MITSHM", "Build-time X11 shared-memory option.", "Platform")
    AddCLIOption("-shm / -noshm", "Enable/disable MIT SHM extensions for X.", "Platform")

    AddCLIOption("#define UNIX", "Build-time UNIX-specific options.", "Platform")
    AddCLIOption("-saver / -nosaver", "Save/don't save CPU when inactive.", "Platform")
    AddCLIOption("-scale <factor>", "Scale window by factor.", "Platform")

    AddCLIOption("#define MSDOS", "Build-time DOS-specific options.", "Platform")
    AddCLIOption("-vsync", "Sync screen updates to VBlank.", "Platform")
    AddCLIOption("-480 / -200", "Use 640x480 or 320x200 VGA mode.", "Platform")
EndProcedure

Procedure PopulateCLICategoryCombo(gadgetID.i)
    If Not IsGadget(gadgetID)
        ProcedureReturn
    EndIf

    AddGadgetItem(gadgetID, -1, "All")
    AddGadgetItem(gadgetID, -1, "General")
    AddGadgetItem(gadgetID, -1, "Files")
    AddGadgetItem(gadgetID, -1, "Emulation")
    AddGadgetItem(gadgetID, -1, "Video")
    AddGadgetItem(gadgetID, -1, "Debug")
    AddGadgetItem(gadgetID, -1, "Platform")
EndProcedure

Procedure.i GetCLICategoryComboIndex(category.s)
    Select NormalizeCLICategory(category)
        Case "All"
            ProcedureReturn 0
        Case "General"
            ProcedureReturn 1
        Case "Files"
            ProcedureReturn 2
        Case "Emulation"
            ProcedureReturn 3
        Case "Video"
            ProcedureReturn 4
        Case "Debug"
            ProcedureReturn 5
        Case "Platform"
            ProcedureReturn 6
    EndSelect
    ProcedureReturn 0
EndProcedure

Procedure RebuildVisibleCLIOptions()
    Protected idx.i
    Protected normalizedSearch.s

    normalizedSearch = NormalizeSearchText(gCLISearchText)

    gCLIVisibleCount = 0
    ForEach gCLIOptions()
        idx = ListIndex(gCLIOptions())
        If (gCLIFilterCategory = "All" Or gCLIOptions()\category = gCLIFilterCategory) And ShortcutMatchesSearch(gCLIOptions()\option, gCLIOptions()\category, gCLIOptions()\description, normalizedSearch)
            If gCLIVisibleCount <= ArraySize(gCLIVisibleIndex())
                gCLIVisibleIndex(gCLIVisibleCount) = idx
                gCLIVisibleCount + 1
            EndIf
        EndIf
    Next

    If gCLISelectedIndex >= 0
        ResetList(gCLIOptions())
        If SelectElement(gCLIOptions(), gCLISelectedIndex) = 0
            gCLISelectedIndex = -1
        ElseIf gCLIFilterCategory <> "All" And gCLIOptions()\category <> gCLIFilterCategory
            gCLISelectedIndex = -1
        EndIf
    EndIf

    If gCLIHoverIndex >= 0
        ResetList(gCLIOptions())
        If SelectElement(gCLIOptions(), gCLIHoverIndex) = 0
            gCLIHoverIndex = -1
        ElseIf gCLIFilterCategory <> "All" And gCLIOptions()\category <> gCLIFilterCategory
            gCLIHoverIndex = -1
        EndIf
    EndIf
EndProcedure

Procedure.i CalculateCLICanvasHeight(canvasWidth.i)
    Protected cardHeight.i = 108
    Protected gap.i = 16
    Protected cardsPerRow.i = 1
    Protected rows.i

    If canvasWidth >= 880
        cardsPerRow = 2
    EndIf

    rows = (gCLIVisibleCount + cardsPerRow - 1) / cardsPerRow
    If rows < 1
        rows = 1
    EndIf
    ProcedureReturn 18 + rows * (cardHeight + gap)
EndProcedure

Procedure.i GetCLIOptionAtCanvasPosition(mouseX.i, mouseY.i)
    Protected canvasWidth.i
    Protected cardsPerRow.i = 1
    Protected cardGap.i = 16
    Protected cardWidth.i
    Protected cardHeight.i = 108
    Protected margin.i = 14
    Protected col.i
    Protected row.i
    Protected localX.i
    Protected localY.i
    Protected slot.i

    If gCLIVisibleCount <= 0
        ProcedureReturn -1
    EndIf

    canvasWidth = GadgetWidth(#Gadget_CLI_Canvas)
    If canvasWidth >= 880
        cardsPerRow = 2
    EndIf
    cardWidth = (canvasWidth - (margin * 2) - (cardGap * (cardsPerRow - 1))) / cardsPerRow

    If mouseX < margin Or mouseY < 18
        ProcedureReturn -1
    EndIf

    col = Int((mouseX - margin) / (cardWidth + cardGap))
    row = Int((mouseY - 18) / (cardHeight + cardGap))
    If col < 0 Or col >= cardsPerRow
        ProcedureReturn -1
    EndIf

    localX = (mouseX - margin) % (cardWidth + cardGap)
    localY = (mouseY - 18) % (cardHeight + cardGap)
    If localX >= cardWidth Or localY >= cardHeight
        ProcedureReturn -1
    EndIf

    slot = row * cardsPerRow + col
    If slot < 0 Or slot >= gCLIVisibleCount
        ProcedureReturn -1
    EndIf

    ProcedureReturn gCLIVisibleIndex(slot)
EndProcedure

Procedure.s GetCLIOptionDisplayText(optionIndex.i)
    If SelectElement(gCLIOptions(), optionIndex) = 0
        ProcedureReturn ""
    EndIf

    ProcedureReturn gCLIOptions()\option + " - " + gCLIOptions()\description
EndProcedure

Procedure CopySelectedCLIOption()
    Protected text.s

    If gCLISelectedIndex < 0
        MessageRequester("CLI", "Select a card before copying.")
        ProcedureReturn
    EndIf

    text = GetCLIOptionDisplayText(gCLISelectedIndex)
    If text = ""
        MessageRequester("CLI", "Invalid CLI entry for copy.")
        ProcedureReturn
    EndIf

    SetClipboardText(text)
    MessageRequester("CLI", "CLI entry copied to clipboard:" + Chr(10) + Chr(10) + text)
EndProcedure

Procedure DrawCLICards()
    Protected canvasWidth.i
    Protected canvasHeight.i
    Protected cardsPerRow.i = 1
    Protected cardGap.i = 16
    Protected cardWidth.i
    Protected cardHeight.i = 108
    Protected margin.i = 14
    Protected i.i
    Protected itemIndex.i
    Protected x.i
    Protected y.i
    Protected cardBack.i
    Protected cardTop.i
    Protected cardBorder.i

    If Not IsGadget(#Gadget_CLI_Canvas)
        ProcedureReturn
    EndIf

    EnsureUIFont()
    canvasWidth = GadgetWidth(#Gadget_CLI_Canvas)
    canvasHeight = GadgetHeight(#Gadget_CLI_Canvas)
    If canvasWidth >= 880
        cardsPerRow = 2
    EndIf
    cardWidth = (canvasWidth - (margin * 2) - (cardGap * (cardsPerRow - 1))) / cardsPerRow

    If StartDrawing(CanvasOutput(#Gadget_CLI_Canvas))
        Box(0, 0, canvasWidth, canvasHeight, gThemeInputBack)

        For i = 0 To gCLIVisibleCount - 1
            itemIndex = gCLIVisibleIndex(i)
            If SelectElement(gCLIOptions(), itemIndex)
                x = margin + (i % cardsPerRow) * (cardWidth + cardGap)
                y = 18 + (i / cardsPerRow) * (cardHeight + cardGap)

                cardBack = gThemePanelBack
                cardTop = gThemeAccent
                cardBorder = gThemeBorder
                If itemIndex = gCLIHoverIndex
                    cardBack = BlendColor(gThemePanelBack, gThemeAccent, 0.18)
                    cardTop = BlendColor(gThemeAccent, gThemeAccentText, 0.10)
                    cardBorder = BlendColor(gThemeBorder, gThemeAccent, 0.35)
                ElseIf itemIndex = gCLISelectedIndex
                    cardBack = BlendColor(gThemePanelBack, gThemeAccent, 0.12)
                    cardBorder = BlendColor(gThemeBorder, gThemeAccent, 0.25)
                EndIf

                Box(x, y, cardWidth, cardHeight, cardBack)
                Box(x, y, cardWidth, 3, cardTop)
                Box(x, y + cardHeight - 1, cardWidth, 1, cardBorder)
                Box(x, y, 1, cardHeight, cardBorder)
                Box(x + cardWidth - 1, y, 1, cardHeight, cardBorder)

                DrawingMode(#PB_2DDrawing_Transparent)
                DrawingFont(FontID(gUIFontCaption))
                DrawText(x + 14, y + 10, "[" + gCLIOptions()\category + "]", gThemeMutedText, cardBack)
                DrawingFont(FontID(gUIFontNormal))
                DrawText(x + 14, y + 34, gCLIOptions()\option, gThemeText, cardBack)
                DrawingFont(FontID(gUIFontCaption))
                DrawText(x + 14, y + 60, gCLIOptions()\description, gThemeMutedText, cardBack)
            EndIf
        Next

        StopDrawing()
    EndIf
EndProcedure

Procedure ResizeCLICanvas()
    Protected canvasWidth.i
    Protected canvasHeight.i

    If Not IsGadget(#Gadget_CLI_Scroll) Or Not IsGadget(#Gadget_CLI_Canvas)
        ProcedureReturn
    EndIf

    canvasWidth = GadgetWidth(#Gadget_CLI_Scroll) - 16
    If canvasWidth < 420
        canvasWidth = 420
    EndIf
    canvasHeight = CalculateCLICanvasHeight(canvasWidth)

    SetGadgetAttribute(#Gadget_CLI_Scroll, #PB_ScrollArea_InnerWidth, canvasWidth)
    SetGadgetAttribute(#Gadget_CLI_Scroll, #PB_ScrollArea_InnerHeight, canvasHeight)
    ResizeGadget(#Gadget_CLI_Canvas, 0, 0, canvasWidth, canvasHeight)
    DrawCLICards()
EndProcedure

Procedure ShowCLIWindow()
    Protected canvasWidth.i
    Protected canvasHeight.i

    If IsWindow(#Window_CLI)
        SetActiveWindow(#Window_CLI)
        ProcedureReturn
    EndIf

    InitCLIOptions()
    gCLIFilterCategory = NormalizeCLICategory(gCLIFilterCategory)
    gCLISearchText = Trim(gCLISearchText)
    gCLIHoverIndex = -1

    If OpenWindow(#Window_CLI, 0, 0, 1020, 780, "fMSX CLI Reference", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_WindowCentered, WindowID(#Window_Main))
        TextGadget(#Gadget_CLI_Title, 20, 16, 700, 40, "fMSX - Command Line Reference")
        TextGadget(#Gadget_CLI_Subtitle, 20, 58, 980, 22, "Card-based quick reference for curiosity and command discovery")
        TextGadget(#Gadget_CLI_FilterLabel, 20, 86, 84, 22, "Category:")
        ComboBoxGadget(#Gadget_CLI_FilterCombo, 102, 84, 180, 24)
        PopulateCLICategoryCombo(#Gadget_CLI_FilterCombo)
        SetGadgetState(#Gadget_CLI_FilterCombo, GetCLICategoryComboIndex(gCLIFilterCategory))
        TextGadget(#Gadget_CLI_SearchLabel, 300, 86, 58, 22, "Search:")
        StringGadget(#Gadget_CLI_SearchInput, 360, 84, 520, 24, gCLISearchText)

        canvasWidth = 964
        RebuildVisibleCLIOptions()
        canvasHeight = CalculateCLICanvasHeight(canvasWidth)
        ScrollAreaGadget(#Gadget_CLI_Scroll, 20, 118, 980, 602, canvasWidth, canvasHeight, 14)
        CanvasGadget(#Gadget_CLI_Canvas, 0, 0, canvasWidth, canvasHeight, #PB_Canvas_Keyboard)
        CloseGadgetList()

        ButtonGadget(#Gadget_CLI_Copy, 20, 730, 140, 30, "Copy entry")
        ButtonGadget(#Gadget_CLI_Close, 880, 730, 120, 30, "Close")

        ApplyThemeToCLIWindow()
    EndIf
EndProcedure

Procedure.s NormalizeThemeName(themeName.s)
    Protected normalized.s

    normalized = LCase(Trim(themeName))
    Select normalized
        Case "light", "claro"
            ProcedureReturn "Light"
        Case "dark", "escuro"
            ProcedureReturn "Dark"
        Case "vs code dark+", "vscode dark+", "dark+"
            ProcedureReturn "VS Code Dark+"
        Case "vs code light+", "vscode light+", "light+"
            ProcedureReturn "VS Code Light+"
        Case "github light", "github"
            ProcedureReturn "GitHub Light"
        Case "github dark"
            ProcedureReturn "GitHub Dark"
        Case "vim"
            ProcedureReturn "Vim"
        Case "monokai"
            ProcedureReturn "Monokai"
        Case "solarized dark"
            ProcedureReturn "Solarized Dark"
    EndSelect

    ProcedureReturn "VS Code Dark+"
EndProcedure

Procedure ApplyThemePalette(themeName.s)
    gThemeName = NormalizeThemeName(themeName)

    Select gThemeName
        Case "Light"
            gThemeWindowBack = RGB(245, 247, 250)
            gThemePanelBack = RGB(255, 255, 255)
            gThemeInputBack = RGB(255, 255, 255)
            gThemeInputFront = RGB(32, 35, 42)
            gThemeText = RGB(32, 35, 42)
            gThemeMutedText = RGB(91, 99, 110)
            gThemeAccent = RGB(0, 120, 212)
            gThemeAccentText = RGB(255, 255, 255)
            gThemeBorder = RGB(210, 214, 220)

        Case "Dark"
            gThemeWindowBack = RGB(30, 30, 30)
            gThemePanelBack = RGB(37, 37, 38)
            gThemeInputBack = RGB(45, 45, 48)
            gThemeInputFront = RGB(241, 241, 241)
            gThemeText = RGB(230, 230, 230)
            gThemeMutedText = RGB(156, 163, 175)
            gThemeAccent = RGB(14, 99, 156)
            gThemeAccentText = RGB(255, 255, 255)
            gThemeBorder = RGB(62, 62, 66)

        Case "VS Code Light+"
            gThemeWindowBack = RGB(243, 243, 243)
            gThemePanelBack = RGB(255, 255, 255)
            gThemeInputBack = RGB(255, 255, 255)
            gThemeInputFront = RGB(51, 51, 51)
            gThemeText = RGB(51, 51, 51)
            gThemeMutedText = RGB(97, 97, 97)
            gThemeAccent = RGB(0, 122, 204)
            gThemeAccentText = RGB(255, 255, 255)
            gThemeBorder = RGB(229, 229, 229)

        Case "GitHub Light"
            gThemeWindowBack = RGB(246, 248, 250)
            gThemePanelBack = RGB(255, 255, 255)
            gThemeInputBack = RGB(255, 255, 255)
            gThemeInputFront = RGB(31, 35, 40)
            gThemeText = RGB(31, 35, 40)
            gThemeMutedText = RGB(87, 96, 106)
            gThemeAccent = RGB(9, 105, 218)
            gThemeAccentText = RGB(255, 255, 255)
            gThemeBorder = RGB(208, 215, 222)

        Case "GitHub Dark"
            gThemeWindowBack = RGB(13, 17, 23)
            gThemePanelBack = RGB(22, 27, 34)
            gThemeInputBack = RGB(33, 38, 45)
            gThemeInputFront = RGB(230, 237, 243)
            gThemeText = RGB(230, 237, 243)
            gThemeMutedText = RGB(139, 148, 158)
            gThemeAccent = RGB(47, 129, 247)
            gThemeAccentText = RGB(255, 255, 255)
            gThemeBorder = RGB(48, 54, 61)

        Case "Vim"
            gThemeWindowBack = RGB(34, 34, 34)
            gThemePanelBack = RGB(43, 43, 43)
            gThemeInputBack = RGB(28, 28, 28)
            gThemeInputFront = RGB(216, 216, 216)
            gThemeText = RGB(216, 216, 216)
            gThemeMutedText = RGB(135, 135, 135)
            gThemeAccent = RGB(135, 175, 95)
            gThemeAccentText = RGB(17, 17, 17)
            gThemeBorder = RGB(68, 68, 68)

        Case "Monokai"
            gThemeWindowBack = RGB(39, 40, 34)
            gThemePanelBack = RGB(47, 49, 41)
            gThemeInputBack = RGB(53, 55, 47)
            gThemeInputFront = RGB(248, 248, 242)
            gThemeText = RGB(248, 248, 242)
            gThemeMutedText = RGB(166, 172, 160)
            gThemeAccent = RGB(249, 38, 114)
            gThemeAccentText = RGB(255, 255, 255)
            gThemeBorder = RGB(88, 90, 80)

        Case "Solarized Dark"
            gThemeWindowBack = RGB(0, 43, 54)
            gThemePanelBack = RGB(7, 54, 66)
            gThemeInputBack = RGB(0, 56, 68)
            gThemeInputFront = RGB(238, 232, 213)
            gThemeText = RGB(238, 232, 213)
            gThemeMutedText = RGB(147, 161, 161)
            gThemeAccent = RGB(38, 139, 210)
            gThemeAccentText = RGB(255, 255, 255)
            gThemeBorder = RGB(88, 110, 117)

        Default ; VS Code Dark+
            gThemeWindowBack = RGB(30, 30, 30)
            gThemePanelBack = RGB(37, 37, 38)
            gThemeInputBack = RGB(30, 30, 30)
            gThemeInputFront = RGB(204, 204, 204)
            gThemeText = RGB(204, 204, 204)
            gThemeMutedText = RGB(156, 163, 175)
            gThemeAccent = RGB(0, 122, 204)
            gThemeAccentText = RGB(255, 255, 255)
            gThemeBorder = RGB(62, 62, 66)
    EndSelect
EndProcedure

Procedure ApplyTextTheme(gadgetID.i, backColor.i, frontColor.i)
    If IsGadget(gadgetID)
        SetGadgetColor(gadgetID, #PB_Gadget_BackColor, backColor)
        SetGadgetColor(gadgetID, #PB_Gadget_FrontColor, frontColor)
    EndIf
EndProcedure

Procedure ApplyInputTheme(gadgetID.i)
    If IsGadget(gadgetID)
        SetGadgetColor(gadgetID, #PB_Gadget_BackColor, gThemeInputBack)
        SetGadgetColor(gadgetID, #PB_Gadget_FrontColor, gThemeInputFront)
    EndIf
EndProcedure

Procedure ApplyButtonTheme(gadgetID.i, primary.i = #False)
    If IsGadget(gadgetID)
        If primary
            SetGadgetColor(gadgetID, #PB_Gadget_BackColor, gThemeAccent)
            SetGadgetColor(gadgetID, #PB_Gadget_FrontColor, gThemeAccentText)
        Else
            SetGadgetColor(gadgetID, #PB_Gadget_BackColor, gThemePanelBack)
            SetGadgetColor(gadgetID, #PB_Gadget_FrontColor, gThemeText)
        EndIf
    EndIf
EndProcedure

Procedure ApplyThemeToMainWindow()
    EnsureUIFont()

    If IsWindow(#Window_Main)
        SetWindowColor(#Window_Main, gThemeWindowBack)
    EndIf

    ApplyTextTheme(#Gadget_Main_HeroPanel, gThemePanelBack, gThemePanelBack)
    ApplyTextTheme(#Gadget_Main_Title, gThemePanelBack, gThemeText)
    ApplyTextTheme(#Gadget_Main_Subtitle, gThemePanelBack, gThemeMutedText)
    ApplyTextTheme(#Gadget_Main_ThemeBadge, gThemePanelBack, gThemeMutedText)
    ApplyTextTheme(#Gadget_Main_ThemeValue, gThemePanelBack, gThemeAccent)
    ApplyTextTheme(#Gadget_Main_FontBadge, gThemePanelBack, gThemeMutedText)
    ApplyTextTheme(#Gadget_Main_FontValue, gThemePanelBack, gThemeAccent)
    ApplyTextTheme(#Gadget_Main_Hint, gThemeWindowBack, gThemeMutedText)
    ApplyButtonTheme(#Gadget_Main_Run, #True)

    ApplyFontToAllGadgets(FontID(gUIFontNormal))

    If IsGadget(#Gadget_Main_Title)
        SetGadgetFont(#Gadget_Main_Title, FontID(gUIFontTitle))
    EndIf
    If IsGadget(#Gadget_Main_Subtitle)
        SetGadgetFont(#Gadget_Main_Subtitle, FontID(gUIFontNormal))
    EndIf
    If IsGadget(#Gadget_Main_ThemeBadge)
        SetGadgetFont(#Gadget_Main_ThemeBadge, FontID(gUIFontCaption))
    EndIf
    If IsGadget(#Gadget_Main_ThemeValue)
        SetGadgetFont(#Gadget_Main_ThemeValue, FontID(gUIFontNormal))
        SetGadgetText(#Gadget_Main_ThemeValue, gThemeName)
    EndIf
    If IsGadget(#Gadget_Main_FontBadge)
        SetGadgetFont(#Gadget_Main_FontBadge, FontID(gUIFontCaption))
    EndIf
    If IsGadget(#Gadget_Main_FontValue)
        SetGadgetFont(#Gadget_Main_FontValue, FontID(gUIFontNormal))
        SetGadgetText(#Gadget_Main_FontValue, GetRuntimeFontSourceCompact())
    EndIf
    If IsGadget(#Gadget_Main_Hint)
        SetGadgetFont(#Gadget_Main_Hint, FontID(gUIFontCaption))
    EndIf
    If IsGadget(#Gadget_Main_Run)
        SetGadgetFont(#Gadget_Main_Run, FontID(gUIFontNormal))
    EndIf
EndProcedure

Procedure ApplyThemeToKeysWindow()
    EnsureUIFont()

    If IsWindow(#Window_Keys)
        SetWindowColor(#Window_Keys, gThemeWindowBack)
    EndIf

    ApplyTextTheme(#Gadget_Keys_Title, gThemeWindowBack, gThemeText)
    ApplyTextTheme(#Gadget_Keys_Subtitle, gThemeWindowBack, gThemeMutedText)
    ApplyTextTheme(#Gadget_Keys_FilterLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Keys_FilterCombo)
    ApplyTextTheme(#Gadget_Keys_SearchLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Keys_SearchInput)
    ApplyTextTheme(#Gadget_Keys_Scroll, gThemeInputBack, gThemeText)
    ApplyButtonTheme(#Gadget_Keys_Copy)
    ApplyButtonTheme(#Gadget_Keys_Close, #True)

    ApplyFontToAllGadgets(FontID(gUIFontNormal))

    If IsGadget(#Gadget_Keys_Title)
        SetGadgetFont(#Gadget_Keys_Title, FontID(gUIFontTitle))
    EndIf
    If IsGadget(#Gadget_Keys_Subtitle)
        SetGadgetFont(#Gadget_Keys_Subtitle, FontID(gUIFontCaption))
    EndIf
    If IsGadget(#Gadget_Keys_FilterLabel)
        SetGadgetFont(#Gadget_Keys_FilterLabel, FontID(gUIFontCaption))
    EndIf
    If IsGadget(#Gadget_Keys_FilterCombo)
        SetGadgetFont(#Gadget_Keys_FilterCombo, FontID(gUIFontNormal))
    EndIf
    If IsGadget(#Gadget_Keys_SearchLabel)
        SetGadgetFont(#Gadget_Keys_SearchLabel, FontID(gUIFontCaption))
    EndIf
    If IsGadget(#Gadget_Keys_SearchInput)
        SetGadgetFont(#Gadget_Keys_SearchInput, FontID(gUIFontNormal))
    EndIf
    If IsGadget(#Gadget_Keys_Copy)
        SetGadgetFont(#Gadget_Keys_Copy, FontID(gUIFontNormal))
    EndIf
    If IsGadget(#Gadget_Keys_Close)
        SetGadgetFont(#Gadget_Keys_Close, FontID(gUIFontNormal))
    EndIf

    DrawKeysCards()
EndProcedure

Procedure ApplyThemeToAboutWindow()
    EnsureUIFont()

    If IsWindow(#Window_About)
        SetWindowColor(#Window_About, gThemeWindowBack)
    EndIf

    ApplyTextTheme(#Gadget_About_Title, gThemeWindowBack, gThemeText)
    ApplyTextTheme(#Gadget_About_Subtitle, gThemeWindowBack, gThemeMutedText)
    ApplyTextTheme(#Gadget_About_Scroll, gThemeInputBack, gThemeText)
    ApplyButtonTheme(#Gadget_About_Close, #True)

    ApplyFontToAllGadgets(FontID(gUIFontNormal))
    DrawAboutCards()
EndProcedure

Procedure ApplyThemeToCLIWindow()
    EnsureUIFont()

    If IsWindow(#Window_CLI)
        SetWindowColor(#Window_CLI, gThemeWindowBack)
    EndIf

    ApplyTextTheme(#Gadget_CLI_Title, gThemeWindowBack, gThemeText)
    ApplyTextTheme(#Gadget_CLI_Subtitle, gThemeWindowBack, gThemeMutedText)
    ApplyTextTheme(#Gadget_CLI_FilterLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_CLI_FilterCombo)
    ApplyTextTheme(#Gadget_CLI_SearchLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_CLI_SearchInput)
    ApplyTextTheme(#Gadget_CLI_Scroll, gThemeInputBack, gThemeText)
    ApplyButtonTheme(#Gadget_CLI_Copy)
    ApplyButtonTheme(#Gadget_CLI_Close, #True)

    ApplyFontToAllGadgets(FontID(gUIFontNormal))

    If IsGadget(#Gadget_CLI_Title)
        SetGadgetFont(#Gadget_CLI_Title, FontID(gUIFontTitle))
    EndIf
    If IsGadget(#Gadget_CLI_Subtitle)
        SetGadgetFont(#Gadget_CLI_Subtitle, FontID(gUIFontCaption))
    EndIf
    If IsGadget(#Gadget_CLI_FilterLabel)
        SetGadgetFont(#Gadget_CLI_FilterLabel, FontID(gUIFontCaption))
    EndIf
    If IsGadget(#Gadget_CLI_FilterCombo)
        SetGadgetFont(#Gadget_CLI_FilterCombo, FontID(gUIFontNormal))
    EndIf
    If IsGadget(#Gadget_CLI_SearchLabel)
        SetGadgetFont(#Gadget_CLI_SearchLabel, FontID(gUIFontCaption))
    EndIf
    If IsGadget(#Gadget_CLI_SearchInput)
        SetGadgetFont(#Gadget_CLI_SearchInput, FontID(gUIFontNormal))
    EndIf
    If IsGadget(#Gadget_CLI_Copy)
        SetGadgetFont(#Gadget_CLI_Copy, FontID(gUIFontNormal))
    EndIf
    If IsGadget(#Gadget_CLI_Close)
        SetGadgetFont(#Gadget_CLI_Close, FontID(gUIFontNormal))
    EndIf

    DrawCLICards()
EndProcedure

Procedure ApplyThemeToSetupWindow()
    EnsureUIFont()

    If IsWindow(#Window_Setup)
        SetWindowColor(#Window_Setup, gThemeWindowBack)
    EndIf

    ApplyTextTheme(#Gadget_Setup_PathLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_PathInput)
    ApplyButtonTheme(#Gadget_Setup_Browse)
    ApplyTextTheme(#Gadget_Setup_ModeLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_ModeCombo)
    ApplyTextTheme(#Gadget_Setup_ThemeLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_ThemeCombo)
    ApplyTextTheme(#Gadget_Setup_VideoLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_VideoCombo)
    ApplyTextTheme(#Gadget_Setup_MonoLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_MonoCombo)
    ApplyTextTheme(#Gadget_Setup_ScaleLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_ScaleCombo)
    ApplyTextTheme(#Gadget_Setup_AutoLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_AutoCombo)
    ApplyTextTheme(#Gadget_Setup_RAMLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_RAMCombo)
    ApplyTextTheme(#Gadget_Setup_VRAMLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_VRAMCombo)
    ApplyTextTheme(#Gadget_Setup_ROM1Label, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_ROM1Combo)
    ApplyTextTheme(#Gadget_Setup_ROM2Label, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_ROM2Combo)
    ApplyTextTheme(#Gadget_Setup_Joy1Label, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_Joy1Combo)
    ApplyTextTheme(#Gadget_Setup_Joy2Label, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_Joy2Combo)
    ApplyTextTheme(#Gadget_Setup_DiskLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_DiskCombo)
    ApplyTextTheme(#Gadget_Setup_SoundLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_SoundCombo)
    ApplyTextTheme(#Gadget_Setup_VerboseLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_VerboseCombo)
    ApplyTextTheme(#Gadget_Setup_SkipLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_SkipCombo)
    ApplyTextTheme(#Gadget_Setup_PrinterLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_PrinterInput)
    ApplyButtonTheme(#Gadget_Setup_PrinterBrowse)
    ApplyButtonTheme(#Gadget_Setup_PrinterCreate)
    ApplyTextTheme(#Gadget_Setup_SerialLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_SerialInput)
    ApplyButtonTheme(#Gadget_Setup_SerialBrowse)
    ApplyButtonTheme(#Gadget_Setup_SerialCreate)
    ApplyTextTheme(#Gadget_Setup_DiskALabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_DiskAInput)
    ApplyButtonTheme(#Gadget_Setup_DiskABrowse)
    ApplyButtonTheme(#Gadget_Setup_DiskACreate)
    ApplyTextTheme(#Gadget_Setup_DiskBLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_DiskBInput)
    ApplyButtonTheme(#Gadget_Setup_DiskBBrowse)
    ApplyButtonTheme(#Gadget_Setup_DiskBCreate)
    ApplyTextTheme(#Gadget_Setup_TapeLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_TapeInput)
    ApplyButtonTheme(#Gadget_Setup_TapeBrowse)
    ApplyButtonTheme(#Gadget_Setup_TapeCreate)
    ApplyTextTheme(#Gadget_Setup_FontLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_FontInput)
    ApplyButtonTheme(#Gadget_Setup_FontBrowse)
    ApplyButtonTheme(#Gadget_Setup_FontCreate)
    ApplyTextTheme(#Gadget_Setup_LogSndLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_LogSndInput)
    ApplyButtonTheme(#Gadget_Setup_LogSndBrowse)
    ApplyButtonTheme(#Gadget_Setup_LogSndCreate)
    ApplyTextTheme(#Gadget_Setup_StateLabel, gThemeWindowBack, gThemeText)
    ApplyInputTheme(#Gadget_Setup_StateInput)
    ApplyButtonTheme(#Gadget_Setup_StateBrowse)
    ApplyButtonTheme(#Gadget_Setup_StateCreate)
    ApplyTextTheme(#Gadget_Setup_4x3, gThemeWindowBack, gThemeText)
    ApplyButtonTheme(#Gadget_Setup_Save, #True)
    ApplyButtonTheme(#Gadget_Setup_Cancel)

    ApplyFontToAllGadgets(FontID(gUIFontNormal))
EndProcedure

Procedure ApplyCurrentTheme()
    ApplyThemePalette(gThemeName)
    ApplyThemeToMainWindow()
    ApplyThemeToSetupWindow()
    ApplyThemeToCLIWindow()
    ApplyThemeToKeysWindow()
    ApplyThemeToAboutWindow()
EndProcedure

Procedure PopulateThemeCombo(gadgetID.i)
    If Not IsGadget(gadgetID)
        ProcedureReturn
    EndIf

    AddGadgetItem(gadgetID, -1, "Light")
    AddGadgetItem(gadgetID, -1, "Dark")
    AddGadgetItem(gadgetID, -1, "VS Code Dark+")
    AddGadgetItem(gadgetID, -1, "VS Code Light+")
    AddGadgetItem(gadgetID, -1, "GitHub Light")
    AddGadgetItem(gadgetID, -1, "GitHub Dark")
    AddGadgetItem(gadgetID, -1, "Vim")
    AddGadgetItem(gadgetID, -1, "Monokai")
    AddGadgetItem(gadgetID, -1, "Solarized Dark")
EndProcedure

Procedure.i GetThemeComboIndex(themeName.s)
    Select NormalizeThemeName(themeName)
        Case "Light"
            ProcedureReturn 0
        Case "Dark"
            ProcedureReturn 1
        Case "VS Code Dark+"
            ProcedureReturn 2
        Case "VS Code Light+"
            ProcedureReturn 3
        Case "GitHub Light"
            ProcedureReturn 4
        Case "GitHub Dark"
            ProcedureReturn 5
        Case "Vim"
            ProcedureReturn 6
        Case "Monokai"
            ProcedureReturn 7
        Case "Solarized Dark"
            ProcedureReturn 8
    EndSelect

    ProcedureReturn 2
EndProcedure

Procedure ShowAboutDialog()
    Protected canvasWidth.i
    Protected canvasHeight.i

    If IsWindow(#Window_About)
        SetActiveWindow(#Window_About)
        ProcedureReturn
    EndIf

    gAboutHoverIndex = -1
    EnsureUIFont()

    If OpenWindow(#Window_About, 0, 0, 900, 720, "About - " + #App_Name, #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_WindowCentered, WindowID(#Window_Main))
        TextGadget(#Gadget_About_Title, 20, 16, 500, 40, "About - " + #App_Name)
        TextGadget(#Gadget_About_Subtitle, 20, 58, 860, 22, "Program information presented as cards")

        canvasWidth = 844
        canvasHeight = CalculateAboutCanvasHeight(canvasWidth)
        ScrollAreaGadget(#Gadget_About_Scroll, 20, 88, 860, 582, canvasWidth, canvasHeight, 14)
        CanvasGadget(#Gadget_About_Canvas, 0, 0, canvasWidth, canvasHeight, #PB_Canvas_Keyboard)
        CloseGadgetList()

        ButtonGadget(#Gadget_About_Close, 760, 678, 120, 30, "Close")

        ApplyThemeToAboutWindow()
    EndIf
EndProcedure

Procedure ShowKeysWindow()
    Protected canvasWidth.i
    Protected canvasHeight.i

    If IsWindow(#Window_Keys)
        SetActiveWindow(#Window_Keys)
        ProcedureReturn
    EndIf

    InitKeyShortcuts()
    gKeysFilterCategory = NormalizeKeysCategory(gKeysFilterCategory)
    gKeysSearchText = Trim(gKeysSearchText)
    gKeysHoverIndex = -1

    If OpenWindow(#Window_Keys, 0, 0, 900, 760, "fMSX Keys", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_WindowCentered, WindowID(#Window_Main))
        TextGadget(#Gadget_Keys_Title, 20, 16, 500, 40, "fMSX - Keyboard Quick Reference")
        TextGadget(#Gadget_Keys_Subtitle, 20, 58, 840, 22, "Visual cards for fMSX keys and combinations")
        TextGadget(#Gadget_Keys_FilterLabel, 20, 86, 84, 22, "Category:")
        ComboBoxGadget(#Gadget_Keys_FilterCombo, 102, 84, 180, 24)
        PopulateKeysCategoryCombo(#Gadget_Keys_FilterCombo)
        SetGadgetState(#Gadget_Keys_FilterCombo, GetKeysCategoryComboIndex(gKeysFilterCategory))
        TextGadget(#Gadget_Keys_SearchLabel, 300, 86, 58, 22, "Search:")
        StringGadget(#Gadget_Keys_SearchInput, 360, 84, 420, 24, gKeysSearchText)

        canvasWidth = 844
        RebuildVisibleKeyShortcuts()
        canvasHeight = CalculateKeysCanvasHeight(canvasWidth)
        ScrollAreaGadget(#Gadget_Keys_Scroll, 20, 118, 860, 582, canvasWidth, canvasHeight, 14)
        CanvasGadget(#Gadget_Keys_Canvas, 0, 0, canvasWidth, canvasHeight, #PB_Canvas_Keyboard)
        CloseGadgetList()

        ButtonGadget(#Gadget_Keys_Copy, 20, 710, 160, 30, "Copy shortcut")
        ButtonGadget(#Gadget_Keys_Close, 760, 710, 120, 30, "Close")
        AddWindowTimer(#Window_Keys, #Timer_KeysHover, 16)

        ApplyThemeToKeysWindow()
    EndIf
EndProcedure

; --- Normalizacao de opcoes visuais e montagem dos argumentos do fMSX ---
; Essas procedures aceitam texto vindo da interface/SQLite e devolvem valores
; seguros para o dominio esperado pelo emulador.
Procedure.s NormalizeScaleFilter(filter.s)
    filter = LCase(Trim(filter))
    Select filter
        Case "linear"
            ProcedureReturn "linear"
        Case "soft"
            ProcedureReturn "soft"
        Case "eagle"
            ProcedureReturn "eagle"
        Case "epx"
            ProcedureReturn "epx"
        Case "scale2x"
            ProcedureReturn "scale2x"
    EndSelect
    ProcedureReturn ""
EndProcedure

Procedure.s GetScaleFilterArg(filter.s)
    Select NormalizeScaleFilter(filter)
        Case "linear"
            ProcedureReturn " -linear"
        Case "soft"
            ProcedureReturn " -soft"
        Case "eagle"
            ProcedureReturn " -eagle"
        Case "epx"
            ProcedureReturn " -epx"
        Case "scale2x"
            ProcedureReturn " -scale2x"
    EndSelect
    ProcedureReturn ""
EndProcedure

Procedure.i NormalizeAutoFire(value.s)
    value = UCase(Trim(value))
    Select value
        Case "AUTO", "LIGADO", "ON", "1", "SIM", "YES"
            ProcedureReturn 1
    EndSelect
    ProcedureReturn 0
EndProcedure

Procedure.s GetAutoFireArg(enabled.i)
    If enabled
        ProcedureReturn " -auto"
    EndIf
    ProcedureReturn " -noauto"
EndProcedure

Procedure.i NormalizeRamPages(value.s)
    Protected pages.i
    pages = Val(Trim(value))
    If pages < 1
        ProcedureReturn 4
    EndIf
    ProcedureReturn pages
EndProcedure

Procedure.s GetRamArg(pages.i)
    If pages < 1
        pages = 4
    EndIf
    ProcedureReturn " -ram " + Str(pages)
EndProcedure

Procedure.i NormalizeVRamPages(value.s)
    Protected pages.i
    pages = Val(Trim(value))
    If pages < 1
        ProcedureReturn 2
    EndIf
    ProcedureReturn pages
EndProcedure

Procedure.s GetVRamArg(pages.i)
    If pages < 1
        pages = 2
    EndIf
    ProcedureReturn " -vram " + Str(pages)
EndProcedure

Procedure.i NormalizeRomType(value.s)
    Protected t.s
    t = UCase(Trim(value))
    If t = "" Or FindString(t, "NENHUM", 1) Or FindString(t, "NONE", 1)
        ProcedureReturn -1
    EndIf
    ProcedureReturn Val(value)
EndProcedure

Procedure.s GetRomArg(type1.i, type2.i)
    Protected result.s = ""
    If type1 >= 0
        result + " -rom " + Str(type1)
    EndIf
    If type2 >= 0
        result + " -rom " + Str(type2)
    EndIf
    ProcedureReturn result
EndProcedure

Procedure.i NormalizeJoyType(value.s)
    Protected t.i
    t = Val(Trim(value))
    If t < 0 Or t > 3
        ProcedureReturn 0
    EndIf
    ProcedureReturn t
EndProcedure

Procedure.s GetJoyArg(type1.i, type2.i)
    ProcedureReturn " -joy " + Str(NormalizeJoyType(Str(type1))) + " -joy " + Str(NormalizeJoyType(Str(type2)))
EndProcedure

Procedure.s NormalizeDiskMode(value.s)
    value = UCase(Trim(value))
    If value = "SIMBDOS" Or FindString(value, "SIMBDOS", 1)
        ProcedureReturn "SIMBDOS"
    EndIf
    ProcedureReturn "WD1793"
EndProcedure

Procedure.s GetDiskModeArg(value.s)
    If NormalizeDiskMode(value) = "SIMBDOS"
        ProcedureReturn " -simbdos"
    EndIf
    ProcedureReturn " -wd1793"
EndProcedure

Procedure.i NormalizeSoundQuality(value.s)
    Protected q.i
    q = Val(Trim(value))
    If q <= 0
        ProcedureReturn 0
    EndIf
    ProcedureReturn q
EndProcedure

Procedure.s GetSoundArg(quality.i)
    quality = NormalizeSoundQuality(Str(quality))
    If quality = 0
        ProcedureReturn " -nosound"
    EndIf
    ProcedureReturn " -sound " + Str(quality)
EndProcedure

Procedure.i NormalizeVerboseLevel(value.s)
    Protected level.i
    level = Val(Trim(value))
    If level < 0
        level = 1
    EndIf
    ProcedureReturn level
EndProcedure

Procedure.s GetVerboseArg(level.i)
    level = NormalizeVerboseLevel(Str(level))
    ProcedureReturn " -verbose " + Str(level)
EndProcedure

Procedure.i NormalizeSkipPercent(value.s)
    Protected p.i
    p = Val(Trim(value))
    If p < 0
        ProcedureReturn 0
    EndIf
    If p > 100
        ProcedureReturn 100
    EndIf
    ProcedureReturn p
EndProcedure

Procedure.s GetSkipArg(percent.i)
    percent = NormalizeSkipPercent(Str(percent))
    ProcedureReturn " -skip " + Str(percent)
EndProcedure

Procedure.s BuildSingleFileArg(optionName.s, filePath.s)
    filePath = Trim(filePath)
    If filePath = ""
        ProcedureReturn ""
    EndIf
    ProcedureReturn " " + optionName + " " + Chr(34) + filePath + Chr(34)
EndProcedure

Procedure.s BuildMultiFileArg(optionName.s, fileList.s)
    Protected i.i
    Protected item.s
    Protected result.s = ""

    For i = 1 To CountString(fileList, ";") + 1
        item = Trim(StringField(fileList, i, ";"))
        If item <> ""
            result + " " + optionName + " " + Chr(34) + item + Chr(34)
        EndIf
    Next

    ProcedureReturn result
EndProcedure

Procedure.s AppendPathList(currentList.s, newPath.s)
    newPath = Trim(newPath)
    If newPath = ""
        ProcedureReturn currentList
    EndIf
    If Trim(currentList) = ""
        ProcedureReturn newPath
    EndIf
    ProcedureReturn currentList + ";" + newPath
EndProcedure

Procedure BrowsePathIntoGadget(gadgetID.i, title.s, appendMode.i)
    Protected selected.s
    selected = OpenFileRequester(title, GetGadgetText(gadgetID), "All files|*.*", 0)
    If selected <> ""
        If appendMode
            SetGadgetText(gadgetID, AppendPathList(GetGadgetText(gadgetID), selected))
        Else
            SetGadgetText(gadgetID, selected)
        EndIf
    EndIf
EndProcedure

Procedure CreatePathIntoGadget(gadgetID.i, title.s, appendMode.i)
    Protected selected.s
    Protected file.i

    selected = SaveFileRequester(title, GetGadgetText(gadgetID), "All files|*.*", 0)
    If selected = ""
        ProcedureReturn
    EndIf

    file = CreateFile(#PB_Any, selected)
    If file = 0
        MessageRequester("Error", "Could not create file: " + selected)
        ProcedureReturn
    EndIf
    CloseFile(file)

    If appendMode
        SetGadgetText(gadgetID, AppendPathList(GetGadgetText(gadgetID), selected))
    Else
        SetGadgetText(gadgetID, selected)
    EndIf
EndProcedure

; Estado global da camada de persistencia. O banco armazena as preferencias
; para que a interface seja reconstruida com os ultimos valores usados.
Global gDatabase.i
Global gDatabaseReady.i
Global gDatabaseFile.s = ""
Global gSQLiteExeFile.s = ""

; Escapa aspas simples antes de gravar valores textuais em comandos SQL montados manualmente.
Procedure.s EscapeSQL(text.s)
ProcedureReturn ReplaceString(text, "'", "''")
EndProcedure

; --- Normalizacao das opcoes principais do emulador ---
Procedure.s NormalizeMachineMode(mode.s)
mode = UCase(Trim(mode))

Select mode
Case "MSX", "MSX 2", "MSX 2+"
ProcedureReturn mode
EndSelect

ProcedureReturn "MSX"
EndProcedure

Procedure.s GetMachineModeArg(mode.s)
Select NormalizeMachineMode(mode)
Case "MSX 2"
ProcedureReturn " -msx2"
Case "MSX 2+"
ProcedureReturn " -msx2+"
Default
ProcedureReturn " -msx1"
EndSelect
EndProcedure

Procedure.s NormalizeVideoStandard(std.s)
std = UCase(Trim(std))

Select std
Case "PAL", "NTSC"
ProcedureReturn std
EndSelect

ProcedureReturn "PAL"
EndProcedure

Procedure.s GetVideoStandardArg(std.s)
If NormalizeVideoStandard(std) = "NTSC"
ProcedureReturn " -ntsc"
EndIf
ProcedureReturn " -pal"
EndProcedure


Procedure.s NormalizeMonitorType(t.s)
    t = UCase(Trim(t))

    Select t
        Case "SEPIA"
            ProcedureReturn "SEPIA"
        Case "MONO", "MONOCROMATICO"
            ProcedureReturn "MONO"
        Case "GREEN", "VERDE"
            ProcedureReturn "GREEN"
        Case "AMBER", "AMBAR"
            ProcedureReturn "AMBER"
        Case "CMY"
            ProcedureReturn "CMY"
        Case "RGB"
            ProcedureReturn "RGB"
    EndSelect

    ProcedureReturn ""
EndProcedure

Procedure.s GetMonitorTypeArg(t.s)
    Select NormalizeMonitorType(t)
        Case "SEPIA"
            ProcedureReturn " -sepia"
        Case "MONO"
            ProcedureReturn " -mono"
        Case "GREEN"
            ProcedureReturn " -green"
        Case "AMBER"
            ProcedureReturn " -amber"
        Case "CMY"
            ProcedureReturn " -cmy"
        Case "RGB"
            ProcedureReturn " -rgb"
    EndSelect

    ProcedureReturn ""
EndProcedure

; Recalcula a linha de comando visivel na barra de status. Isso permite ao
; usuario conferir rapidamente quais parametros serao enviados ao fMSX.
Procedure UpdateStatusBar()
Protected homePath.s
Protected cmdLine.s
Protected fontInfo.s

If Not IsStatusBar(#StatusBar_Main)
ProcedureReturn
EndIf

EnsureUIFont()
fontInfo = GetRuntimeFontSourceCompact()

If Trim(gFMSXPath) = ""
StatusBarText(#StatusBar_Main, 0, "  Font: " + fontInfo + " | fMSX is not configured - open Tools > Setup")
ProcedureReturn
EndIf

homePath = GetPathPart(gFMSXPath)
cmdLine = Chr(34) + gFMSXPath + Chr(34) +
          " -home " + Chr(34) + homePath + Chr(34) +
          GetMachineModeArg(gFMSXMachineMode) +
          GetVideoStandardArg(gFMSXVideoStandard) +
          GetMonitorTypeArg(gFMSXMonitorType) +
          GetScaleFilterArg(gFMSXScaleFilter) +
          GetAutoFireArg(gFMSXAutoFire) +
          GetRamArg(gFMSXRamPages) +
          GetVRamArg(gFMSXVRamPages) +
          GetRomArg(gFMSXRomType1, gFMSXRomType2) +
          GetJoyArg(gFMSXJoyType1, gFMSXJoyType2) +
          GetDiskModeArg(gFMSXDiskMode) +
          GetSoundArg(gFMSXSoundQuality) +
          GetVerboseArg(gFMSXVerboseLevel) +
          GetSkipArg(gFMSXSkipPercent) +
          BuildSingleFileArg("-printer", gFMSXPrinterFile) +
          BuildSingleFileArg("-serial", gFMSXSerialFile) +
          BuildMultiFileArg("-diska", gFMSXDiskAFiles) +
          BuildMultiFileArg("-diskb", gFMSXDiskBFiles) +
          BuildSingleFileArg("-tape", gFMSXTapeFile) +
          BuildSingleFileArg("-font", gFMSXFontFile) +
          BuildSingleFileArg("-logsnd", gFMSXLogSndFile) +
          BuildSingleFileArg("-state", gFMSXStateFile)
If gFMSXForce4x3
    cmdLine + " -4x3"
EndIf
StatusBarText(#StatusBar_Main, 0, "  Font: " + fontInfo + " | " + cmdLine)
EndProcedure

; Converte o estado atual da interface/configuracao em parametros e executa o fMSX.
Procedure RunFMSX(selectedMode.s = "")
Protected homePath.s
Protected params.s
Protected program.i
Protected effectiveMode.s

If Trim(gFMSXPath) = ""
MessageRequester("Warning", "Set the fmsx.exe path in Tools > Setup before running.")
ProcedureReturn
EndIf

If FileSize(gFMSXPath) = -1
MessageRequester("Error", "fmsx.exe not found at the configured path.")
ProcedureReturn
EndIf

homePath = GetPathPart(gFMSXPath)
effectiveMode = Trim(selectedMode)
If effectiveMode = ""
effectiveMode = gFMSXMachineMode
EndIf
effectiveMode = NormalizeMachineMode(effectiveMode)
gFMSXMachineArg = GetMachineModeArg(effectiveMode)
If gFMSXForce4x3
    gFMSXForce4x3Arg = " -4x3"
Else
    gFMSXForce4x3Arg = ""
EndIf
gFMSXScaleFilterArg = GetScaleFilterArg(gFMSXScaleFilter)
gFMSXAutoFireArg = GetAutoFireArg(gFMSXAutoFire)
gFMSXRamArg = GetRamArg(gFMSXRamPages)
gFMSXVRamArg = GetVRamArg(gFMSXVRamPages)
gFMSXRomArg = GetRomArg(gFMSXRomType1, gFMSXRomType2)
gFMSXJoyArg = GetJoyArg(gFMSXJoyType1, gFMSXJoyType2)
gFMSXDiskArg = GetDiskModeArg(gFMSXDiskMode)
gFMSXSoundArg = GetSoundArg(gFMSXSoundQuality)
gFMSXVerboseArg = GetVerboseArg(gFMSXVerboseLevel)
gFMSXSkipArg = GetSkipArg(gFMSXSkipPercent)
gFMSXPrinterArg = BuildSingleFileArg("-printer", gFMSXPrinterFile)
gFMSXSerialArg = BuildSingleFileArg("-serial", gFMSXSerialFile)
gFMSXDiskAArg = BuildMultiFileArg("-diska", gFMSXDiskAFiles)
gFMSXDiskBArg = BuildMultiFileArg("-diskb", gFMSXDiskBFiles)
gFMSXTapeArg = BuildSingleFileArg("-tape", gFMSXTapeFile)
gFMSXFontArg = BuildSingleFileArg("-font", gFMSXFontFile)
gFMSXLogSndArg = BuildSingleFileArg("-logsnd", gFMSXLogSndFile)
gFMSXStateArg = BuildSingleFileArg("-state", gFMSXStateFile)
params = "-home " + Chr(34) + homePath + Chr(34) + gFMSXMachineArg + gFMSXVideoArg + gFMSXMonitorArg + gFMSXScaleFilterArg + gFMSXAutoFireArg + gFMSXRamArg + gFMSXVRamArg + gFMSXRomArg + gFMSXJoyArg + gFMSXDiskArg + gFMSXSoundArg + gFMSXVerboseArg + gFMSXSkipArg + gFMSXPrinterArg + gFMSXSerialArg + gFMSXDiskAArg + gFMSXDiskBArg + gFMSXTapeArg + gFMSXFontArg + gFMSXLogSndArg + gFMSXStateArg + gFMSXForce4x3Arg

program = RunProgram(gFMSXPath, params, homePath)
If program = 0
MessageRequester("Error", "Could not run fMSX with the selected options.")
EndIf
EndProcedure

; Procura o sqlite3.exe nos locais mais provaveis para manter o projeto portavel.
Procedure.s ResolveSQLiteExePath()
Protected candidate.s

candidate = GetPathPart(ProgramFilename()) + "sqlite3.exe"
If FileSize(candidate) <> -1
ProcedureReturn candidate
EndIf

candidate = GetPathPart(#PB_Compiler_File) + "sqlite3.exe"
If FileSize(candidate) <> -1
ProcedureReturn candidate
EndIf

candidate = GetCurrentDirectory() + "sqlite3.exe"
If FileSize(candidate) <> -1
ProcedureReturn candidate
EndIf

ProcedureReturn ""
EndProcedure

Procedure.s ResolveDatabasePath(sqliteExePath.s)
Protected candidate.s

candidate = GetPathPart(ProgramFilename()) + "bamsx.db"
If FileSize(candidate) <> -1
ProcedureReturn candidate
EndIf

candidate = GetPathPart(#PB_Compiler_File) + "bamsx.db"
If FileSize(candidate) <> -1
ProcedureReturn candidate
EndIf

candidate = GetCurrentDirectory() + "bamsx.db"
If FileSize(candidate) <> -1
ProcedureReturn candidate
EndIf

If sqliteExePath <> ""
ProcedureReturn GetPathPart(sqliteExePath) + "bamsx.db"
EndIf

ProcedureReturn GetPathPart(ProgramFilename()) + "bamsx.db"
EndProcedure

; Garante que o arquivo do banco exista antes da abertura via biblioteca SQLite.
; Se necessario, usa o sqlite3.exe para criar a estrutura minima inicial.
Procedure EnsureDatabaseWithSQLiteExe()
Protected params.s
Protected sqlCommand.s
Protected searchPaths.s
Protected program.i

gSQLiteExeFile = ResolveSQLiteExePath()
gDatabaseFile = ResolveDatabasePath(gSQLiteExeFile)

If FileSize(gDatabaseFile) <> -1
ProcedureReturn #True
EndIf

If gSQLiteExeFile = ""
searchPaths = GetPathPart(ProgramFilename()) + Chr(10) + GetPathPart(#PB_Compiler_File) + Chr(10) + GetCurrentDirectory()
MessageRequester("Error", "sqlite3.exe not found. Checked locations:" + Chr(10) + searchPaths)
ProcedureReturn #False
EndIf

sqlCommand = "CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT);"
params = Chr(34) + gDatabaseFile + Chr(34) + " " + Chr(34) + sqlCommand + Chr(34)

program = RunProgram(gSQLiteExeFile, params, GetPathPart(gSQLiteExeFile), #PB_Program_Wait)
If program = 0
MessageRequester("Error", "Could not run sqlite3.exe to create the database.")
ProcedureReturn #False
EndIf

If ProgramExitCode(program) <> 0
CloseProgram(program)
MessageRequester("Error", "sqlite3.exe returned an error while creating the database.")
ProcedureReturn #False
EndIf

CloseProgram(program)

If FileSize(gDatabaseFile) = -1
MessageRequester("Error", "The bamsx.db database was not created by sqlite3.exe.")
ProcedureReturn #False
EndIf

ProcedureReturn #True
EndProcedure

; Inicializa a conexao SQLite usada pelas rotinas de carga e salvamento.
Procedure InitDatabase()
If EnsureDatabaseWithSQLiteExe() = #False
ProcedureReturn #False
EndIf

gDatabase = OpenDatabase(#PB_Any, gDatabaseFile, "", "")
If gDatabase = 0
MessageRequester("Error", "Could not open/create the SQLite database.")
ProcedureReturn #False
EndIf

If DatabaseUpdate(gDatabase, "CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT)") = 0
MessageRequester("Error", "Could not initialize the configuration table.")
CloseDatabase(gDatabase)
gDatabase = 0
ProcedureReturn #False
EndIf

ProcedureReturn #True
EndProcedure

; Carrega do banco todas as preferencias persistidas e reconstrui os argumentos
; derivados para manter a UI e a linha de comando em sincronia.
Procedure LoadSettings()
    If gDatabase = 0
        ProcedureReturn
    EndIf

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_path'")
        If NextDatabaseRow(gDatabase)
            gFMSXPath = GetDatabaseString(gDatabase, 0)
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_machine_mode'")
        If NextDatabaseRow(gDatabase)
            gFMSXMachineMode = NormalizeMachineMode(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXMachineArg = GetMachineModeArg(gFMSXMachineMode)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_video_standard'")
        If NextDatabaseRow(gDatabase)
            gFMSXVideoStandard = NormalizeVideoStandard(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXVideoArg = GetVideoStandardArg(gFMSXVideoStandard)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_monitor_type'")
        If NextDatabaseRow(gDatabase)
            gFMSXMonitorType = NormalizeMonitorType(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXMonitorArg = GetMonitorTypeArg(gFMSXMonitorType)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_scale_filter'")
        If NextDatabaseRow(gDatabase)
            gFMSXScaleFilter = NormalizeScaleFilter(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXScaleFilterArg = GetScaleFilterArg(gFMSXScaleFilter)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_autofire'")
        If NextDatabaseRow(gDatabase)
            gFMSXAutoFire = NormalizeAutoFire(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXAutoFireArg = GetAutoFireArg(gFMSXAutoFire)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_ram_pages'")
        If NextDatabaseRow(gDatabase)
            gFMSXRamPages = NormalizeRamPages(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXRamArg = GetRamArg(gFMSXRamPages)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_vram_pages'")
        If NextDatabaseRow(gDatabase)
            gFMSXVRamPages = NormalizeVRamPages(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXVRamArg = GetVRamArg(gFMSXVRamPages)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_rom_type_1'")
        If NextDatabaseRow(gDatabase)
            gFMSXRomType1 = NormalizeRomType(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_rom_type_2'")
        If NextDatabaseRow(gDatabase)
            gFMSXRomType2 = NormalizeRomType(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXRomArg = GetRomArg(gFMSXRomType1, gFMSXRomType2)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_joy_type_1'")
        If NextDatabaseRow(gDatabase)
            gFMSXJoyType1 = NormalizeJoyType(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_joy_type_2'")
        If NextDatabaseRow(gDatabase)
            gFMSXJoyType2 = NormalizeJoyType(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXJoyArg = GetJoyArg(gFMSXJoyType1, gFMSXJoyType2)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_disk_mode'")
        If NextDatabaseRow(gDatabase)
            gFMSXDiskMode = NormalizeDiskMode(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXDiskArg = GetDiskModeArg(gFMSXDiskMode)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_sound_quality'")
        If NextDatabaseRow(gDatabase)
            gFMSXSoundQuality = NormalizeSoundQuality(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXSoundArg = GetSoundArg(gFMSXSoundQuality)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_verbose_level'")
        If NextDatabaseRow(gDatabase)
            gFMSXVerboseLevel = NormalizeVerboseLevel(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXVerboseArg = GetVerboseArg(gFMSXVerboseLevel)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_skip_percent'")
        If NextDatabaseRow(gDatabase)
            gFMSXSkipPercent = NormalizeSkipPercent(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXSkipArg = GetSkipArg(gFMSXSkipPercent)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_printer_file'")
        If NextDatabaseRow(gDatabase)
            gFMSXPrinterFile = Trim(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXPrinterArg = BuildSingleFileArg("-printer", gFMSXPrinterFile)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_serial_file'")
        If NextDatabaseRow(gDatabase)
            gFMSXSerialFile = Trim(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXSerialArg = BuildSingleFileArg("-serial", gFMSXSerialFile)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_diska_files'")
        If NextDatabaseRow(gDatabase)
            gFMSXDiskAFiles = Trim(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXDiskAArg = BuildMultiFileArg("-diska", gFMSXDiskAFiles)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_diskb_files'")
        If NextDatabaseRow(gDatabase)
            gFMSXDiskBFiles = Trim(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXDiskBArg = BuildMultiFileArg("-diskb", gFMSXDiskBFiles)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_tape_file'")
        If NextDatabaseRow(gDatabase)
            gFMSXTapeFile = Trim(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXTapeArg = BuildSingleFileArg("-tape", gFMSXTapeFile)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_font_file'")
        If NextDatabaseRow(gDatabase)
            gFMSXFontFile = Trim(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXFontArg = BuildSingleFileArg("-font", gFMSXFontFile)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_logsnd_file'")
        If NextDatabaseRow(gDatabase)
            gFMSXLogSndFile = Trim(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXLogSndArg = BuildSingleFileArg("-logsnd", gFMSXLogSndFile)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_state_file'")
        If NextDatabaseRow(gDatabase)
            gFMSXStateFile = Trim(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    gFMSXStateArg = BuildSingleFileArg("-state", gFMSXStateFile)

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'fmsx_force_4x3'")
        If NextDatabaseRow(gDatabase)
            gFMSXForce4x3 = Val(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
    If gFMSXForce4x3
        gFMSXForce4x3Arg = " -4x3"
    Else
        gFMSXForce4x3Arg = ""
    EndIf

    If DatabaseQuery(gDatabase, "SELECT value FROM settings WHERE key = 'ui_theme_name'")
        If NextDatabaseRow(gDatabase)
            gThemeName = NormalizeThemeName(GetDatabaseString(gDatabase, 0))
        EndIf
        FinishDatabaseQuery(gDatabase)
    EndIf
EndProcedure

; As procedures SaveFMSX* isolam a persistencia de cada grupo de configuracao.
; Esse desenho evita espalhar SQL pelo loop de eventos e facilita manutencao.
Procedure SaveFMSXScaleFilter(filter.s)
    Protected escapedF.s

    If gDatabase = 0
        ProcedureReturn
    EndIf

    filter = NormalizeScaleFilter(filter)
    escapedF = EscapeSQL(filter)

    If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_scale_filter'")
        DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_scale_filter', '" + escapedF + "')")
    EndIf
EndProcedure

Procedure SaveFMSXAutoFire(enabled.i)
If gDatabase = 0
ProcedureReturn
EndIf

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_autofire'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_autofire', '" + Str(Bool(enabled)) + "')")
EndIf
EndProcedure

Procedure SaveFMSXRamPages(pages.i)
If gDatabase = 0
ProcedureReturn
EndIf

If pages < 1
pages = 4
EndIf

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_ram_pages'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_ram_pages', '" + Str(pages) + "')")
EndIf
EndProcedure

Procedure SaveFMSXVRamPages(pages.i)
If gDatabase = 0
ProcedureReturn
EndIf

If pages < 1
pages = 2
EndIf

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_vram_pages'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_vram_pages', '" + Str(pages) + "')")
EndIf
EndProcedure

Procedure SaveFMSXRomType(slot.i, romType.i)
Protected keyName.s

If gDatabase = 0
ProcedureReturn
EndIf

If slot = 2
keyName = "fmsx_rom_type_2"
Else
keyName = "fmsx_rom_type_1"
EndIf

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = '" + keyName + "'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('" + keyName + "', '" + Str(romType) + "')")
EndIf
EndProcedure

Procedure SaveFMSXJoyType(slot.i, joyType.i)
Protected keyName.s

If gDatabase = 0
ProcedureReturn
EndIf

If slot = 2
keyName = "fmsx_joy_type_2"
Else
keyName = "fmsx_joy_type_1"
EndIf

joyType = NormalizeJoyType(Str(joyType))
If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = '" + keyName + "'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('" + keyName + "', '" + Str(joyType) + "')")
EndIf
EndProcedure

Procedure SaveFMSXDiskMode(mode.s)
Protected escapedMode.s

If gDatabase = 0
ProcedureReturn
EndIf

mode = NormalizeDiskMode(mode)
escapedMode = EscapeSQL(mode)

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_disk_mode'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_disk_mode', '" + escapedMode + "')")
EndIf
EndProcedure

Procedure SaveFMSXSoundQuality(quality.i)
If gDatabase = 0
ProcedureReturn
EndIf

quality = NormalizeSoundQuality(Str(quality))
If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_sound_quality'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_sound_quality', '" + Str(quality) + "')")
EndIf
EndProcedure

Procedure SaveFMSXVerboseLevel(level.i)
If gDatabase = 0
ProcedureReturn
EndIf

level = NormalizeVerboseLevel(Str(level))
If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_verbose_level'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_verbose_level', '" + Str(level) + "')")
EndIf
EndProcedure

Procedure SaveFMSXSkipPercent(percent.i)
If gDatabase = 0
ProcedureReturn
EndIf

percent = NormalizeSkipPercent(Str(percent))
If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_skip_percent'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_skip_percent', '" + Str(percent) + "')")
EndIf
EndProcedure

Procedure SaveFMSXTextSetting(keyName.s, value.s)
Protected escapedValue.s

If gDatabase = 0
ProcedureReturn
EndIf

escapedValue = EscapeSQL(value)
If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = '" + keyName + "'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('" + keyName + "', '" + escapedValue + "')")
EndIf
EndProcedure

Procedure SaveFMSXPath(path.s)
Protected escapedPath.s

If gDatabase = 0
ProcedureReturn
EndIf

escapedPath = EscapeSQL(path)

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_path'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_path', '" + escapedPath + "')")
EndIf
EndProcedure

Procedure SaveFMSXMachineMode(mode.s)
Protected escapedMode.s

If gDatabase = 0
ProcedureReturn
EndIf

mode = NormalizeMachineMode(mode)
escapedMode = EscapeSQL(mode)

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_machine_mode'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_machine_mode', '" + escapedMode + "')")
EndIf
EndProcedure

Procedure SaveFMSXVideoStandard(std.s)
Protected escapedStd.s

If gDatabase = 0
ProcedureReturn
EndIf

std = NormalizeVideoStandard(std)
escapedStd = EscapeSQL(std)

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_video_standard'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_video_standard', '" + escapedStd + "')")
EndIf
EndProcedure

Procedure SaveFMSXMonitorType(t.s)
Protected escapedT.s

If gDatabase = 0
ProcedureReturn
EndIf

t = NormalizeMonitorType(t)
escapedT = EscapeSQL(t)

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_monitor_type'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_monitor_type', '" + escapedT + "')")
EndIf
EndProcedure

Procedure SaveFMSXForce4x3(force.i)
If gDatabase = 0
ProcedureReturn
EndIf

If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'fmsx_force_4x3'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('fmsx_force_4x3', '" + Str(force) + "')")
EndIf
EndProcedure

Procedure SaveUITheme(themeName.s)
Protected escapedTheme.s

If gDatabase = 0
ProcedureReturn
EndIf

themeName = NormalizeThemeName(themeName)
escapedTheme = EscapeSQL(themeName)
If DatabaseUpdate(gDatabase, "DELETE FROM settings WHERE key = 'ui_theme_name'")
DatabaseUpdate(gDatabase, "INSERT INTO settings(key, value) VALUES('ui_theme_name', '" + escapedTheme + "')")
EndIf
EndProcedure

; Monta a janela de configuracao com os valores atuais ja refletidos nos combos,
; textos e checkboxes. A janela funciona como editor do estado global.
Procedure OpenSetupWindow()
Protected selectedIndex.i
Protected monoIndex.i
Protected scaleIndex.i
Protected autoIndex.i
Protected ramIndex.i
Protected vramIndex.i
Protected rom1Index.i
Protected rom2Index.i
Protected joy1Index.i
Protected joy2Index.i
Protected diskIndex.i
Protected soundIndex.i
Protected verboseIndex.i
Protected skipIndex.i
Protected themeIndex.i

If IsWindow(#Window_Setup)
SetActiveWindow(#Window_Setup)
ProcedureReturn
EndIf

If OpenWindow(#Window_Setup, 0, 0, 1120, 760, "Setup", #PB_Window_SystemMenu | #PB_Window_WindowCentered, WindowID(#Window_Main))
FrameGadget(#PB_Any, 8, 50, 1104, 170, "Core Configuration")
FrameGadget(#PB_Any, 8, 228, 1104, 210, "Hardware and Performance")
FrameGadget(#PB_Any, 8, 446, 1104, 270, "Media and Peripheral Files")

TextGadget(#Gadget_Setup_PathLabel, 18, 76, 180, 22, "fmsx.exe path:")
StringGadget(#Gadget_Setup_PathInput, 18, 102, 860, 24, gFMSXPath)
ButtonGadget(#Gadget_Setup_Browse, 886, 102, 96, 24, "Browse")

TextGadget(#Gadget_Setup_ModeLabel, 18, 138, 160, 22, "Machine mode:")
ComboBoxGadget(#Gadget_Setup_ModeCombo, 18, 164, 160, 24)
AddGadgetItem(#Gadget_Setup_ModeCombo, -1, "MSX")
AddGadgetItem(#Gadget_Setup_ModeCombo, -1, "MSX 2")
AddGadgetItem(#Gadget_Setup_ModeCombo, -1, "MSX 2+")

selectedIndex = 0
Select gFMSXMachineMode
Case "MSX 2"
selectedIndex = 1
Case "MSX 2+"
selectedIndex = 2
EndSelect
SetGadgetState(#Gadget_Setup_ModeCombo, selectedIndex)

TextGadget(#Gadget_Setup_ThemeLabel, 196, 138, 110, 22, "UI theme:")
ComboBoxGadget(#Gadget_Setup_ThemeCombo, 196, 164, 200, 24)
PopulateThemeCombo(#Gadget_Setup_ThemeCombo)
themeIndex = GetThemeComboIndex(gThemeName)
SetGadgetState(#Gadget_Setup_ThemeCombo, themeIndex)

TextGadget(#Gadget_Setup_VideoLabel, 414, 138, 112, 22, "Video standard:")
ComboBoxGadget(#Gadget_Setup_VideoCombo, 414, 164, 120, 24)
AddGadgetItem(#Gadget_Setup_VideoCombo, -1, "PAL")
AddGadgetItem(#Gadget_Setup_VideoCombo, -1, "NTSC")
SetGadgetState(#Gadget_Setup_VideoCombo, Bool(gFMSXVideoStandard = "NTSC"))

TextGadget(#Gadget_Setup_MonoLabel, 552, 138, 130, 22, "Monitor type:")
ComboBoxGadget(#Gadget_Setup_MonoCombo, 552, 164, 180, 24)

AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "None (color)")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "Sepia")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "Monochrome")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "Green")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "Amber")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "CMY")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "RGB")

monoIndex = 0
Select gFMSXMonitorType
    Case "SEPIA" : monoIndex = 1
    Case "MONO"  : monoIndex = 2
    Case "GREEN" : monoIndex = 3
    Case "AMBER" : monoIndex = 4
    Case "CMY"   : monoIndex = 5
    Case "RGB"   : monoIndex = 6
EndSelect
SetGadgetState(#Gadget_Setup_MonoCombo, monoIndex)

TextGadget(#Gadget_Setup_ScaleLabel, 18, 254, 180, 22, "Scale filter:")
ComboBoxGadget(#Gadget_Setup_ScaleCombo, 18, 280, 160, 24)
AddGadgetItem(#Gadget_Setup_ScaleCombo, -1, "None")
AddGadgetItem(#Gadget_Setup_ScaleCombo, -1, "Linear")
AddGadgetItem(#Gadget_Setup_ScaleCombo, -1, "Soft")
AddGadgetItem(#Gadget_Setup_ScaleCombo, -1, "Eagle")
AddGadgetItem(#Gadget_Setup_ScaleCombo, -1, "EPX")
AddGadgetItem(#Gadget_Setup_ScaleCombo, -1, "Scale2x")
scaleIndex = 0
Select LCase(gFMSXScaleFilter)
    Case "linear" : scaleIndex = 1
    Case "soft"   : scaleIndex = 2
    Case "eagle"  : scaleIndex = 3
    Case "epx"    : scaleIndex = 4
    Case "scale2x": scaleIndex = 5
EndSelect
SetGadgetState(#Gadget_Setup_ScaleCombo, scaleIndex)

TextGadget(#Gadget_Setup_AutoLabel, 196, 254, 112, 22, "Auto fire:")
ComboBoxGadget(#Gadget_Setup_AutoCombo, 196, 280, 120, 24)
AddGadgetItem(#Gadget_Setup_AutoCombo, -1, "NoAuto")
AddGadgetItem(#Gadget_Setup_AutoCombo, -1, "Auto")
autoIndex = Bool(gFMSXAutoFire)
SetGadgetState(#Gadget_Setup_AutoCombo, autoIndex)

CheckBoxGadget(#Gadget_Setup_4x3, 334, 282, 160, 22, "Force 4:3")
SetGadgetState(#Gadget_Setup_4x3, gFMSXForce4x3)

TextGadget(#Gadget_Setup_RAMLabel, 470, 254, 160, 22, "RAM (16K pages):")
ComboBoxGadget(#Gadget_Setup_RAMCombo, 470, 280, 90, 24)
AddGadgetItem(#Gadget_Setup_RAMCombo, -1, "4")
AddGadgetItem(#Gadget_Setup_RAMCombo, -1, "8")
AddGadgetItem(#Gadget_Setup_RAMCombo, -1, "16")
AddGadgetItem(#Gadget_Setup_RAMCombo, -1, "32")
ramIndex = 0
Select gFMSXRamPages
Case 8  : ramIndex = 1
Case 16 : ramIndex = 2
Case 32 : ramIndex = 3
EndSelect
SetGadgetState(#Gadget_Setup_RAMCombo, ramIndex)

TextGadget(#Gadget_Setup_VRAMLabel, 578, 254, 170, 22, "VRAM (16K pages):")
ComboBoxGadget(#Gadget_Setup_VRAMCombo, 578, 280, 90, 24)
AddGadgetItem(#Gadget_Setup_VRAMCombo, -1, "2")
AddGadgetItem(#Gadget_Setup_VRAMCombo, -1, "8")
AddGadgetItem(#Gadget_Setup_VRAMCombo, -1, "16")
AddGadgetItem(#Gadget_Setup_VRAMCombo, -1, "32")
vramIndex = 0
Select gFMSXVRamPages
Case 8  : vramIndex = 1
Case 16 : vramIndex = 2
Case 32 : vramIndex = 3
EndSelect
SetGadgetState(#Gadget_Setup_VRAMCombo, vramIndex)

TextGadget(#Gadget_Setup_ROM1Label, 18, 316, 140, 22, "ROM mapper #1:")
ComboBoxGadget(#Gadget_Setup_ROM1Combo, 18, 342, 190, 24)
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "None")
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "0 - Generic 8kB")
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "1 - Generic 16kB")
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "2 - Konami5 8kB")
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "3 - Konami4 8kB")
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "4 - ASCII 8kB")
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "5 - ASCII 16kB")
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "6 - GameMaster2")
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "7 - FMPAC")
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "8 - Auto guess")
rom1Index = 0
If gFMSXRomType1 >= 0 And gFMSXRomType1 <= 8
    rom1Index = gFMSXRomType1 + 1
EndIf
SetGadgetState(#Gadget_Setup_ROM1Combo, rom1Index)

TextGadget(#Gadget_Setup_ROM2Label, 222, 316, 140, 22, "ROM mapper #2:")
ComboBoxGadget(#Gadget_Setup_ROM2Combo, 222, 342, 190, 24)
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "None")
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "0 - Generic 8kB")
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "1 - Generic 16kB")
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "2 - Konami5 8kB")
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "3 - Konami4 8kB")
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "4 - ASCII 8kB")
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "5 - ASCII 16kB")
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "6 - GameMaster2")
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "7 - FMPAC")
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "8 - Auto guess")
rom2Index = 0
If gFMSXRomType2 >= 0 And gFMSXRomType2 <= 8
    rom2Index = gFMSXRomType2 + 1
EndIf
SetGadgetState(#Gadget_Setup_ROM2Combo, rom2Index)

TextGadget(#Gadget_Setup_Joy1Label, 426, 316, 140, 22, "Joystick #1:")
ComboBoxGadget(#Gadget_Setup_Joy1Combo, 426, 342, 170, 24)
AddGadgetItem(#Gadget_Setup_Joy1Combo, -1, "0 - No joystick")
AddGadgetItem(#Gadget_Setup_Joy1Combo, -1, "1 - Normal joystick")
AddGadgetItem(#Gadget_Setup_Joy1Combo, -1, "2 - Mouse joystick")
AddGadgetItem(#Gadget_Setup_Joy1Combo, -1, "3 - Real mouse")
joy1Index = NormalizeJoyType(Str(gFMSXJoyType1))
SetGadgetState(#Gadget_Setup_Joy1Combo, joy1Index)

TextGadget(#Gadget_Setup_Joy2Label, 610, 316, 140, 22, "Joystick #2:")
ComboBoxGadget(#Gadget_Setup_Joy2Combo, 610, 342, 170, 24)
AddGadgetItem(#Gadget_Setup_Joy2Combo, -1, "0 - No joystick")
AddGadgetItem(#Gadget_Setup_Joy2Combo, -1, "1 - Normal joystick")
AddGadgetItem(#Gadget_Setup_Joy2Combo, -1, "2 - Mouse joystick")
AddGadgetItem(#Gadget_Setup_Joy2Combo, -1, "3 - Real mouse")
joy2Index = NormalizeJoyType(Str(gFMSXJoyType2))
SetGadgetState(#Gadget_Setup_Joy2Combo, joy2Index)

TextGadget(#Gadget_Setup_DiskLabel, 686, 254, 180, 22, "DiskROM access:")
ComboBoxGadget(#Gadget_Setup_DiskCombo, 686, 280, 140, 24)
AddGadgetItem(#Gadget_Setup_DiskCombo, -1, "WD1793")
AddGadgetItem(#Gadget_Setup_DiskCombo, -1, "SIMBDOS")
diskIndex = Bool(NormalizeDiskMode(gFMSXDiskMode) = "SIMBDOS")
SetGadgetState(#Gadget_Setup_DiskCombo, diskIndex)

TextGadget(#Gadget_Setup_SoundLabel, 844, 254, 120, 22, "Audio (Hz):")
ComboBoxGadget(#Gadget_Setup_SoundCombo, 844, 280, 120, 24)
AddGadgetItem(#Gadget_Setup_SoundCombo, -1, "0 - No sound")
AddGadgetItem(#Gadget_Setup_SoundCombo, -1, "11025")
AddGadgetItem(#Gadget_Setup_SoundCombo, -1, "22050")
AddGadgetItem(#Gadget_Setup_SoundCombo, -1, "44100")
AddGadgetItem(#Gadget_Setup_SoundCombo, -1, "48000")
soundIndex = 3
Select gFMSXSoundQuality
    Case 0     : soundIndex = 0
    Case 11025 : soundIndex = 1
    Case 22050 : soundIndex = 2
    Case 44100 : soundIndex = 3
    Case 48000 : soundIndex = 4
EndSelect
SetGadgetState(#Gadget_Setup_SoundCombo, soundIndex)

TextGadget(#Gadget_Setup_VerboseLabel, 794, 316, 210, 22, "Debug verbosity:")
ComboBoxGadget(#Gadget_Setup_VerboseCombo, 794, 342, 298, 24)
AddGadgetItem(#Gadget_Setup_VerboseCombo, -1, "0 - Silent")
AddGadgetItem(#Gadget_Setup_VerboseCombo, -1, "1 - Startup messages")
AddGadgetItem(#Gadget_Setup_VerboseCombo, -1, "2 - V9938 ops")
AddGadgetItem(#Gadget_Setup_VerboseCombo, -1, "4 - Disk/Tape")
AddGadgetItem(#Gadget_Setup_VerboseCombo, -1, "8 - Memory")
AddGadgetItem(#Gadget_Setup_VerboseCombo, -1, "16 - Illegal Z80 ops")
verboseIndex = 1
Select gFMSXVerboseLevel
    Case 0  : verboseIndex = 0
    Case 1  : verboseIndex = 1
    Case 2  : verboseIndex = 2
    Case 4  : verboseIndex = 3
    Case 8  : verboseIndex = 4
    Case 16 : verboseIndex = 5
EndSelect
SetGadgetState(#Gadget_Setup_VerboseCombo, verboseIndex)

TextGadget(#Gadget_Setup_SkipLabel, 972, 254, 120, 22, "Frameskip (%):")
ComboBoxGadget(#Gadget_Setup_SkipCombo, 972, 280, 120, 24)
AddGadgetItem(#Gadget_Setup_SkipCombo, -1, "0")
AddGadgetItem(#Gadget_Setup_SkipCombo, -1, "10")
AddGadgetItem(#Gadget_Setup_SkipCombo, -1, "25")
AddGadgetItem(#Gadget_Setup_SkipCombo, -1, "33")
AddGadgetItem(#Gadget_Setup_SkipCombo, -1, "50")
AddGadgetItem(#Gadget_Setup_SkipCombo, -1, "66")
AddGadgetItem(#Gadget_Setup_SkipCombo, -1, "75")
skipIndex = 2
Select gFMSXSkipPercent
    Case 0  : skipIndex = 0
    Case 10 : skipIndex = 1
    Case 25 : skipIndex = 2
    Case 33 : skipIndex = 3
    Case 50 : skipIndex = 4
    Case 66 : skipIndex = 5
    Case 75 : skipIndex = 6
EndSelect
SetGadgetState(#Gadget_Setup_SkipCombo, skipIndex)

TextGadget(#Gadget_Setup_PrinterLabel, 18, 472, 150, 22, "Printer file:")
StringGadget(#Gadget_Setup_PrinterInput, 18, 494, 420, 24, gFMSXPrinterFile)
ButtonGadget(#Gadget_Setup_PrinterBrowse, 446, 494, 72, 24, "Browse")
ButtonGadget(#Gadget_Setup_PrinterCreate, 524, 494, 72, 24, "Create")

TextGadget(#Gadget_Setup_SerialLabel, 562, 472, 150, 22, "Serial file:")
StringGadget(#Gadget_Setup_SerialInput, 562, 494, 420, 24, gFMSXSerialFile)
ButtonGadget(#Gadget_Setup_SerialBrowse, 990, 494, 60, 24, "Browse")
ButtonGadget(#Gadget_Setup_SerialCreate, 1056, 494, 50, 24, "Create")

TextGadget(#Gadget_Setup_DiskALabel, 18, 528, 240, 22, "Disk A files (; for multiple):")
StringGadget(#Gadget_Setup_DiskAInput, 18, 550, 420, 24, gFMSXDiskAFiles)
ButtonGadget(#Gadget_Setup_DiskABrowse, 446, 550, 72, 24, "Browse")
ButtonGadget(#Gadget_Setup_DiskACreate, 524, 550, 72, 24, "Create")

TextGadget(#Gadget_Setup_DiskBLabel, 562, 528, 240, 22, "Disk B files (; for multiple):")
StringGadget(#Gadget_Setup_DiskBInput, 562, 550, 420, 24, gFMSXDiskBFiles)
ButtonGadget(#Gadget_Setup_DiskBBrowse, 990, 550, 60, 24, "Browse")
ButtonGadget(#Gadget_Setup_DiskBCreate, 1056, 550, 50, 24, "Create")

TextGadget(#Gadget_Setup_TapeLabel, 18, 584, 150, 22, "Tape file:")
StringGadget(#Gadget_Setup_TapeInput, 18, 606, 420, 24, gFMSXTapeFile)
ButtonGadget(#Gadget_Setup_TapeBrowse, 446, 606, 72, 24, "Browse")
ButtonGadget(#Gadget_Setup_TapeCreate, 524, 606, 72, 24, "Create")

TextGadget(#Gadget_Setup_FontLabel, 562, 584, 150, 22, "Font file:")
StringGadget(#Gadget_Setup_FontInput, 562, 606, 420, 24, gFMSXFontFile)
ButtonGadget(#Gadget_Setup_FontBrowse, 990, 606, 60, 24, "Browse")
ButtonGadget(#Gadget_Setup_FontCreate, 1056, 606, 50, 24, "Create")

TextGadget(#Gadget_Setup_LogSndLabel, 18, 640, 180, 22, "Soundtrack log file:")
StringGadget(#Gadget_Setup_LogSndInput, 18, 662, 420, 24, gFMSXLogSndFile)
ButtonGadget(#Gadget_Setup_LogSndBrowse, 446, 662, 72, 24, "Browse")
ButtonGadget(#Gadget_Setup_LogSndCreate, 524, 662, 72, 24, "Create")

TextGadget(#Gadget_Setup_StateLabel, 562, 640, 150, 22, "State file:")
StringGadget(#Gadget_Setup_StateInput, 562, 662, 420, 24, gFMSXStateFile)
ButtonGadget(#Gadget_Setup_StateBrowse, 990, 662, 60, 24, "Browse")
ButtonGadget(#Gadget_Setup_StateCreate, 1056, 662, 50, 24, "Create")

ButtonGadget(#Gadget_Setup_Save, 934, 14, 84, 28, "Save")
ButtonGadget(#Gadget_Setup_Cancel, 1024, 14, 86, 28, "Close")

ApplyThemeToSetupWindow()
EndIf
EndProcedure

; Centraliza o tratamento dos botoes da janela Setup, incluindo selecao de
; arquivos, criacao de caminhos e persistencia final quando o usuario salva.
Procedure HandleSetupGadgetEvent(eventGadget.i)
Protected selectedFile.s

Select eventGadget
Case #Gadget_Setup_Browse
selectedFile = OpenFileRequester("Select the fMSX executable", gFMSXPath, "Executable|fmsx.exe;*.exe|All files|*.*", 0)
If selectedFile <> ""
SetGadgetText(#Gadget_Setup_PathInput, selectedFile)
EndIf

Case #Gadget_Setup_PrinterBrowse
BrowsePathIntoGadget(#Gadget_Setup_PrinterInput, "Select printer file", #False)
Case #Gadget_Setup_PrinterCreate
CreatePathIntoGadget(#Gadget_Setup_PrinterInput, "Create printer file", #False)

Case #Gadget_Setup_SerialBrowse
BrowsePathIntoGadget(#Gadget_Setup_SerialInput, "Select serial file", #False)
Case #Gadget_Setup_SerialCreate
CreatePathIntoGadget(#Gadget_Setup_SerialInput, "Create serial file", #False)

Case #Gadget_Setup_DiskABrowse
BrowsePathIntoGadget(#Gadget_Setup_DiskAInput, "Select image for drive A:", #True)
Case #Gadget_Setup_DiskACreate
CreatePathIntoGadget(#Gadget_Setup_DiskAInput, "Create image for drive A:", #True)

Case #Gadget_Setup_DiskBBrowse
BrowsePathIntoGadget(#Gadget_Setup_DiskBInput, "Select image for drive B:", #True)
Case #Gadget_Setup_DiskBCreate
CreatePathIntoGadget(#Gadget_Setup_DiskBInput, "Create image for drive B:", #True)

Case #Gadget_Setup_TapeBrowse
BrowsePathIntoGadget(#Gadget_Setup_TapeInput, "Select tape file", #False)
Case #Gadget_Setup_TapeCreate
CreatePathIntoGadget(#Gadget_Setup_TapeInput, "Create tape file", #False)

Case #Gadget_Setup_FontBrowse
BrowsePathIntoGadget(#Gadget_Setup_FontInput, "Select font file", #False)
Case #Gadget_Setup_FontCreate
CreatePathIntoGadget(#Gadget_Setup_FontInput, "Create font file", #False)

Case #Gadget_Setup_LogSndBrowse
BrowsePathIntoGadget(#Gadget_Setup_LogSndInput, "Select sound log file", #False)
Case #Gadget_Setup_LogSndCreate
CreatePathIntoGadget(#Gadget_Setup_LogSndInput, "Create sound log file", #False)

Case #Gadget_Setup_StateBrowse
BrowsePathIntoGadget(#Gadget_Setup_StateInput, "Select state file", #False)
Case #Gadget_Setup_StateCreate
CreatePathIntoGadget(#Gadget_Setup_StateInput, "Create state file", #False)

Case #Gadget_Setup_Save

gFMSXPath = Trim(GetGadgetText(#Gadget_Setup_PathInput))
gFMSXMachineMode = NormalizeMachineMode(GetGadgetText(#Gadget_Setup_ModeCombo))
gFMSXMachineArg = GetMachineModeArg(gFMSXMachineMode)
gFMSXVideoStandard = NormalizeVideoStandard(GetGadgetText(#Gadget_Setup_VideoCombo))
gFMSXVideoArg = GetVideoStandardArg(gFMSXVideoStandard)
gFMSXMonitorType = NormalizeMonitorType(GetGadgetText(#Gadget_Setup_MonoCombo))
gFMSXMonitorArg = GetMonitorTypeArg(gFMSXMonitorType)
gFMSXScaleFilter = NormalizeScaleFilter(GetGadgetText(#Gadget_Setup_ScaleCombo))
gFMSXScaleFilterArg = GetScaleFilterArg(gFMSXScaleFilter)
gFMSXAutoFire = NormalizeAutoFire(GetGadgetText(#Gadget_Setup_AutoCombo))
gFMSXAutoFireArg = GetAutoFireArg(gFMSXAutoFire)
gFMSXRamPages = NormalizeRamPages(GetGadgetText(#Gadget_Setup_RAMCombo))
gFMSXRamArg = GetRamArg(gFMSXRamPages)
gFMSXVRamPages = NormalizeVRamPages(GetGadgetText(#Gadget_Setup_VRAMCombo))
gFMSXVRamArg = GetVRamArg(gFMSXVRamPages)
gFMSXRomType1 = NormalizeRomType(GetGadgetText(#Gadget_Setup_ROM1Combo))
gFMSXRomType2 = NormalizeRomType(GetGadgetText(#Gadget_Setup_ROM2Combo))
gFMSXRomArg = GetRomArg(gFMSXRomType1, gFMSXRomType2)
gFMSXJoyType1 = NormalizeJoyType(GetGadgetText(#Gadget_Setup_Joy1Combo))
gFMSXJoyType2 = NormalizeJoyType(GetGadgetText(#Gadget_Setup_Joy2Combo))
gFMSXJoyArg = GetJoyArg(gFMSXJoyType1, gFMSXJoyType2)
gFMSXDiskMode = NormalizeDiskMode(GetGadgetText(#Gadget_Setup_DiskCombo))
gFMSXDiskArg = GetDiskModeArg(gFMSXDiskMode)
gFMSXSoundQuality = NormalizeSoundQuality(GetGadgetText(#Gadget_Setup_SoundCombo))
gFMSXSoundArg = GetSoundArg(gFMSXSoundQuality)
gFMSXVerboseLevel = NormalizeVerboseLevel(GetGadgetText(#Gadget_Setup_VerboseCombo))
gFMSXVerboseArg = GetVerboseArg(gFMSXVerboseLevel)
gFMSXSkipPercent = NormalizeSkipPercent(GetGadgetText(#Gadget_Setup_SkipCombo))
gFMSXSkipArg = GetSkipArg(gFMSXSkipPercent)
gFMSXPrinterFile = Trim(GetGadgetText(#Gadget_Setup_PrinterInput))
gFMSXSerialFile = Trim(GetGadgetText(#Gadget_Setup_SerialInput))
gFMSXDiskAFiles = Trim(GetGadgetText(#Gadget_Setup_DiskAInput))
gFMSXDiskBFiles = Trim(GetGadgetText(#Gadget_Setup_DiskBInput))
gFMSXTapeFile = Trim(GetGadgetText(#Gadget_Setup_TapeInput))
gFMSXFontFile = Trim(GetGadgetText(#Gadget_Setup_FontInput))
gFMSXLogSndFile = Trim(GetGadgetText(#Gadget_Setup_LogSndInput))
gFMSXStateFile = Trim(GetGadgetText(#Gadget_Setup_StateInput))
gFMSXPrinterArg = BuildSingleFileArg("-printer", gFMSXPrinterFile)
gFMSXSerialArg = BuildSingleFileArg("-serial", gFMSXSerialFile)
gFMSXDiskAArg = BuildMultiFileArg("-diska", gFMSXDiskAFiles)
gFMSXDiskBArg = BuildMultiFileArg("-diskb", gFMSXDiskBFiles)
gFMSXTapeArg = BuildSingleFileArg("-tape", gFMSXTapeFile)
gFMSXFontArg = BuildSingleFileArg("-font", gFMSXFontFile)
gFMSXLogSndArg = BuildSingleFileArg("-logsnd", gFMSXLogSndFile)
gFMSXStateArg = BuildSingleFileArg("-state", gFMSXStateFile)
gFMSXForce4x3 = GetGadgetState(#Gadget_Setup_4x3)
gThemeName = NormalizeThemeName(GetGadgetText(#Gadget_Setup_ThemeCombo))
If gFMSXForce4x3
    gFMSXForce4x3Arg = " -4x3"
Else
    gFMSXForce4x3Arg = ""
EndIf
If gDatabaseReady
    SaveFMSXPath(gFMSXPath)
    SaveFMSXMachineMode(gFMSXMachineMode)
    SaveFMSXVideoStandard(gFMSXVideoStandard)
    SaveFMSXMonitorType(gFMSXMonitorType)
    SaveFMSXScaleFilter(gFMSXScaleFilter)
    SaveFMSXAutoFire(gFMSXAutoFire)
    SaveFMSXRamPages(gFMSXRamPages)
    SaveFMSXVRamPages(gFMSXVRamPages)
    SaveFMSXRomType(1, gFMSXRomType1)
    SaveFMSXRomType(2, gFMSXRomType2)
    SaveFMSXJoyType(1, gFMSXJoyType1)
    SaveFMSXJoyType(2, gFMSXJoyType2)
    SaveFMSXDiskMode(gFMSXDiskMode)
    SaveFMSXSoundQuality(gFMSXSoundQuality)
    SaveFMSXVerboseLevel(gFMSXVerboseLevel)
    SaveFMSXSkipPercent(gFMSXSkipPercent)
    SaveFMSXTextSetting("fmsx_printer_file", gFMSXPrinterFile)
    SaveFMSXTextSetting("fmsx_serial_file", gFMSXSerialFile)
    SaveFMSXTextSetting("fmsx_diska_files", gFMSXDiskAFiles)
    SaveFMSXTextSetting("fmsx_diskb_files", gFMSXDiskBFiles)
    SaveFMSXTextSetting("fmsx_tape_file", gFMSXTapeFile)
    SaveFMSXTextSetting("fmsx_font_file", gFMSXFontFile)
    SaveFMSXTextSetting("fmsx_logsnd_file", gFMSXLogSndFile)
    SaveFMSXTextSetting("fmsx_state_file", gFMSXStateFile)
    SaveFMSXForce4x3(gFMSXForce4x3)
    SaveUITheme(gThemeName)
EndIf
ApplyCurrentTheme()
CloseWindow(#Window_Setup)
UpdateStatusBar()

Case #Gadget_Setup_Cancel
CloseWindow(#Window_Setup)
EndSelect
EndProcedure

; Janela principal: menu, botao de execucao e barra de status com a CLI gerada.
If OpenWindow(#Window_Main, 0, 0, 900, 600, "bamsx - Frontend fMSX", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
If CreateMenu(0, WindowID(#Window_Main))
    MenuTitle("File")
    MenuItem(#Menu_File_Exit, "Exit")

    MenuTitle("Tools")
    MenuItem(#Menu_Tools_Setup, "Setup")

    ; Espaço para alinhar à direita (hack: menu vazio)
    MenuTitle("")

    MenuTitle("Help")
    MenuItem(#Menu_Help_CLI, "CLI")
    MenuItem(#Menu_Help_Keys, "Keys")
    MenuItem(#Menu_Help_About, "About")
EndIf

TextGadget(#Gadget_Main_HeroPanel, 20, 20, 860, 210, "")
TextGadget(#Gadget_Main_Title, 48, 54, 520, 40, "bamsx")
TextGadget(#Gadget_Main_Subtitle, 48, 102, 760, 24, "Desktop frontend for the fMSX emulator with profiles and automated CLI")
TextGadget(#Gadget_Main_ThemeBadge, 48, 138, 160, 20, "Active theme")
TextGadget(#Gadget_Main_ThemeValue, 48, 160, 280, 24, gThemeName)
TextGadget(#Gadget_Main_FontBadge, 360, 138, 160, 20, "Runtime font")
TextGadget(#Gadget_Main_FontValue, 360, 160, 490, 24, "")

TextGadget(#Gadget_Main_Hint, 24, 500, 620, 26, "Tip: open Tools > Setup to adjust options, theme, and disk/tape paths.")
ButtonGadget(#Gadget_Main_Run, 764, 496, 120, 36, "Run fMSX")

CreateStatusBar(#StatusBar_Main, WindowID(#Window_Main))
AddStatusBarField(#PB_Ignore)
EndIf

gDatabaseReady = InitDatabase()
If gDatabaseReady
LoadSettings()
EndIf

ApplyCurrentTheme()
UpdateStatusBar()

; Loop principal da aplicacao. Despacha eventos de menu, gadgets, redimensionamento
; e fechamento das janelas enquanto a aplicacao estiver ativa.
Define appRunning.i = #True
Define event.i
Define keysEventType.i
Define mouseX.i
Define mouseY.i
Define keysSearchWidth.i
Define mainFontWidth.i

Repeat
event = WaitWindowEvent()

Select event
Case #PB_Event_Menu
Select EventMenu()
Case #Menu_File_Exit
appRunning = #False

Case #Menu_Tools_Setup
OpenSetupWindow()

Case #Menu_Help_CLI
ShowCLIWindow()

Case #Menu_Help_Keys
ShowKeysWindow()

Case #Menu_Help_About
ShowAboutDialog()
EndSelect

Case #PB_Event_Gadget
If EventWindow() = #Window_Setup
HandleSetupGadgetEvent(EventGadget())
ElseIf EventWindow() = #Window_Main
Select EventGadget()
Case #Gadget_Main_Run
RunFMSX()
EndSelect
ElseIf EventWindow() = #Window_Keys
Select EventGadget()
Case #Gadget_Keys_Close
CloseWindow(#Window_Keys)

Case #Gadget_Keys_Copy
CopySelectedShortcut()

Case #Gadget_Keys_FilterCombo
gKeysFilterCategory = NormalizeKeysCategory(GetGadgetText(#Gadget_Keys_FilterCombo))
RebuildVisibleKeyShortcuts()
ResizeKeysCanvas()

Case #Gadget_Keys_SearchInput
If EventType() = #PB_EventType_Change
    gKeysSearchText = GetGadgetText(#Gadget_Keys_SearchInput)
    RebuildVisibleKeyShortcuts()
    ResizeKeysCanvas()
EndIf

Case #Gadget_Keys_Canvas
keysEventType = EventType()
Select keysEventType
Case #PB_EventType_MouseMove
    mouseX = GetGadgetAttribute(#Gadget_Keys_Canvas, #PB_Canvas_MouseX)
    mouseY = GetGadgetAttribute(#Gadget_Keys_Canvas, #PB_Canvas_MouseY)
    gKeysHoverIndex = GetKeyShortcutAtCanvasPosition(mouseX, mouseY)

Case #PB_EventType_MouseLeave
    gKeysHoverIndex = -1

Case #PB_EventType_LeftButtonDown
    mouseX = GetGadgetAttribute(#Gadget_Keys_Canvas, #PB_Canvas_MouseX)
    mouseY = GetGadgetAttribute(#Gadget_Keys_Canvas, #PB_Canvas_MouseY)
    gKeysSelectedIndex = GetKeyShortcutAtCanvasPosition(mouseX, mouseY)
    DrawKeysCards()
EndSelect
EndSelect
ElseIf EventWindow() = #Window_CLI
Select EventGadget()
Case #Gadget_CLI_Close
CloseWindow(#Window_CLI)

Case #Gadget_CLI_Copy
CopySelectedCLIOption()

Case #Gadget_CLI_FilterCombo
gCLIFilterCategory = NormalizeCLICategory(GetGadgetText(#Gadget_CLI_FilterCombo))
RebuildVisibleCLIOptions()
ResizeCLICanvas()

Case #Gadget_CLI_SearchInput
If EventType() = #PB_EventType_Change
    gCLISearchText = GetGadgetText(#Gadget_CLI_SearchInput)
    RebuildVisibleCLIOptions()
    ResizeCLICanvas()
EndIf

Case #Gadget_CLI_Canvas
keysEventType = EventType()
Select keysEventType
Case #PB_EventType_MouseMove
    mouseX = GetGadgetAttribute(#Gadget_CLI_Canvas, #PB_Canvas_MouseX)
    mouseY = GetGadgetAttribute(#Gadget_CLI_Canvas, #PB_Canvas_MouseY)
    gCLIHoverIndex = GetCLIOptionAtCanvasPosition(mouseX, mouseY)
    DrawCLICards()

Case #PB_EventType_MouseLeave
    gCLIHoverIndex = -1
    DrawCLICards()

Case #PB_EventType_LeftButtonDown
    mouseX = GetGadgetAttribute(#Gadget_CLI_Canvas, #PB_Canvas_MouseX)
    mouseY = GetGadgetAttribute(#Gadget_CLI_Canvas, #PB_Canvas_MouseY)
    gCLISelectedIndex = GetCLIOptionAtCanvasPosition(mouseX, mouseY)
    DrawCLICards()
EndSelect
EndSelect
ElseIf EventWindow() = #Window_About
Select EventGadget()
Case #Gadget_About_Close
CloseWindow(#Window_About)

Case #Gadget_About_Canvas
Select EventType()
Case #PB_EventType_MouseMove
    mouseX = GetGadgetAttribute(#Gadget_About_Canvas, #PB_Canvas_MouseX)
    mouseY = GetGadgetAttribute(#Gadget_About_Canvas, #PB_Canvas_MouseY)
    gAboutHoverIndex = GetAboutCardAtCanvasPosition(mouseX, mouseY)
    DrawAboutCards()
Case #PB_EventType_MouseLeave
    gAboutHoverIndex = -1
    DrawAboutCards()
Case #PB_EventType_LeftButtonDown
    mouseX = GetGadgetAttribute(#Gadget_About_Canvas, #PB_Canvas_MouseX)
    mouseY = GetGadgetAttribute(#Gadget_About_Canvas, #PB_Canvas_MouseY)
    Define aboutSlot.i = GetAboutCardAtCanvasPosition(mouseX, mouseY)
    If aboutSlot >= 0
        Define aboutValue.s = GetAboutCardValue(aboutSlot)
        SetClipboardText(aboutValue)
        MessageRequester("About", "Value copied to clipboard:" + Chr(10) + Chr(10) + GetAboutCardTitle(aboutSlot) + ": " + aboutValue)
    EndIf
EndSelect
EndSelect
EndIf

Case #PB_Event_Timer
If EventWindow() = #Window_Keys And EventTimer() = #Timer_KeysHover
    UpdateKeysHoverAnimation()
EndIf

Case #PB_Event_SizeWindow
If EventWindow() = #Window_Main
ResizeGadget(#Gadget_Main_HeroPanel, 20, 20, WindowWidth(#Window_Main) - 40, 210)
ResizeGadget(#Gadget_Main_Title, 48, 54, WindowWidth(#Window_Main) - 96, #PB_Ignore)
ResizeGadget(#Gadget_Main_Subtitle, 48, 102, WindowWidth(#Window_Main) - 96, #PB_Ignore)
ResizeGadget(#Gadget_Main_ThemeValue, 48, 160, 280, #PB_Ignore)
ResizeGadget(#Gadget_Main_FontBadge, 360, 138, #PB_Ignore, #PB_Ignore)
mainFontWidth = WindowWidth(#Window_Main) - 408
If mainFontWidth < 120
    mainFontWidth = 120
EndIf
ResizeGadget(#Gadget_Main_FontValue, 360, 160, mainFontWidth, #PB_Ignore)
ResizeGadget(#Gadget_Main_Hint, 24, WindowHeight(#Window_Main) - 100, WindowWidth(#Window_Main) - 300, #PB_Ignore)
ResizeGadget(#Gadget_Main_Run, WindowWidth(#Window_Main) - 140, WindowHeight(#Window_Main) - 96, #PB_Ignore, #PB_Ignore)
ElseIf EventWindow() = #Window_Keys
ResizeGadget(#Gadget_Keys_Title, 20, 16, WindowWidth(#Window_Keys) - 40, #PB_Ignore)
ResizeGadget(#Gadget_Keys_Subtitle, 20, 58, WindowWidth(#Window_Keys) - 40, #PB_Ignore)
ResizeGadget(#Gadget_Keys_FilterLabel, 20, 86, #PB_Ignore, #PB_Ignore)
ResizeGadget(#Gadget_Keys_FilterCombo, 102, 84, #PB_Ignore, #PB_Ignore)
ResizeGadget(#Gadget_Keys_SearchLabel, 300, 86, #PB_Ignore, #PB_Ignore)
keysSearchWidth = WindowWidth(#Window_Keys) - 520
If keysSearchWidth < 180
    keysSearchWidth = 180
EndIf
ResizeGadget(#Gadget_Keys_SearchInput, 360, 84, keysSearchWidth, #PB_Ignore)
ResizeGadget(#Gadget_Keys_Scroll, 20, 118, WindowWidth(#Window_Keys) - 40, WindowHeight(#Window_Keys) - 178)
ResizeGadget(#Gadget_Keys_Copy, 20, WindowHeight(#Window_Keys) - 42, #PB_Ignore, #PB_Ignore)
ResizeGadget(#Gadget_Keys_Close, WindowWidth(#Window_Keys) - 140, WindowHeight(#Window_Keys) - 42, #PB_Ignore, #PB_Ignore)
ResizeKeysCanvas()
ElseIf EventWindow() = #Window_CLI
ResizeGadget(#Gadget_CLI_Title, 20, 16, WindowWidth(#Window_CLI) - 40, #PB_Ignore)
ResizeGadget(#Gadget_CLI_Subtitle, 20, 58, WindowWidth(#Window_CLI) - 40, #PB_Ignore)
ResizeGadget(#Gadget_CLI_FilterLabel, 20, 86, #PB_Ignore, #PB_Ignore)
ResizeGadget(#Gadget_CLI_FilterCombo, 102, 84, #PB_Ignore, #PB_Ignore)
ResizeGadget(#Gadget_CLI_SearchLabel, 300, 86, #PB_Ignore, #PB_Ignore)
keysSearchWidth = WindowWidth(#Window_CLI) - 500
If keysSearchWidth < 220
    keysSearchWidth = 220
EndIf
ResizeGadget(#Gadget_CLI_SearchInput, 360, 84, keysSearchWidth, #PB_Ignore)
ResizeGadget(#Gadget_CLI_Scroll, 20, 118, WindowWidth(#Window_CLI) - 40, WindowHeight(#Window_CLI) - 178)
ResizeGadget(#Gadget_CLI_Copy, 20, WindowHeight(#Window_CLI) - 42, #PB_Ignore, #PB_Ignore)
ResizeGadget(#Gadget_CLI_Close, WindowWidth(#Window_CLI) - 140, WindowHeight(#Window_CLI) - 42, #PB_Ignore, #PB_Ignore)
ResizeCLICanvas()
ElseIf EventWindow() = #Window_About
ResizeGadget(#Gadget_About_Title, 20, 16, WindowWidth(#Window_About) - 40, #PB_Ignore)
ResizeGadget(#Gadget_About_Subtitle, 20, 58, WindowWidth(#Window_About) - 40, #PB_Ignore)
ResizeGadget(#Gadget_About_Scroll, 20, 88, WindowWidth(#Window_About) - 40, WindowHeight(#Window_About) - 138)
ResizeGadget(#Gadget_About_Close, WindowWidth(#Window_About) - 140, WindowHeight(#Window_About) - 42, #PB_Ignore, #PB_Ignore)
ResizeAboutCanvas()
EndIf

Case #PB_Event_CloseWindow
Select EventWindow()
Case #Window_Main
appRunning = #False

Case #Window_Setup
CloseWindow(#Window_Setup)

Case #Window_Keys
RemoveWindowTimer(#Window_Keys, #Timer_KeysHover)
CloseWindow(#Window_Keys)

Case #Window_CLI
CloseWindow(#Window_CLI)

Case #Window_About
CloseWindow(#Window_About)
EndSelect
EndSelect
Until appRunning = #False

If gDatabaseReady
CloseDatabase(gDatabase)
EndIf

If gUIFontSourceReady And gUIFontSourcePath <> ""
    RemoveFontResourceExW(gUIFontSourcePath, #FR_PRIVATE, 0)
EndIf
