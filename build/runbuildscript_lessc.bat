@ECHO OFF
CLS
:: Kickstrap CSS build script for Windows
:: Author: Alex Skrypnbyk (alex.designworks@gmail.com)
:: Modified: 11/04/2012
:: Version 1.0

:: Created with help of BatchBoilerplate 
:: https://github.com/alexdesignworks/BatchBoilerplate

:: 'lessc' is required for this script.
:: Download 'lessc' from https://github.com/duncansmart/less.js-windows

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: -------------- SETTINGS --------------
:: LESS files can be located at the following locations:
::   less/bootstrap.less - Main bootsrap file
::   extras/settings/overrides.less - Main Kickstrap file
::   extras/settings/theme.less - Main theme file
::   extras/app/styles.less - Main app file

SET LESSTB=less/bootstrap.less
SET LESSAPP=extras/app/styles.less
:: Below can be used only if/when Kickstrap overrrides and themes will be 
:: outside of compiled bootstrap.css
:: SET LESSFILES2=extras/settings/overrides.less
:: SET LESSFILES3=extras/settings/theme.less


:: CSS output directory
SET CSSDIR=css

:: LESS processor
SET LESSC=lessc

:: Create compressed css files
SET COMPRESS=1
:: ---------- END OF SETTINGS -----------

:: --------------------------------------
:: DO NOT CHANGE ANYTHING BELOW THIS LINE
:: UNLESS YOU KNOW WHAT YOU ARE DOING
:: --------------------------------------
:: Set current dir
SET CURDIR=%~dp0
SET CURDIR=%CURDIR:~0,-1%

SET ROOT=..
:: Get LOG timestamp to be used in log filename
call :get_file_timestamp LOGTIMESTAMP
:: Set log filename
SET LOG=%CURDIR%\log_%LOGTIMESTAMP%.txt

call :msg "Script started"
call :log "Script started"

:: Start of main script body
:main
:: Process less files
call :lessprocess %LESSTB% %COMPRESS%
call :lessprocess %LESSAPP% %COMPRESS%

:: End of main script body
:endmain
goto end
ENDLOCAL

:: --------------------------------------
::        USER-DEFINED SUBROUTINES
:: --------------------------------------
:lessprocess
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: Function body
SET SRC=%ROOT%\%1
SET DST=%ROOT%\%CSSDIR%\%~n1

SET COMPRESS=%2

call :heading "Start compiling to "%DST%.css
call :log "Start compiling to "%DST%.css
call %LESSC% %SRC% %DST%.css
if %ERRORLEVEL% EQU 0 (
  call :msg "SUCCESS"
  call :log "SUCCESS"
) else (
  call :msg "FAILED"
  call :log "FAILED"
  goto :EOF
)

if "%COMPRESS%" EQU "1" (
  call :heading "Start compiling to "%DST%.min.css
  call :log "Start compiling to "%DST%.min.css
  call %LESSC% %SRC% %DST%.min.css -compress
  if %ERRORLEVEL% EQU 0 (
    call :msg "SUCCESS"
    call :log "SUCCESS"
  ) else (
    call :msg "FAILED"
    call :log "FAILED"
  )
)

goto :EOF
ENDLOCAL

:: --------------------------------------
::          UTILITY SUBROUTINES
:: --------------------------------------
:: wait [delay seconds]
:: heading "Heading text"
:: msg "Message text"
:: log "Log message text"
:: get_timestamp RET_VAR
:: get_file_timestamp RET_VAR
:: LCase STRING RET_STRING
:: UCase STRING RET_STRING
:: check_process_running PROCESS_NAME RET_VAR
:: check_command_exists COMMAND_NAME RET_VAR

:wait
:: Hold script for specified ampount of time
:: Syntax: call :wait - defaults to 5 seconds wait
:: Syntax: call :wait 10 - defaults to specified (10) seconds wait
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
if "%1" EQU ""  (
  SET DELAY=5000
) else (
  SET /A DELAY=%1*1000
)
ping 1.1.1.1 -n 1 -w %DELAY%>NUL
goto :EOF
ENDLOCAL

