call env.bat

@echo off
:initdb
echo 初始化数据库目录[%DB_DATA_DIR%]
choice /C YNC /M "确认请按 Y，跳过请按 N，退出请按 C。"
if ERRORLEVEL 3 goto :EOF
if ERRORLEVEL 2 goto createuser
if exist %DB_DATA_DIR% rmdir /s %DB_DATA_DIR%
if exist %DB_DATA_DIR% goto createuser

mkdir %DB_DATA_DIR%
initdb.exe -U postgres -E UTF-8 -D %DB_DATA_DIR% --locale=zh_CN.UTF-8

:createuser
echo 创建数据库超级用户[openerp]
choice /C YNC /M "确认请按 Y，跳过请按 N，退出请按 C。"
if ERRORLEVEL 3 goto :EOF
if ERRORLEVEL 2 goto runtime
pg_ctl start -D %DB_DATA_DIR% -l %DB_LOG_FILE%
ping 127.0.0.1 -n 3 >nul
createuser -U postgres -s openerp
pg_ctl stop -D %DB_DATA_DIR% -l %DB_LOG_FILE% --silent --mode fast
pv.exe -f -k postgres.exe -q

:runtime
echo 生成openerp配置文件和运行脚本
choice /C YNC /M "确认请按 Y，跳过请按 N，退出请按 C。"
if ERRORLEVEL 3 goto :EOF
if ERRORLEVEL 2 goto end
if exist %CD%\runtime rmdir /s /q %CD%\runtime
mkdir %CD%\runtime

:openerp_server
set CONF=%CD%\runtime\openerp-server.conf
echo [options] >> %CONF%
echo ; This is the password that allows database operations: >> %CONF%
echo ; admin_passwd = admin >> %CONF%
echo db_host = 127.0.0.1 >> %CONF%
echo db_port = 5432 >> %CONF%
echo db_user = openerp >> %CONF%
echo db_password = openerp >> %CONF%
echo pg_path = %RUNTIME_DIR%/pgsql/bin >> %CONF%
echo addons_path = %OE_SRC_DIR%/addons >> %CONF%
echo ; logfile = openerp-server.log >> %CONF%
echo ; logrotate = True >> %CONF%
echo apps_server = localhost >> %CONF%

:start_pg
set START_PG=%CD%\runtime\start_pg.bat
echo call %CD%\env.bat >>%START_PG%
echo pg_ctl start -D %DB_DATA_DIR% -l %DB_LOG_FILE% >>%START_PG%

:stop_pg
set STOP_PG=%CD%\runtime\stop_pg.bat
echo call %CD%\env.bat >>%STOP_PG%
echo pg_ctl stop -D %DB_DATA_DIR% -l %DB_LOG_FILE% --silent --mode fast >>%STOP_PG%
echo pv.exe -f -k postgres.exe -q >>%STOP_PG%

:start_oe
set START_OE=%CD%\runtime\start_oe.bat
echo call %CD%\env.bat >>%START_OE%
echo python-oe.exe %OE_SRC_DIR%\openerp-server -c %CONF% >>%START_OE%

:stop_oe
set STOP_OE=%CD%\runtime\stop_oe.bat
echo call %CD%\env.bat >>%STOP_OE%
ECHO pv.exe -f -k python-oe.exe -q >>%STOP_OE%

:restart_oe
set RESTART_OE=%CD%\runtime\restart_oe.bat
echo call stop_oe.bat >>%RESTART_OE%
echo call start_oe.bat >> %RESTART_OE%

:start
set START=%CD%\runtime\start.bat
echo call start_pg.bat >>%START%
echo call start_oe.bat >>%START%

:stop
set STOP=%CD%\runtime\stop.bat
echo call stop_oe.bat >>%STOP%
echo call stop_pg.bat >>%STOP%

:EOF
echo on