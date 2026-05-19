EnableExplicit

UseSQLiteDatabase()

Enumeration
#Window_Main
#Window_Setup
EndEnumeration

Enumeration
#Menu_File_Exit = 100
#Menu_Tools_Setup
EndEnumeration

Enumeration
#Gadget_Setup_PathLabel = 200
#Gadget_Setup_PathInput
#Gadget_Setup_Browse
#Gadget_Setup_ModeLabel
#Gadget_Setup_ModeCombo
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
#StatusBar_Main = 400
    #Gadget_Setup_4x3 = 500
EndEnumeration

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
; --- Filtro de escala ---
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
        Case "AUTO", "LIGADO", "ON", "1", "SIM"
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
    If t = "" Or FindString(t, "NENHUM", 1)
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
    selected = OpenFileRequester(title, GetGadgetText(gadgetID), "Todos os arquivos|*.*", 0)
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

    selected = SaveFileRequester(title, GetGadgetText(gadgetID), "Todos os arquivos|*.*", 0)
    If selected = ""
        ProcedureReturn
    EndIf

    file = CreateFile(#PB_Any, selected)
    If file = 0
        MessageRequester("Erro", "Nao foi possivel criar o arquivo: " + selected)
        ProcedureReturn
    EndIf
    CloseFile(file)

    If appendMode
        SetGadgetText(gadgetID, AppendPathList(GetGadgetText(gadgetID), selected))
    Else
        SetGadgetText(gadgetID, selected)
    EndIf
EndProcedure
Global gDatabase.i
Global gDatabaseReady.i
Global gDatabaseFile.s = ""
Global gSQLiteExeFile.s = ""

Procedure.s EscapeSQL(text.s)
ProcedureReturn ReplaceString(text, "'", "''")
EndProcedure

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

Procedure UpdateStatusBar()
Protected homePath.s
Protected cmdLine.s

If Not IsStatusBar(#StatusBar_Main)
ProcedureReturn
EndIf

If Trim(gFMSXPath) = ""
StatusBarText(#StatusBar_Main, 0, "  fMSX nao configurado - acesse Tools > Setup")
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
StatusBarText(#StatusBar_Main, 0, "  " + cmdLine)
EndProcedure

Procedure RunFMSX(selectedMode.s = "")
Protected homePath.s
Protected params.s
Protected program.i
Protected effectiveMode.s

If Trim(gFMSXPath) = ""
MessageRequester("Aviso", "Configure o caminho do fmsx.exe em Tools > Setup antes de executar.")
ProcedureReturn
EndIf

If FileSize(gFMSXPath) = -1
MessageRequester("Erro", "fmsx.exe nao encontrado no caminho configurado.")
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
MessageRequester("Erro", "Nao foi possivel executar o fMSX com as opcoes selecionadas.")
EndIf
EndProcedure

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
MessageRequester("Erro", "Arquivo sqlite3.exe nao encontrado. Locais verificados:" + Chr(10) + searchPaths)
ProcedureReturn #False
EndIf

sqlCommand = "CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT);"
params = Chr(34) + gDatabaseFile + Chr(34) + " " + Chr(34) + sqlCommand + Chr(34)

program = RunProgram(gSQLiteExeFile, params, GetPathPart(gSQLiteExeFile), #PB_Program_Wait)
If program = 0
MessageRequester("Erro", "Nao foi possivel executar sqlite3.exe para criar o banco.")
ProcedureReturn #False
EndIf

If ProgramExitCode(program) <> 0
CloseProgram(program)
MessageRequester("Erro", "sqlite3.exe retornou erro ao criar o banco.")
ProcedureReturn #False
EndIf

CloseProgram(program)

If FileSize(gDatabaseFile) = -1
MessageRequester("Erro", "O banco bamsx.db nao foi criado pelo sqlite3.exe.")
ProcedureReturn #False
EndIf

ProcedureReturn #True
EndProcedure

Procedure InitDatabase()
If EnsureDatabaseWithSQLiteExe() = #False
ProcedureReturn #False
EndIf

gDatabase = OpenDatabase(#PB_Any, gDatabaseFile, "", "")
If gDatabase = 0
MessageRequester("Erro", "Nao foi possivel abrir/criar o banco SQLite.")
ProcedureReturn #False
EndIf

If DatabaseUpdate(gDatabase, "CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT)") = 0
MessageRequester("Erro", "Nao foi possivel inicializar a tabela de configuracao.")
CloseDatabase(gDatabase)
gDatabase = 0
ProcedureReturn #False
EndIf

ProcedureReturn #True
EndProcedure

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
EndProcedure

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

If IsWindow(#Window_Setup)
SetActiveWindow(#Window_Setup)
ProcedureReturn
EndIf

If OpenWindow(#Window_Setup, 0, 0, 760, 920, "Setup", #PB_Window_SystemMenu | #PB_Window_WindowCentered, WindowID(#Window_Main))
TextGadget(#Gadget_Setup_PathLabel, 12, 18, 180, 22, "Caminho do fmsx.exe:")
StringGadget(#Gadget_Setup_PathInput, 12, 44, 430, 24, gFMSXPath)
ButtonGadget(#Gadget_Setup_Browse, 450, 44, 98, 24, "Procurar")

TextGadget(#Gadget_Setup_ModeLabel, 12, 80, 160, 22, "Modo de execucao:")
ComboBoxGadget(#Gadget_Setup_ModeCombo, 12, 106, 160, 24)
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

TextGadget(#Gadget_Setup_VideoLabel, 188, 80, 112, 22, "Padrao de video:")
ComboBoxGadget(#Gadget_Setup_VideoCombo, 188, 106, 110, 24)
AddGadgetItem(#Gadget_Setup_VideoCombo, -1, "PAL")
AddGadgetItem(#Gadget_Setup_VideoCombo, -1, "NTSC")
SetGadgetState(#Gadget_Setup_VideoCombo, Bool(gFMSXVideoStandard = "NTSC"))

TextGadget(#Gadget_Setup_MonoLabel, 316, 80, 130, 22, "Tipo de monitor:")
ComboBoxGadget(#Gadget_Setup_MonoCombo, 316, 106, 132, 24)

AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "Nenhum (cor)")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "Sepia")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "Monocromatico")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "Verde")
AddGadgetItem(#Gadget_Setup_MonoCombo, -1, "Ambar")
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

TextGadget(#Gadget_Setup_ScaleLabel, 12, 150, 180, 22, "Filtro de escala:")
ComboBoxGadget(#Gadget_Setup_ScaleCombo, 12, 176, 160, 24)
AddGadgetItem(#Gadget_Setup_ScaleCombo, -1, "Nenhum")
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

TextGadget(#Gadget_Setup_AutoLabel, 188, 150, 112, 22, "Autofire:")
ComboBoxGadget(#Gadget_Setup_AutoCombo, 188, 176, 110, 24)
AddGadgetItem(#Gadget_Setup_AutoCombo, -1, "NoAuto")
AddGadgetItem(#Gadget_Setup_AutoCombo, -1, "Auto")
autoIndex = Bool(gFMSXAutoFire)
SetGadgetState(#Gadget_Setup_AutoCombo, autoIndex)

CheckBoxGadget(#Gadget_Setup_4x3, 316, 176, 180, 22, "Forçar modo 4x3")
SetGadgetState(#Gadget_Setup_4x3, gFMSXForce4x3)

TextGadget(#Gadget_Setup_RAMLabel, 12, 212, 160, 22, "RAM (paginas 16k):")
ComboBoxGadget(#Gadget_Setup_RAMCombo, 12, 238, 90, 24)
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

TextGadget(#Gadget_Setup_VRAMLabel, 120, 212, 170, 22, "VRAM (paginas 16k):")
ComboBoxGadget(#Gadget_Setup_VRAMCombo, 120, 238, 90, 24)
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

TextGadget(#Gadget_Setup_ROM1Label, 236, 212, 140, 22, "ROM mapper #1:")
ComboBoxGadget(#Gadget_Setup_ROM1Combo, 236, 238, 152, 24)
AddGadgetItem(#Gadget_Setup_ROM1Combo, -1, "Nenhum")
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

TextGadget(#Gadget_Setup_ROM2Label, 396, 212, 140, 22, "ROM mapper #2:")
ComboBoxGadget(#Gadget_Setup_ROM2Combo, 396, 238, 152, 24)
AddGadgetItem(#Gadget_Setup_ROM2Combo, -1, "Nenhum")
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

TextGadget(#Gadget_Setup_Joy1Label, 12, 274, 140, 22, "Joystick #1:")
ComboBoxGadget(#Gadget_Setup_Joy1Combo, 12, 300, 160, 24)
AddGadgetItem(#Gadget_Setup_Joy1Combo, -1, "0 - No joystick")
AddGadgetItem(#Gadget_Setup_Joy1Combo, -1, "1 - Normal joystick")
AddGadgetItem(#Gadget_Setup_Joy1Combo, -1, "2 - Mouse joystick")
AddGadgetItem(#Gadget_Setup_Joy1Combo, -1, "3 - Mouse real")
joy1Index = NormalizeJoyType(Str(gFMSXJoyType1))
SetGadgetState(#Gadget_Setup_Joy1Combo, joy1Index)

TextGadget(#Gadget_Setup_Joy2Label, 188, 274, 140, 22, "Joystick #2:")
ComboBoxGadget(#Gadget_Setup_Joy2Combo, 188, 300, 160, 24)
AddGadgetItem(#Gadget_Setup_Joy2Combo, -1, "0 - No joystick")
AddGadgetItem(#Gadget_Setup_Joy2Combo, -1, "1 - Normal joystick")
AddGadgetItem(#Gadget_Setup_Joy2Combo, -1, "2 - Mouse joystick")
AddGadgetItem(#Gadget_Setup_Joy2Combo, -1, "3 - Mouse real")
joy2Index = NormalizeJoyType(Str(gFMSXJoyType2))
SetGadgetState(#Gadget_Setup_Joy2Combo, joy2Index)

TextGadget(#Gadget_Setup_DiskLabel, 364, 274, 180, 22, "Acesso DiskROM:")
ComboBoxGadget(#Gadget_Setup_DiskCombo, 364, 300, 184, 24)
AddGadgetItem(#Gadget_Setup_DiskCombo, -1, "WD1793")
AddGadgetItem(#Gadget_Setup_DiskCombo, -1, "SIMBDOS")
diskIndex = Bool(NormalizeDiskMode(gFMSXDiskMode) = "SIMBDOS")
SetGadgetState(#Gadget_Setup_DiskCombo, diskIndex)

TextGadget(#Gadget_Setup_SoundLabel, 12, 336, 200, 22, "Som (Hz):")
ComboBoxGadget(#Gadget_Setup_SoundCombo, 12, 362, 160, 24)
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

TextGadget(#Gadget_Setup_VerboseLabel, 188, 336, 220, 22, "Debug verbose (-verbose):")
ComboBoxGadget(#Gadget_Setup_VerboseCombo, 188, 362, 360, 24)
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

TextGadget(#Gadget_Setup_SkipLabel, 12, 398, 200, 22, "Frameskip (%):")
ComboBoxGadget(#Gadget_Setup_SkipCombo, 12, 424, 160, 24)
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

TextGadget(#Gadget_Setup_PrinterLabel, 12, 462, 150, 22, "Printer file:")
StringGadget(#Gadget_Setup_PrinterInput, 12, 486, 560, 24, gFMSXPrinterFile)
ButtonGadget(#Gadget_Setup_PrinterBrowse, 580, 486, 80, 24, "Browse")
ButtonGadget(#Gadget_Setup_PrinterCreate, 668, 486, 80, 24, "Create")

TextGadget(#Gadget_Setup_SerialLabel, 12, 518, 150, 22, "Serial file:")
StringGadget(#Gadget_Setup_SerialInput, 12, 542, 560, 24, gFMSXSerialFile)
ButtonGadget(#Gadget_Setup_SerialBrowse, 580, 542, 80, 24, "Browse")
ButtonGadget(#Gadget_Setup_SerialCreate, 668, 542, 80, 24, "Create")

TextGadget(#Gadget_Setup_DiskALabel, 12, 574, 240, 22, "Disk A files (; para varios):")
StringGadget(#Gadget_Setup_DiskAInput, 12, 598, 560, 24, gFMSXDiskAFiles)
ButtonGadget(#Gadget_Setup_DiskABrowse, 580, 598, 80, 24, "Browse")
ButtonGadget(#Gadget_Setup_DiskACreate, 668, 598, 80, 24, "Create")

TextGadget(#Gadget_Setup_DiskBLabel, 12, 630, 240, 22, "Disk B files (; para varios):")
StringGadget(#Gadget_Setup_DiskBInput, 12, 654, 560, 24, gFMSXDiskBFiles)
ButtonGadget(#Gadget_Setup_DiskBBrowse, 580, 654, 80, 24, "Browse")
ButtonGadget(#Gadget_Setup_DiskBCreate, 668, 654, 80, 24, "Create")

TextGadget(#Gadget_Setup_TapeLabel, 12, 686, 150, 22, "Tape file:")
StringGadget(#Gadget_Setup_TapeInput, 12, 710, 560, 24, gFMSXTapeFile)
ButtonGadget(#Gadget_Setup_TapeBrowse, 580, 710, 80, 24, "Browse")
ButtonGadget(#Gadget_Setup_TapeCreate, 668, 710, 80, 24, "Create")

TextGadget(#Gadget_Setup_FontLabel, 12, 742, 150, 22, "Font file:")
StringGadget(#Gadget_Setup_FontInput, 12, 766, 560, 24, gFMSXFontFile)
ButtonGadget(#Gadget_Setup_FontBrowse, 580, 766, 80, 24, "Browse")
ButtonGadget(#Gadget_Setup_FontCreate, 668, 766, 80, 24, "Create")

TextGadget(#Gadget_Setup_LogSndLabel, 12, 798, 180, 22, "Soundtrack log file:")
StringGadget(#Gadget_Setup_LogSndInput, 12, 822, 560, 24, gFMSXLogSndFile)
ButtonGadget(#Gadget_Setup_LogSndBrowse, 580, 822, 80, 24, "Browse")
ButtonGadget(#Gadget_Setup_LogSndCreate, 668, 822, 80, 24, "Create")

TextGadget(#Gadget_Setup_StateLabel, 12, 854, 150, 22, "State file:")
StringGadget(#Gadget_Setup_StateInput, 12, 878, 560, 24, gFMSXStateFile)
ButtonGadget(#Gadget_Setup_StateBrowse, 580, 878, 80, 24, "Browse")
ButtonGadget(#Gadget_Setup_StateCreate, 668, 878, 80, 24, "Create")

ButtonGadget(#Gadget_Setup_Save, 570, 12, 80, 28, "Salvar")
ButtonGadget(#Gadget_Setup_Cancel, 662, 12, 86, 28, "Fechar")
EndIf
EndProcedure

Procedure HandleSetupGadgetEvent(eventGadget.i)
Protected selectedFile.s

Select eventGadget
Case #Gadget_Setup_Browse
selectedFile = OpenFileRequester("Selecione o executavel do fMSX", gFMSXPath, "Executavel|fmsx.exe;*.exe|Todos os arquivos|*.*", 0)
If selectedFile <> ""
SetGadgetText(#Gadget_Setup_PathInput, selectedFile)
EndIf

Case #Gadget_Setup_PrinterBrowse
BrowsePathIntoGadget(#Gadget_Setup_PrinterInput, "Selecione arquivo de printer", #False)
Case #Gadget_Setup_PrinterCreate
CreatePathIntoGadget(#Gadget_Setup_PrinterInput, "Criar arquivo de printer", #False)

Case #Gadget_Setup_SerialBrowse
BrowsePathIntoGadget(#Gadget_Setup_SerialInput, "Selecione arquivo serial", #False)
Case #Gadget_Setup_SerialCreate
CreatePathIntoGadget(#Gadget_Setup_SerialInput, "Criar arquivo serial", #False)

Case #Gadget_Setup_DiskABrowse
BrowsePathIntoGadget(#Gadget_Setup_DiskAInput, "Selecione imagem para drive A:", #True)
Case #Gadget_Setup_DiskACreate
CreatePathIntoGadget(#Gadget_Setup_DiskAInput, "Criar imagem para drive A:", #True)

Case #Gadget_Setup_DiskBBrowse
BrowsePathIntoGadget(#Gadget_Setup_DiskBInput, "Selecione imagem para drive B:", #True)
Case #Gadget_Setup_DiskBCreate
CreatePathIntoGadget(#Gadget_Setup_DiskBInput, "Criar imagem para drive B:", #True)

Case #Gadget_Setup_TapeBrowse
BrowsePathIntoGadget(#Gadget_Setup_TapeInput, "Selecione arquivo de fita", #False)
Case #Gadget_Setup_TapeCreate
CreatePathIntoGadget(#Gadget_Setup_TapeInput, "Criar arquivo de fita", #False)

Case #Gadget_Setup_FontBrowse
BrowsePathIntoGadget(#Gadget_Setup_FontInput, "Selecione arquivo de fonte", #False)
Case #Gadget_Setup_FontCreate
CreatePathIntoGadget(#Gadget_Setup_FontInput, "Criar arquivo de fonte", #False)

Case #Gadget_Setup_LogSndBrowse
BrowsePathIntoGadget(#Gadget_Setup_LogSndInput, "Selecione arquivo de log de som", #False)
Case #Gadget_Setup_LogSndCreate
CreatePathIntoGadget(#Gadget_Setup_LogSndInput, "Criar arquivo de log de som", #False)

Case #Gadget_Setup_StateBrowse
BrowsePathIntoGadget(#Gadget_Setup_StateInput, "Selecione arquivo de state", #False)
Case #Gadget_Setup_StateCreate
CreatePathIntoGadget(#Gadget_Setup_StateInput, "Criar arquivo de state", #False)

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
EndIf
CloseWindow(#Window_Setup)
UpdateStatusBar()

Case #Gadget_Setup_Cancel
CloseWindow(#Window_Setup)
EndSelect
EndProcedure

If OpenWindow(#Window_Main, 0, 0, 900, 600, "bamsx - Frontend fMSX", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
If CreateMenu(0, WindowID(#Window_Main))
    MenuTitle("File")
    MenuItem(#Menu_File_Exit, "Exit")

    MenuTitle("Tools")
    MenuItem(#Menu_Tools_Setup, "Setup")

    ; Espaço para alinhar à direita (hack: menu vazio)
    MenuTitle("")

    MenuTitle("Help")
    MenuItem(1001, "CLI")
    MenuItem(1002, "Keys")
    MenuItem(1003, "About")
EndIf

ButtonGadget(#Gadget_Main_Run, 790, 506, 96, 30, "Run")

CreateStatusBar(#StatusBar_Main, WindowID(#Window_Main))
AddStatusBarField(#PB_Ignore)
EndIf

gDatabaseReady = InitDatabase()
If gDatabaseReady
LoadSettings()
EndIf

UpdateStatusBar()

Define appRunning.i = #True
Define event.i

Repeat
event = WaitWindowEvent()

Select event
Case #PB_Event_Menu
Select EventMenu()
Case #Menu_File_Exit
appRunning = #False

Case #Menu_Tools_Setup
OpenSetupWindow()
EndSelect

Case #PB_Event_Gadget
If EventWindow() = #Window_Setup
HandleSetupGadgetEvent(EventGadget())
ElseIf EventWindow() = #Window_Main
Select EventGadget()
Case #Gadget_Main_Run
RunFMSX()
EndSelect
EndIf

Case #PB_Event_SizeWindow
If EventWindow() = #Window_Main
ResizeGadget(#Gadget_Main_Run, WindowWidth(#Window_Main) - 110, WindowHeight(#Window_Main) - 94, #PB_Ignore, #PB_Ignore)
EndIf

Case #PB_Event_CloseWindow
Select EventWindow()
Case #Window_Main
appRunning = #False

Case #Window_Setup
CloseWindow(#Window_Setup)
EndSelect
EndSelect
Until appRunning = #False

If gDatabaseReady
CloseDatabase(gDatabase)
EndIf