:heading
:: Print preformatted heading
:: Syntax: call :heading "Some heading line in quotes"
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET SRC=%1
SET SRC=%SRC:"=%
call :UCase SRC MSG
echo.
echo ----------------------------------------------------
echo   %MSG%
echo ----------------------------------------------------
echo.
ENDLOCAL
goto :EOF

:msg
:: Print preformatted message
:: Syntax: call :msg "Some message line in quotes"
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET MSG=%1
SET MSG=%MSG:"=%
echo %MSG%
ENDLOCAL
goto :EOF

:log
:: Put specified line in file
:: Syntax: call :log "Some log line in quotes"
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET MSG=%1
SET MSG=%MSG:"=%
:: Get time
call :get_timestamp TIMESTAMP
echo %TIMESTAMP%	%MSG%>>%LOG%
ENDLOCAL
goto :EOF

:get_timestamp
:: Return date time string into first parameter
:: Syntax: call :get_timestamp TIMESTAMP
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
:: Get current date/time
FOR /f "tokens=1,2,3,4 delims=/ " %%a IN ('date /t') DO (
  SET NOWDATE=%%d-%%b-%%c
)
SET NOWTIME=%TIME:~0,8%
SET NOWTIMEDATE=%NOWDATE% %NOWTIME%
ENDLOCAL&SET %1=%NOWTIMEDATE%
goto :EOF

:get_file_timestamp
:: Return filename date time string into first parameter
call :get_timestamp FILESAFETIMESTAMP
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
:: Get current date/time
FOR /f "tokens=1,2,3,4 delims=/ " %%a IN ('date /t') DO (
  SET NOWDATE=%%d%%b%%c
)
SET NOWTIME=%TIME:~0,8%
SET NOWTIME=%NOWTIME::=%
SET NOWTIMEDATE=%NOWDATE%_%NOWTIME%
ENDLOCAL&SET %1=%NOWTIMEDATE%
goto :EOF

:LCase
:UCase
:: Converts to upper/lower case variable contents
:: Syntax: CALL :UCase _VAR1 _VAR2
:: Syntax: CALL :LCase _VAR1 _VAR2
:: _VAR1 = Variable NAME whose VALUE is to be converted to upper/lower case
:: _VAR2 = NAME of variable to hold the converted value
:: Note: Use variable NAMES in the CALL, not values (pass "by reference")
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET _UCase=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
SET _LCase=a b c d e f g h i j k l m n o p q r s t u v w x y z
SET _Lib_UCase_Tmp=!%1!
IF /I "%0"==":UCase" SET _Abet=%_UCase%
IF /I "%0"==":LCase" SET _Abet=%_LCase%
FOR %%Z IN (%_Abet%) DO SET _Lib_UCase_Tmp=!_Lib_UCase_Tmp:%%Z=%%Z!
ENDLOCAL&SET %2=%_Lib_UCase_Tmp%
goto :EOF

:check_process_running
:: Check that specified process is running
:: Syntax: call :check_process_running VAR_PROCESS_NAME RETURN_VAR
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET APP=!%1!
SET RET=0
tasklist /FI "IMAGENAME eq %APP%" | find /I /N "%APP%">NUL
if "%ERRORLEVEL%" EQU "0" (
	SET RET=1
)
ENDLOCAL&SET %2=%RET%
goto :EOF

:check_command_exists
:: Check that specified command exists (registered) in the system
:: Syntax: call :check_process_running VAR_COMMAND_NAME RETURN_VAR
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET COMMAND=!%1!
SET RET=0
call %COMMAND%>nul
if "%ERRORLEVEL%" EQU "0" (
	SET RET=1
)
ENDLOCAL&SET %2=%RET%
goto :EOF

:end
call :msg "Script finished"
call :log "Script finished"
pause