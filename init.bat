@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=Mortgage Demo
set AUTHORS=Babak Mozaffari, Andrew Block, Eric D. Schabell
set PROJECT=git@github.com:jbossdemocentral/bpms-mortgage-demo.git
set PRODUCT=JBoss BPM Suite
set JBOSS_HOME=%PROJECT_HOME%\target\jboss-eap-6.4
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments\
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_BIN=%JBOSS_HOME%\bin
set SRC_DIR=%PROJECT_HOME%installs
set SUPPORT_DIR=%PROJECT_HOME%support
set PRJ_DIR=%PROJECT_HOME%projects\mortgage-demo
set WEBSERVICE=jboss-bpmsuite-installer-6.1.0.ER2.jar
set BPMS=jboss-bpmsuite-6.2.0.CR1-installer.jar
set EAP=jboss-eap-6.4.0-installer.jar
set EAP_PATCH=jboss-eap-6.4.4-patch.zip
set VERSION=6.2

REM wipe screen.
cls

echo.
echo #################################################################
echo ##                                                             ##   
echo ##  Setting up the %DEMO%                               ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##     ####  ####   #   #      ### #   # ##### ##### #####     ##
echo ##     #   # #   # # # # #    #    #   #   #     #   #         ##
echo ##     ####  ####  #  #  #     ##  #   #   #     #   ###       ##
echo ##     #   # #     #     #       # #   #   #     #   #         ##
echo ##     ####  #     #     #    ###  ##### #####   #   #####     ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##  brought to you by,                                         ##   
echo ##            %AUTHORS%  ##
echo ##                                                             ##   
echo ##  %PROJECT%     ##
echo ##                                                             ##   
echo #################################################################
echo.

REM make some checks first before proceeding.	
if exist %SRC_DIR%\%EAP% (
        echo Product sources are present...
        echo.
) else (
        echo Need to download %EAP% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

if exist %SRC_DIR%\%EAP_PATCH% (
        echo Product patches are present...
        echo.
) else (
        echo Need to download %EAP_PATCH% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

if exist %SRC_DIR%\%BPMS% (
        echo Product sources are present...
        echo.
) else (
        echo Need to download %BPMS% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

REM Remove the old JBoss instance, if it exists.
if exist %JBOSS_HOME% (
         echo - removing existing JBoss product install...
         echo.
        
         rmdir /s /q "%JBOSS_HOME%"
)

REM Run installers.
echo EAP installer running now...
echo.
call java -jar %SRC_DIR%/%EAP% %SUPPORT_DIR%\installation-eap -variablefile %SUPPORT_DIR%\installation-eap.variables

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During JBoss EAP Installation!
	echo.
	GOTO :EOF
)

call set NOPAUSE=true

echo.
echo Applying JBoss EAP patch now...
echo.
call %JBOSS_HOME%/bin/jboss-cli.bat --command="patch apply %SRC_DIR%/%EAP_PATCH% --override-all"

if not "%ERRORLEVEL%" == "0" (
  echo.
	echo Error Occurred During JBoss EAP Patch Installation!
	echo.
	GOTO :EOF
)

echo JBoss BPM Suite installer running now...
echo.
call java -jar %SRC_DIR%\%BPMS% %SUPPORT_DIR%\installation-bpms -variablefile %SUPPORT_DIR%\installation-bpms.variables

if not "%ERRORLEVEL%" == "0" (
	echo Error Occurred During %PRODUCT% Installation!
	echo.
	GOTO :EOF
)

echo - enabling demo accounts role setup in application-roles.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\application-roles.properties" "%SERVER_CONF%"
echo. 

echo - setting up demo projects...
echo.

mkdir "%SERVER_BIN%\.niogit\"
xcopy /Y /Q /S "%SUPPORT_DIR%\bpm-suite-demo-niogit\*" "%SERVER_BIN%\.niogit\"
echo. 

REM Optional: uncomment this to install mock data for BPM Suite, providing 
REM           colorful BAM history charts and filled Process & Task dashboard 
REM           views.
REM
REM echo - setting up mock bpm dashboard data...
REM echo.
REM xcopy /Y /Q "%SUPPORT_DIR%\1000_jbpm_demo_h2.sql" "%SERVER_DIR%\dashbuilder.war\WEB-INF\etc\sql"
REM echo. 

echo - setting up standalone.xml configuration adjustments...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\standalone.xml" "%SERVER_CONF%"
echo.

echo - setup email task notification users...
echo.
xcopy "%SUPPORT_DIR%\userinfo.properties" "%SERVER_DIR%\business-central.war\WEB-INF\classes\"

echo Deploying web service that pulls out credit report of customer based on SSN...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\%WEBSERVICE%" "%SERVER_DIR%"
echo. 

echo.
echo You can now start the %PRODUCT% with %SERVER_BIN%\standalone.bat
echo.

echo PRE-LOAD MORTGAGE DEMO
echo ======================
echo To load the BPM with a set of process instances, you can run the following
echo command after you start JBoss BPM Suite, build and deploy the mortgage
echo project, then you can use the helper jar file found in the support directory
echo as follows:
echo. 
echo    java -jar jboss-mortgage-demo-client.jar erics bpmsuite1!
echo.

echo %PRODUCT% %VERSION% %DEMO% Setup Complete.
echo.
