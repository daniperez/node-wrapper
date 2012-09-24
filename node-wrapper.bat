@echo off 
@rem ##########################################################################
@rem
@rem  node-wrapper startup script for Windows
@rem
@rem ##########################################################################
set NODEJS_VERSION=0.8.9
set NPM_VERSION=1.1.59
set NODEJS_PREFIX=%CD%\.node
set NODEJS_URL=http://nodejs.org/dist/v%NODEJS_VERSION%/node.exe
set NPM_URL=http://nodejs.org/dist/npm/npm-%NPM_VERSION%.zip
set LOG_FILE=node-wrapper.log
set ZIP=7za.exe
@rem ##########################################################################

set _NODE_JS_EXE=%NODEJS_PREFIX%\node.exe
set _NPM_ZIP=%NODEJS_PREFIX%\npm-%NPM_VERSION%.zip
set _NPM_EXE=%NODEJS_PREFIX%\npm.cmd

@rem We create the log file and Node's folder.
echo > %LOG_FILE%
if NOT EXIST "%NODEJS_PREFIX%" mkdir %NODEJS_PREFIX%

if NOT EXIST %_NODE_JS_EXE%  (
	echo Downloading nodejs into %NODEJS_PREFIX%. Be patient, it can take several minutes.
	
	@bitsadmin /cancel NodeJsDownloadJob > %LOG_FILE%
	@bitsadmin /create NodeJsDownloadJob >> %LOG_FILE%
	@bitsadmin /addfile NodeJsDownloadJob %NODEJS_URL% %_NODE_JS_EXE% >> %LOG_FILE%
	@bitsadmin /resume NodeJsDownloadJob >> %LOG_FILE%
	
	:loopnode
	FOR /F "delims=" %%d in ('bitsadmin /RawReturn /GetState NodeJsDownloadJob') do @set state=%%d
	@sleep 1
	echo|set /p=". "
	if not "%state%" == "TRANSFERRED" goto loopnode
	echo .
	
	@bitsadmin /complete NodeJsDownloadJob >> %LOG_FILE%
)

if not EXIST %_NPM_ZIP% (

	echo Downloading npm into %NODEJS_PREFIX%. Be patient, it can take several minutes.
	
	@bitsadmin /cancel NpmDownloadJob >> %LOG_FILE%
	@bitsadmin /create NpmDownloadJob >> %LOG_FILE%
	@bitsadmin /addfile NpmDownloadJob %NPM_URL% %_NPM_ZIP% >> %LOG_FILE%
	@bitsadmin /resume NpmDownloadJob >> %LOG_FILE%
	
	:loopnpm
	FOR /F "delims=" %%d in ('bitsadmin /RawReturn /GetState NpmDownloadJob') do @set state=%%d
	@sleep 1
	echo|set /p=". "
	if not "%state%" == "TRANSFERRED" goto loopnpm
	echo .
		
	@bitsadmin /complete NpmDownloadJob >> %LOG_FILE%
	
	echo Installing npm
	"%ZIP%" x -o"%NODEJS_PREFIX%" -y "%_NPM_ZIP%" >> %LOG_FILE%
)

set TOOL=""

call :guess_tool_name %*

if not %TOOL% == "" (
				
	SETLOCAL
	set PATH=%NODEJS_PREFIX%;%PATH%
	ENDLOCAL
	if not EXIST %NODEJS_PREFIX%\%TOOL%.cmd (

		IF ERRORLEVEL 0 (
			echo Installing %TOOL%...
			"%_NPM_EXE%" install -g "%TOOL%" >> %LOG_FILE% 2>&1
			echo ... installed.
		)
	)
			
	%NODEJS_PREFIX%\%TOOL%.cmd %*
)

@rem ##########################################################################
:guess_tool_name
  
  set basename=
  for /F %%i in ("%~f0") do set basename=%%~ni
  
  if  "%basename%" == "node-wrapper" (
    if "x%~1" == "x" (
       echo You called node-wrapper without arguments.
    ) else (
      set TOOL=%~1
      SHIFT
    )
  ) else (
  	for /F %%i in ("%~f0") do set TOOL=%%~ni
  )
