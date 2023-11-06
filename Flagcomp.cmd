@echo off
setlocal enabledelayedexpansion
REM ========================PRE-DEFINED VARIABLES GO HERE (variable defaults before checking for flags)=============

REM ======================== SAVE FCOMP SETTINGS HERE ==============================================================
REM Valid options are: variable, call, command.

REM ======================== END FCOMP SETTINGS SECTION ============================================================
REM Flagcomp by github.com/ITCMD/batch-flag-companion
set fdelayedcommandlist=REM Do Nothing
if "%~1"=="" (
    REM OPTION TASK TO DO IF NO FLAGS ARE GIVEN
)
:flagcomploop
if "%~1"=="" goto :eflagcomp
set tempflagcomp=%~1
if not "%tempflagcomp:~0,1%"=="/" (
    if not "%tempflagcomp:~0,1%"=="-" (
        echo Flag Companion error: %~1 is not a recognized flag
        REM RECOMMENDED YOU ADD A COMMAND TO SHOW HELP FILE OR GOTO HELP SECTION HERE
        goto processnextflag
    )
)
set tempflagcomp=%tempflagcomp:~1%
if "!f_%tempflagcomp%!"=="" (
    echo Flag Companion error: flag %~1 is not found in script.
    goto processnextflag
)
if "!f_%tempflagcomp%!"=="variable" (
    if "!fvar_%tempflagcomp%!"=="" (
        echo Flag Companion error: flag %~1 is recognized as a variable flag, but no f_var%tempflagcomp% was set to expect the value.
        goto processnextflag
    )
    set !fvar_%tempflagcomp%!=%~2
    shift
    goto processnextflag
)
set fdelay=false
if "!f_%tempflagcomp%!"=="command" (
    if "!fcom_%tempflagcomp%!"=="" (
        echo Flag Companion error: flag %~1 is recognized as a command flag, but no fcom_%tempflagcomp% command was set to run.
        goto processnextflag
    )
    if "!fdelay_%tempflagcomp%!"=="true" (
        set fdelayedcommandlist=%fdelayedcommandlist%^&!fcom_%tempflagcomp%!
        goto processnextflag
    ) ELSE (
        !fcom_%tempflagcomp%!
        goto processnextflag
    )
)
if "!f_%tempflagcomp%!"=="call" (
    if "!fcall_%tempflagcomp%!"=="" (
        echo Flag Companion error: flag %~1 is recognized as a call flag, but no fcall_%tempflagcomp% script was set to be called.
        goto processnextflag
    )
    call !fcall_%tempflagcomp%!
    goro processnextflag
)
:processnextflag
shift
goto flagcomploop
:eflagcomp
%fdelayedcommandlist%
REM ===================== NORMAL SCRIPT BELOW THIS LINE ==========================