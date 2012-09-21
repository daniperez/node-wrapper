@echo off
@rem ##########################################################################
@rem
@rem  node-wrapper startup script for Windows
@rem
@rem ##########################################################################
set NODEJS_VERSION=0.8.9
set NPM_VERSION=1.1.9
set NODEJS_PREFIX=%CD%\.node
set NODEJS_URL=http://nodejs.org/dist/v%NODEJS_VERSION%/node.exe
set NPM_URL=http://nodejs.org/dist/npm/npm-%NPM_VERSION%.zip
set LOG_FILE=node-wrapper.log
set ZIP=7za.exe
@rem ##########################################################################

set _NODE_JS_EXE=%NODEJS_PREFIX%\node-%NODEJS_VERSION%.exe
set _NPM_ZIP=%NODEJS_PREFIX%\npm-%NPM_VERSION%.zip

@rem We create the log file and Node's folder.
echo > %LOG_FILE%
if NOT EXIST "%NODEJS_PREFIX%" mkdir %NODEJS_PREFIX%

if EXIST "%_NODE_JS_EXE%" goto installnpm

@rem ##########################################################################
:installnodejs
@rem ##########################################################################
echo Downloading nodejs into %NODEJS_PREFIX% (be patient, it can take several minutes)

@bitsadmin /cancel NodeJsDownloadJob > %LOG_FILE%
@bitsadmin /create NodeJsDownloadJob >> %LOG_FILE%
@bitsadmin /addfile NodeJsDownloadJob %NODEJS_URL% %_NODE_JS_EXE% >> %LOG_FILE%
@bitsadmin /resume NodeJsDownloadJob >> %LOG_FILE%

:loop
FOR /F "delims=" %%d in ('bitsadmin /RawReturn /GetState NodeJsDownloadJob') do @set state=%%d
@sleep 1
echo|set /p=". "
if not "%state%" == "TRANSFERRED" goto loop
echo ""

@bitsadmin /complete NodeJsDownloadJob >> %LOG_FILE%

@rem ##########################################################################
:installnpm
@rem ##########################################################################

if EXIST "%_NPM_ZIP%" goto unzipnpm

echo Downloading npm into %NODEJS_PREFIX% (be patient, it can take several minutes)

@bitsadmin /cancel NpmDownloadJob > %LOG_FILE%
@bitsadmin /create NpmDownloadJob >> %LOG_FILE%
@bitsadmin /addfile NpmDownloadJob %NPM_URL% %_NPM_ZIP% >> %LOG_FILE%
@bitsadmin /resume NpmDownloadJob >> %LOG_FILE%

:loop
FOR /F "delims=" %%d in ('bitsadmin /RawReturn /GetState NpmDownloadJob') do @set state=%%d
@sleep 1
echo|set /p=". "
if not "%state%" == "TRANSFERRED" goto loop
echo ""

@bitsadmin /complete NpmDownloadJob >> %LOG_FILE%

:unzipnpm
echo Installing npm
"%ZIP%" x -o"%NODEJS_PREFIX%" -y "%_NPM_ZIP%" >> %LOG_FILE%

echo Done!
