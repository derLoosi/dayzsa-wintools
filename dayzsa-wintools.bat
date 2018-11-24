@echo off

REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM !!! THERE SHOULD BE NO NEED TO EDIT SOMETHING IN THIS FILE !!! THERE SHOULD BE NO NEED TO EDIT SOMETHING IN THIS FILE !!!
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:start
cls
echo loading settings
call settings.bat

echo checking steamcmd
IF NOT EXIST "%steamcmd_dir%\%steamcmd_exe%" (
	echo could not find "%steamcmd_dir%\%steamcmd_exe%" - check the configuration of this script!
	exit /b
)

echo checking server_dir
IF NOT EXIST "%server_dir%" (
	echo serverdir "%server_dir%" not found, we need to install the server first!
	SET "server_init=true"
	goto update
) ELSE (
	SET "server_init=false"
)

:movelogs
echo +--------------------------+
echo +       MOVING  LOGS       +
echo +--------------------------+
IF NOT EXIST "%server_dir%\%server_instance%\logs" ( mkdir "%server_dir%\%server_instance%\logs" )
IF NOT EXIST "%server_dir%\%server_instance%\logs\RPT" ( mkdir "%server_dir%\%server_instance%\logs\RPT" )
IF NOT EXIST "%server_dir%\%server_instance%\logs\ADM" ( mkdir "%server_dir%\%server_instance%\logs\ADM" )

move "%server_dir%\%server_instance%\*.RPT" "%server_dir%\%server_instance%\logs\RPT\"
move "%server_dir%\%server_instance%\*.ADM" "%server_dir%\%server_instance%\logs\ADM\"
move "%server_dir%\%server_instance%\*.log" "%server_dir%\%server_instance%\logs\"

:backup
echo +--------------------------+
echo +          BACKUP          +
echo +--------------------------+

IF "%BACKUP_FOLDER%" == "" (
	echo BACKUP_FOLDER not set - skipping backup!
	goto update
)

IF NOT EXIST "%BACKUP_FOLDER%" (
	echo could not find "%BACKUP_FOLDER%" - check your config!
	exit /b
)

call :setdatetime
SET "BACKUP_FOLDER_CUR=%BACKUP_FOLDER%\%year%%month%%day%_%hour%%min%%secs%"
robocopy.exe "%server_dir%\mpmissions" "%BACKUP_FOLDER_CUR%\mpmissions" /MIR /ETA
robocopy.exe "%server_dir%\%server_instance%" "%BACKUP_FOLDER_CUR%\%server_instance%" /MIR /ETA /XF *.RPT

IF "%sevenzip_exe%" == "" (
	echo sevenzip_exe not set - skipping compression!
	goto update
)

IF NOT EXIST "%sevenzip_exe%" (
	echo could not find %sevenzip_exe% - check your config!
	exit /b
) ELSE (
	echo compressing backup
	"%sevenzip_exe%" a -t7z "%BACKUP_FOLDER%\%year%%month%%day%_%hour%%min%%secs%.7z" "%BACKUP_FOLDER_CUR%"
	rmdir /s /q "%BACKUP_FOLDER_CUR%"
)

:update
echo +--------------------------+
echo +     UPDATE/VALIDATE      +
echo +--------------------------+
"%steamcmd_dir%\%steamcmd_exe%" +login %steamcmd_user% %steamcmd_pass% +force_install_dir %server_dir% +app_update %steamcmd_appid% validate +quit

