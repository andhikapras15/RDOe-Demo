#!/bin/bash
#
################################################################################
# Date: 2022/06/28
# Desc: The script will be called by post-build.sh to import files
# Author:
################################################################################
# 
GAR=$1        # "Group/App/BuildRelease(Version)"
RDOEServer=$2 # The RDOe server instance configured in /opt/aldon/aldlmc/current/etc/aldcs.conf
ALD_USR=$3    # User name used for signon ald command.
ALD_PWD=$4    # User password

ALDCS_CFG="";
V_LMeSrv=''
SINST_LEN=`expr length ${RDOEServer}`
################################################################################
# Start with a clean log file.  
# The $$ includes you the process id (pid) of this shell script.
################################################################################
# set the path to the ${BUILD_LOCATION}
if [ -L $0 ]; then
	SCRIPT_LOCATION=$(dirname $(readlink -f "$0"))
else 
	SCRIPT_LOCATION=$(cd "$(dirname "$0")";pwd)	
fi

BUILD_LOCATION=${SCRIPT_LOCATION}/../target
IMPORT_PATH=${SCRIPT_LOCATION}/../target
LOG_FILE=${SCRIPT_LOCATION}/log/DemoImport_$$.log
if [ -e ${LOG_FILE} ]
then
   rm -f ${LOG_FILE}
	touch ${LOG_FILE}
	chmod a+rwx ${LOG_FILE}
    echo `date` >> ${LOG_FILE}
fi
echo `date` >> ${LOG_FILE}
echo "USR:["${ALD_USR}"]" >> ${LOG_FILE}

OS=`uname`
echo OS is ${OS}
################################################################################
# Start detecting whether there is the aldcs.conf exist.  
################################################################################
echo "### Detecting the aldcs.conf..." >> ${LOG_FILE}
if [ $OS != "OS400" ]; then
	if [ -e /etc/aldcs.conf ] 
	then
		ALDCS_CFG=/etc/aldcs.conf
		echo "### aldcs.conf was found[${ALDCS_CFG}]." >> ${LOG_FILE}
	elif [ -e /opt/aldon/aldonlmc/current/etc/aldcs.conf ]
	then
		ALDCS_CFG=/opt/aldon/aldonlmc/current/etc/aldcs.conf
		echo "### aldcs.conf was found[${ALDCS_CFG}]." >> ${LOG_FILE}
	else
		echo "Could not find the file aldcs.conf. Please check again!">> ${LOG_FILE}
		exit 1
	fi

	flgLMe="FALSE"
	#cat ${ALDCS_CFG} | while read line
	while read line
	do 
	    if [ $flgLMe == "FALSE" ]
	    then
	        if [[ -n "$line" && ${line:0:SINST_LEN} == ${RDOEServer} ]]
	        then 
	            flgLMe="TRUE"
	            V_LMeSrv=${line}
	            echo "### Found the server..." >> ${LOG_FILE}
	            echo ${line} >> ${LOG_FILE}            
	            break
	        fi        
	    fi
	done < ${ALDCS_CFG}

	array=(${V_LMeSrv//=/ })
	V_LMeSrv=${array[0]}

fi

#set the path to client
if [ $OS != "OS400" ]; then
	export PATH=$PATH:/opt/aldon/aldonlmc/current/bin
else
	export PATH=$PATH:/Aldon/aldonlmc/10.2/bin
fi


################################################################################
# Specify the folder which included the files to be imported
# Or specify the file(s) to be imported.
################################################################################
echo "------Import files--------" >> ${LOG_FILE}

if [ ! -d ${IMPORT_PATH} ] ; then
    mkdir -p ${IMPORT_PATH}
fi 
cd ${IMPORT_PATH}

echo "Enter the path ${IMPORT_PATH} to do ald import..." >> ${LOG_FILE}
# set the release details and perform the import

if [ $OS != "OS400" ]; then
# set the release details and perform the import
	/opt/aldon/aldonlmc/current/bin/ald initialize "${V_LMeSrv}:${GAR}" >> ${LOG_FILE} 2>&1
	/opt/aldon/aldonlmc/current/bin/ald initialize -l >> ${LOG_FILE} 2>&1
	/opt/aldon/aldonlmc/current/bin/ald signon ${ALD_USR} -p ${ALD_PWD} -q >> ${LOG_FILE} 2>&1
	/opt/aldon/aldonlmc/current/bin/ald newtaskasm -f buildDemo
	# do some process for Build
	echo "Import run starting..." >> ${LOG_FILE}

	/opt/aldon/aldonlmc/current/bin/ald import -e QUA -a buildDemo ${IMPORT_PATH}/* >> ${LOG_FILE} 2>&1
	/opt/aldon/aldonlmc/current/bin/ald signoff >> ${LOG_FILE} 2>&1
	echo "### The end ###" >> ${LOG_FILE}
else
	/Aldon/aldonlmc/10.2/bin/ald initialize "${RDOEServer}:${GAR}" >> ${LOG_FILE} 2>&1
	/Aldon/aldonlmc/10.2/bin/ald initialize -l >> ${LOG_FILE} 2>&1
	/Aldon/aldonlmc/10.2/bin/ald signon ${ALD_USR} -p ${ALD_PWD} -q >> ${LOG_FILE} 2>&1
	/Aldon/aldonlmc/10.2/bin/ald newtaskasm -f buildDemo
	# do some process for Build
	echo "Import run starting..." >> ${LOG_FILE}

	/Aldon/aldonlmc/10.2/bin/ald import -e QUA -a buildDemo ${IMPORT_PATH}/* >> ${LOG_FILE} 2>&1
	/Aldon/aldonlmc/10.2/bin/ald signoff >> ${LOG_FILE} 2>&1
	echo "### The end ###" >> ${LOG_FILE}
fi

#ENDOFTheFile########



