#!/bin/bash
#
################################################################################
# Date: 2022/06/28
# Desc: The script just shows the usage of import files into a RDOe build relase.
# Author:
################################################################################

# Please make sure the params input sequece is right.
GROUP=$1;   # Group name
APP=$2;     # Application name
REL_B=$3;   # Build release name
VERSION=$4; # BuildRelease version

RDOEServer=$5 # The RDOe server instance configured in /opt/aldon/aldlmc/current/etc/aldcs.conf
USR=$6      # RDOe user used to signon ald command
PASSWD=$7   # RDOe user password
if [ -L $0 ]; then
	SCRIPT_LOCATION=$(dirname $(readlink -f "$0"))
else 
	SCRIPT_LOCATION=$(cd "$(dirname "$0")";pwd)	
fi

if [ -d ${SCRIPT_LOCATOIN} ] ; then
	mkdir -p ${SCRIPT_LOCATION}/log
fi
chmod -R a+rwx ${SCRIPT_LOCATION}/log

rm -rf ${SCRIPT_LOCATION}/log/*
SCRIPT_FILE=${SCRIPT_LOCATION}/DemoAldImport.sh
chmod a+x ${SCRIPT_LOCATION}/../*

LOG_FILE=${SCRIPT_LOCATION}/log/postbuild_$$.log
if [ -e ${LOG_FILE} ]
then
	rm -f ${LOG_FILE}
	touch ${LOG_FILE}
	chmod a+rwx ${LOG_FILE}
	echo `date` > ${LOG_FILE}
fi

echo  
echo "User:$USR"; 
echo "User: $USR"  >> ${LOG_FILE}
GAR="${GROUP}/${APP}/${REL_B}($VERSION)";
echo "Build Release GAR: ${GAR}" 
echo "Build Release GAR: ${GAR}" >>${LOG_FILE} 
#
################################################################################
# User Customized code for doing some other things. like compile/build project.
#  
################################################################################
# Compile the project ...

# Copy the output to a tmp folder

# The output file will be ${SCRIPT_LOCATION}/../target/RDOe-Demo-1.0.0.jar

TARGET_LOCATION=target/RDOe-Demo-1.0.0.jar
cd ${SCRIPT_LOCATION}
cd ..
./mvnw clean package >> ${LOG_FILE}
if [ ! -f ${TARGET_LOCATION} ]
then
	echo ${TARGET_LOCATION} does not exist! Please check the build. >> ${LOG_FILE}
   echo ${TARGET_LOCATION} does not exist! Please check the build.
	echo `date` >> ${LOG_FILE}
   exit 2
fi
chmod a+rwx ${SCRIPT_LOCATION}/../target

# 
################################################################################
# Calling the script to import the build .war/.jar back to 
# Group/App/BuildRelease(x.x.x) 
################################################################################
if [ ! -f ${SCRIPT_FILE} ] ; then
	echo ${SCRIPT_FILE} does not exist! Please check again.
	exit 3
fi
OS=`uname`
if [ $OS == "OS400" ]; then
   /bin/bash ${SCRIPT_FILE} ${GAR} ${RDOEServer} ${USR} ${PASSWD} >> ${LOG_FILE} 2>&1
else
   su - ${USR} -s /bin/bash ${SCRIPT_FILE} ${GAR} ${RDOEServer} ${USR} ${PASSWD} >> ${LOG_FILE} 2>&1
fi