:serverinit
IF "%server_init%" == "true" (
	echo +--------------------------+
	echo +       SERVER INIT        +
	echo +--------------------------+
	echo generating server profile folder
	mkdir "%server_dir%\%server_instance%"
	mkdir "%server_dir%\%server_instance%\battleye"
	copy /y "%server_dir%\battleye" "%server_dir%\%server_instance%\battleye"

	echo generating bec server config
	echo RConPassword changeme > "%server_dir%\%server_instance%\battleye\beserver_x64.cfg"
	echo RConPort 2309 >> "%server_dir%\%server_instance%\battleye\beserver_x64.cfg"
	echo RConIP 127.0.0.1 >> "%server_dir%\%server_instance%\battleye\beserver_x64.cfg"
	
	echo RConPassword changeme > "%server_dir%\%server_instance%\battleye\beserver.cfg"
	echo RConPort 2309 >> "%server_dir%\%server_instance%\battleye\beserver.cfg"
	echo RConIP 127.0.0.1 >> "%server_dir%\%server_instance%\battleye\beserver.cfg"
	
	echo generating default server config
	echo hostname = "DayZ Server"; > "%server_dir%\%server_instance%\server.cfg"
	echo password = ""; >> "%server_dir%\%server_instance%\server.cfg"
	echo passwordAdmin = "Sh0uldB3Ch@ng€d"; >> "%server_dir%\%server_instance%\server.cfg"
	echo maxPlayers = 10; >> "%server_dir%\%server_instance%\server.cfg"
	echo verifySignatures = 2; >> "%server_dir%\%server_instance%\server.cfg"
	echo forceSameBuild = 1; >> "%server_dir%\%server_instance%\server.cfg"
	echo disableVoN = 0; >> "%server_dir%\%server_instance%\server.cfg"
	echo vonCodecQuality = 15; >> "%server_dir%\%server_instance%\server.cfg"
	echo disable3rdPerson=0; >> "%server_dir%\%server_instance%\server.cfg"
	echo disableCrosshair=0; >> "%server_dir%\%server_instance%\server.cfg"
	echo serverTime="2038/02/28/09/00"; >> "%server_dir%\%server_instance%\server.cfg"
	echo serverTimeAcceleration=1; >> "%server_dir%\%server_instance%\server.cfg"
	echo serverTimePersistent=0; >> "%server_dir%\%server_instance%\server.cfg"
	echo guaranteedUpdates=1; >> "%server_dir%\%server_instance%\server.cfg"
	echo loginQueueConcurrentPlayers=5; >> "%server_dir%\%server_instance%\server.cfg"
	echo loginQueueMaxPlayers=10; >> "%server_dir%\%server_instance%\server.cfg"
	echo instanceId = 1; >> "%server_dir%\%server_instance%\server.cfg"
	echo lootHistory = 1; >> "%server_dir%\%server_instance%\server.cfg"
	echo storeHouseStateDisabled = false; >> "%server_dir%\%server_instance%\server.cfg"
	echo storageAutoFix = 1; >> "%server_dir%\%server_instance%\server.cfg"
	echo class Missions >> "%server_dir%\%server_instance%\server.cfg"
	echo { >> "%server_dir%\%server_instance%\server.cfg"
	echo 	class DayZ >> "%server_dir%\%server_instance%\server.cfg"
	echo 	{ >> "%server_dir%\%server_instance%\server.cfg"
	echo 		template="dayzOffline.chernarusplus"; >> "%server_dir%\%server_instance%\server.cfg"
	echo 	}; >> "%server_dir%\%server_instance%\server.cfg"
	echo }; >> "%server_dir%\%server_instance%\server.cfg"
)

:server
echo +--------------------------+
echo +       APOCALYPSE         +
echo +--------------------------+
start "DayZ Server" /D "%server_dir%" /MIN /WAIT "%server_exe%" "-config=%server_dir%\%server_instance%\server.cfg" "-profiles=%server_dir%\%server_instance%" "-BEpath=%server_dir%\%server_instance%\battleye" -port=%server_port% %server_parameters%
timeout /t 10 /nobreak
goto start

:setdatetime
set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
set min=%time:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%
set secs=%time:~6,2%
if "%secs:~0,1%" == " " set secs=0%secs:~1,1%
set year=%date:~-4%
set month=%date:~3,2%
set day=%date:~0,2%
set datetimef=%day%.%month%.%year% %hour%:%min%:%secs%
EXIT /B 0