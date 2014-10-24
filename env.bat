@echo off
title GreenOdoo - www.GreenOpenERP.com
COLOR 0A
set RUNTIME_DIR=E:\github\GreenOdoo-Runtime
set OE_SRC_DIR=E:\github\odoo
set DB_DATA_DIR=%CD%\data
set DB_LOG_FILE=%CD%\logfile

call :set_path %RUNTIME_DIR%\bin
call :set_path %RUNTIME_DIR%\pgsql\bin
call :set_path %RUNTIME_DIR%\python
call :set_path %RUNTIME_DIR%\win32\wkhtmltopdf
goto end

:set_path
set new_path=%~1
echo %PATH% | findstr /I "%new_path%" >nul
if ERRORLEVEL 1 set PATH=%new_path%;%PATH%
goto :EOF

:end
echo on