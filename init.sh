#!/bin/sh 
DEMO="Mortgage Demo"
AUTHORS="Babak Mozaffari, Eric D. Schabell"
PROJECT="git@github.com:eschabell/bpms-mortgage-demo.git"
PRODUCT="JBoss BPM Suite"
JBOSS_HOME=./target/jboss-eap-6.1
SERVER_DIR=$JBOSS_HOME/standalone/deployments/
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin/
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects/mortage-demo
EAP=jboss-eap-6.1.0.zip
BPMS=jboss-bpms-6.0.0-redhat-3-eap6.zip
VERSION=6.0.0.Beta

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
echo "##             ${AUTHORS}               ##"
echo "##                                                             ##"   
echo "##  ${PROJECT}            ##"
echo "##                                                             ##"   
echo "#################################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# make some checks first before proceeding.	
if [[ -r $SRC_DIR/$EAP || -L $SRC_DIR/$EAP ]]; then
		echo EAP sources are present...
		echo
else
		echo Need to download $EAP package from the Customer Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

# Create the target directory if it does not already exist.
if [ ! -x target ]; then
		echo "  - creating the target directory..."
		echo
		mkdir target
else
		echo "  - detected target directory, moving on..."
		echo
fi

# Move the old JBoss instance, if it exists, to the OLD position.
if [ -x $JBOSS_HOME ]; then
		echo "  - existing JBoss Enterprise EAP 6 detected..."
		echo
		echo "  - moving existing JBoss Enterprise EAP 6 aside..."
		echo
		rm -rf $JBOSS_HOME.OLD
		mv $JBOSS_HOME $JBOSS_HOME.OLD

		# Unzip the JBoss EAP instance.
		echo Unpacking JBoss Enterprise EAP 6...
		echo
		unzip -q -d target $SRC_DIR/$EAP
else
		# Unzip the JBoss EAP instance.
		echo Unpacking new JBoss Enterprise EAP 6...
		echo
		unzip -q -d target $SRC_DIR/$EAP
fi

# Unzip the required files from JBoss product deployable.
echo Unpacking $PRODUCT $VERSION...
echo
unzip -q -o -d target $SRC_DIR/$BPMS

echo "  - enabling demo accounts logins in application-users.properties file..."
echo
cp $SUPPORT_DIR/application-users.properties $SERVER_CONF

echo "  - enabling demo accounts role setup in application-roles.properties file..."
echo
cp $SUPPORT_DIR/application-roles.properties $SERVER_CONF

# Add execute permissions to the standalone.sh script.
echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

echo "You can now start the $PRODUCT with ${SERVER_BIN}standalone.sh"
echo

echo "$PRODUCT $VERSION $DEMO Setup Complete."
echo

