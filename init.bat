@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=Mortgage Demo
set AUTHORS=Babak Mozaffari, Eric D. Schabell
set PROJECT=git@github.com:eschabell/bpms-mortgage-demo.git
set PRODUCT=JBoss BPM Suite
set JBOSS_HOME=%PROJECT_HOME%\target\jboss-eap-6.1
set SERVER_DIR=%JBOSS_HOME%\standalone\deployments\
set SERVER_CONF=%JBOSS_HOME%\standalone\configuration\
set SERVER_BIN=%JBOSS_HOME%\bin
set SRC_DIR=%PROJECT_HOME%\installs
set SUPPORT_DIR=%PROJECT_HOME%\support
set PRJ_DIR=%PROJECT_HOME%\projects\mortgage-demo
set EAP=jboss-eap-6.1.1.zip
set BPMS=jboss-bpms-6.0.1.GA-redhat-2-deployable-eap6.x.zip
set WEBSERVICE=jboss-mortgage-demo-ws.war
set VERSION=6.0.1.GA

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
echo ##             %AUTHORS%               ##
echo ##                                                             ##   
echo ##  %PROJECT%            ##
echo ##                                                             ##   
echo #################################################################
echo.

REM make some checks first before proceeding.	
if exist %SRC_DIR%\%EAP% (
        echo EAP sources are present...
        echo.
) else (
        echo Need to download %EAP% package from the Customer Support Portal
        echo and place it in the %SRC_DIR% directory to proceed...
        echo.
        GOTO :EOF
)

REM Create the target directory if it does not already exist.
if not exist %PROJECT_HOME%\target (
        echo - creating the target directory...
        echo.
        mkdir %PROJECT_HOME%\target
) else (
        echo - detected target directory, moving on...
        echo.
)

REM Move the old JBoss instance, if it exists, to the OLD position.
if exist %JBOSS_HOME% (
         echo - existing JBoss Enterprise EAP 6 detected...
         echo.
         echo - moving existing JBoss Enterprise EAP 6 aside...
         echo.
        
        if exist "%JBOSS_HOME%.OLD" (
                rmdir /s /q "%JBOSS_HOME%.OLD"
        )
        
         move "%JBOSS_HOME%" "%JBOSS_HOME%.OLD"
        
        REM Unzip the JBoss EAP instance.
        echo.
        echo Unpacking JBoss Enterprise EAP 6...
        echo.
        cscript /nologo %SUPPORT_DIR%\unzip.vbs %SRC_DIR%\%EAP% %PROJECT_HOME%\target
        
 ) else (
                
        REM Unzip the JBoss EAP instance.
        echo Unpacking new JBoss Enterprise EAP 6...
        echo.
        cscript /nologo %SUPPORT_DIR%\unzip.vbs %SRC_DIR%\%EAP% %PROJECT_HOME%\target
 )

REM Unzip the required files from JBoss product deployable.
echo Unpacking %PRODUCT% %VERSION%...
echo.
cscript /nologo %SUPPORT_DIR%\unzip.vbs %SRC_DIR%\%BPMS% %PROJECT_HOME%\target

echo - enabling demo accounts logins in application-users.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\application-users.properties" "%SERVER_CONF%"
echo. 

echo - enabling demo accounts role setup in application-roles.properties file...
echo.
xcopy /Y /Q "%SUPPORT_DIR%\application-roles.properties" "%SERVER_CONF%"
echo. 

echo - setting up demo projects...
echo.

mkdir "%SERVER_BIN%\.niogit\"
xcopy /Y /Q /S "%SUPPORT_DIR%\bpm-suite-demo-niogit\*" "%SERVER_BIN%\.niogit\"
xcopy /Y /Q /S "%SUPPORT_DIR%\bpm-suite-demo-index\*" "%SERVER_BIN%\.index\"
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
echo    java -jar jboss-mortgage-demo-client.jar erics bpmsuite
echo.

echo %PRODUCT% %VERSION% %DEMO% Setup Complete.
echo.
