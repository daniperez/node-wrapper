@echo off
@rem ##########################################################################
@rem
@rem  Buildr startup script for Windows
@rem
@rem ##########################################################################
set JRUBY_VERSION=1.6.5.1
set JRUBY_URL=http://jruby.org.s3.amazonaws.com/downloads/%JRUBY_VERSION%/jruby-bin-%JRUBY_VERSION%.zip
set JRUBY_BOOTSTRAP_HOME=%TEMP%
set JRUBY_ZIP=%JRUBY_BOOTSTRAP_HOME%\jruby-%JRUBY_VERSION%.zip
set JRUBY_DESTINATION_FOLDER=%JRUBY_BOOTSTRAP_HOME%
set JRUBY_ROOT=%JRUBY_DESTINATION_FOLDER%\jruby-%JRUBY_VERSION%
set LOG_FILE=buildr-bootstrap.log
@rem ##########################################################################

echo (writing a log of the setup process to %cd%\%LOG_FILE%)

echo %CD%

echo > %LOG_FILE%

if EXIST "%CD%\buildr.bat" GOTO eclipse

if EXIST "%JRUBY_ZIP%" GOTO unzipjruby

if EXIST "%JRUBY_DESTINATION_FOLDER%" GOTO installbuildr

@rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:downloadjruby
@rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Downloading jruby

@bitsadmin /reset > %LOG_FILE%
@bitsadmin /create JRubyDownloadJob > %LOG_FILE%
@bitsadmin /addfile JRubyDownloadJob %JRUBY_URL% %JRUBY_ZIP% >> %LOG_FILE%
@bitsadmin /resume JRubyDownloadJob >> %LOG_FILE%

:loop
FOR /F "delims=" %%d in ('bitsadmin /RawReturn /GetState JRubyDownloadJob') do @set state=%%d
@sleep 1
if not "%state%" == "TRANSFERRED" goto loop

@bitsadmin /complete JRubyDownloadJob >> %LOG_FILE%

@rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:unzipjruby
@rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Unzipping jruby
"c:\Program Files\7-Zip\7z.exe" x -o "%JRUBY_DESTINATION_FOLDER%" -y "%JRUBY_ZIP%" >> %LOG_FILE%

@rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:installbuildr
@rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Installing buildr
"%JRUBY_ROOT%\bin\jruby.exe" -S jgem  install buildr >> %LOG_FILE%

@rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
:eclipse
@rem ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

echo Generating buildr script
echo cd /D %CD% > buildr.bat
echo %JRUBY_ROOT%\bin\jruby.bat %JRUBY_ROOT%\bin\buildr %%* >> buildr.bat

echo Softly massaging Eclipse
set ECLIPSE_PROJECT_HOME=.
if NOT EXIST buildfile set /P ECLIPSE_PROJECT_HOME="Can you tell me the path to your Eclipse project or just Ctrl+C if none? "
PUSHD "%ECLIPSE_PROJECT_HOME%"
del /Q /F .classpath 
del /Q /F .project

"%JRUBY_ROOT%\bin\jruby.bat" "%JRUBY_ROOT%\bin\buildr" -f buildfile eclipse artifacts:javadoc
POPD
