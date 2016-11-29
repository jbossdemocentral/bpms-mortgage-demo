#!/bin/sh
DEMO="Mortgage Demo"
AUTHORS="Babak Mozaffari, Andrew Block,"
AUTHORS2="Eric D. Schabell, Duncan Doyle"
PROJECT="git@github.com:jbossdemocentral/bpms-mortgage-demo.git"
PRODUCT="JBoss BPM Suite"
VERSION=6.4
TARGET=./target
JBOSS_HOME=$TARGET/jboss-eap-7.0
SERVER_DIR=$JBOSS_HOME/standalone/deployments/
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects/mortgage-demo
WEBSERVICE=jboss-mortgage-demo-ws.war
BPMS=jboss-bpmsuite-6.4.0.GA-deployable-eap7.x.zip
EAP=jboss-eap-7.0.0-installer.jar
#EAP_PATCH=jboss-eap-6.4.7-patch.zip

# wipe screen.
clear

echo
echo "#################################################################"
echo "##                                                             ##"
echo "##  Setting up the ${DEMO}                               ##"
echo "##                                                             ##"
echo "##                                                             ##"
echo "##     ####  ####   #   #      ### #   # ##### ##### #####     ##"
echo "##     #   # #   # # # # #    #    #   #   #     #   #         ##"
echo "##     ####  ####  #  #  #     ##  #   #   #     #   ###       ##"
echo "##     #   # #     #     #       # #   #   #     #   #         ##"
echo "##     ####  #     #     #    ###  ##### #####   #   #####     ##"
echo "##                                                             ##"
echo "##                                                             ##"
echo "##  brought to you by,                                         ##"
echo "##		${AUTHORS}		       ##"
echo "##		${AUTHORS2}		       ##"
echo "##                                                             ##"
echo "##  ${PROJECT}     ##"
echo "##                                                             ##"
echo "#################################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# make some checks first before proceeding.
if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	echo Product sources are present...
	echo
else
	echo Need to download $EAP package from the Customer Portal
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

#if [ -r $SRC_DIR/$EAP_PATCH ] || [ -L $SRC_DIR/$EAP_PATCH ]; then
#	echo Product patches are present...
#	echo
#else
#	echo Need to download $EAP_PATCH package from the Customer Portal
#	echo and place it in the $SRC_DIR directory to proceed...
#	echo
#	exit
#fi

if [ -r $SRC_DIR/$BPMS ] || [ -L $SRC_DIR/$BPMS ]; then
	echo Product sources are present...
	echo
else
	echo Need to download $BPMS package from the Customer Portal
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

# Remove the old JBoss instance, if it exists.
if [ -x $JBOSS_HOME ]; then
	echo "  - removing existing JBoss product..."
	echo
	rm -rf $JBOSS_HOME
fi

# Run installers.
echo "JBoss EAP installer running now..."
echo
java -jar $SRC_DIR/$EAP $SUPPORT_DIR/installation-eap -variablefile $SUPPORT_DIR/installation-eap.variables

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during JBoss EAP installation!
	exit
fi

#echo
#echo "Applying JBoss EAP 6.4.4 patch now..."
#echo
#$JBOSS_HOME/bin/jboss-cli.sh --command="patch apply $SRC_DIR/$EAP_PATCH --override-all"
#
#if [ $? -ne 0 ]; then
#	echo
#	echo Error occurred during JBoss EAP patching!
#	exit
#fi

echo
echo Deploying JBoss BPM Suite now...
echo
unzip -qo $SRC_DIR/$BPMS -d $TARGET
if [ $? -ne 0 ]; then
	echo Error occurred during $PRODUCT installation!
	exit
fi

echo
echo "  - enabling demo accounts role setup in application-roles.properties file..."
echo
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u bpmsAdmin -p bpmsuite1! -ro analyst,admin,user,manager,taskuser,reviewerrole,employeebookingrole,kie-server,rest-all --silent
$JBOSS_HOME/bin/add-user.sh -a -r ApplicationRealm -u erics -p bpmsuite1! -ro analyst,admin,user,manager,taskuser,reviewerrole,employeebookingrole,kie-server,rest-all --silent

echo "  - setting up demo projects..."
echo
cp -r $SUPPORT_DIR/bpm-suite-demo-niogit $SERVER_BIN/.niogit

echo "Deploying web service that pulls out credit report of customer based on SSN..."
echo
cp $SUPPORT_DIR/$WEBSERVICE $SERVER_DIR

echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone.xml $SERVER_CONF

echo "  - setup email task notification users..."
echo
cp $SUPPORT_DIR/userinfo.properties $SERVER_DIR/business-central.war/WEB-INF/classes/

echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

# Optional: uncomment this to install mock data for BPM Suite.
#
#echo - setting up mock bpm dashboard data...
#cp $SUPPORT_DIR/1000_jbpm_demo_h2.sql $SERVER_DIR/dashbuilder.war/WEB-INF/etc/sql
#echo

echo
echo "============================================================================"
echo "=                                                                          ="
echo "=  You can now start the $PRODUCT with:                             ="
echo "=                                                                          ="
echo "=   $SERVER_BIN/standalone.sh                               ="
echo "=                                                                          ="
echo "=  Login into business central at:                                         ="
echo "=                                                                          ="
echo "=    http://localhost:8080/business-central  (u:bpmsAdmin / p:bpmsuite1!)  ="
echo "=                                                                          ="
echo "=  See README.md for general details to run the various demo cases.        ="
echo "=                                                                          ="
echo "= PRE-LOAD DEMO                                                            ="
echo "= =============                                                            ="
echo "= To load the BPM with a set of process instances, you can run the         ="
echo "= followin command after you start JBoss BPM Suite, build and deploy the   ="
echo "= mortgage project, then you can use the helper jar file found in the      ="
echo "= support directory as follows:                                            ="
echo "=                                                                          ="
echo "=   java -jar jboss-mortgage-demo-client.jar erics bpmsuite1!              ="
echo "=                                                                          ="
echo "=  $PRODUCT $VERSION $DEMO Setup Complete.                       ="
echo "=                                                                          ="
echo "============================================================================"
