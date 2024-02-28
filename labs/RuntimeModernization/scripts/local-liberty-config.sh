##########################
#  local-liberty-config.sh 
##########################

## No input parameters required to run this script. 
## -i  If you want to run the commands in the script by being prompted to continue
## exmple: build-container.sh -i

numParms=$#
parm1=$1

#echo "numparms: $numParms"
#echo "parm 1: $1"

if [ $numParms != 0 ]; then
#  echo "numParms > 0, have parms"
  if [ $1 == "-i" ]; then
#    echo "parm1 is '-i"
    INTERACTIVE_MODE="true"
    echo ""
    echo "---------------------------------------------"
    echo "    Script is running in interactive mode! "
    echo "---------------------------------------------"
    echo ""
    sleep 5
  fi 
fi


STUDENT_LAB_DIR="/home/techzone/Student/labs/appmod"

PWD=pwd
LOGS=$STUDENT_LAB_DIR/logs
LOG=$STUDENT_LAB_DIR/logs/local-liberty-config.log

#create the LOGS directory if it does not exist
if [ ! -d "$LOGS" ]; then
     mkdir $LOGS ;
     echo "Create Logs Directory: $LOGS"
fi

#Remove the old log if it exists
if [  -f "$LOG" ]; then
    rm $LOG ;
    echo ""
    echo "removed $LOG"
fi

TA_DOWNLOADED_BUNDLE="/home/techzone/Downloads/plantsbywebsphereee6.ear_migrationBundle.zip"
PBW_BUNDLE_DIR="/home/techzone/Downloads/pbw-bundle"
DB2_DRIVERS_DIR="/home/techzone/Student/LabFiles/db2_drivers"
PBW_EAR_FILE="/home/techzone/appmod-pot-labfiles/labs/RuntimeModernization/plantsbywebsphereee6.ear"
WLP_LOCAL_DIR="/home/techzone/wlp"



#FAIL if the local Liberty server 'pbwserver' hasnot been created
echo ""
echo "Verifying the local Liberty server 'pbwserver' has been created"
echo ""
if [ ! -d "$WLP_LOCAL_DIR/usr/servers/pbwserver" ]; then
     echo ""
     echo "----------------------------------------------------------------"
     echo "---> FAIL: The Liberty server 'pbwserver' does not exist."
     echo "           You must create the server before running this script"
     echo " Exiting"
     echo "----------------------------------------------------------------"
     echo ""
     exit 1  
fi


#Stop the Liberty pbwserver server, if it is running
echo "" 
echo "stop the 'pbwserver' Liberty server, if it is running" 
$WLP_LOCAL_DIR/bin/server stop pbwserver > /dev/null 2>&1
echo ""  


sleep 2

#start DB2 database
echo "ensure PBW database is running"
echo ""
docker start db2_demo_data > /dev/null 2>&1

echo ""
echo "----------------------"
echo "Running cleanup steps" 
echo "----------------------"

sleep 2

#remove the extracted migration bundle dir if it exists
echo ""
echo "-> Cleaning up the extracted migration bundle"
if [ -d "$PBW_BUNDLE_DIR" ]; then
     rm -rf $PBW_BUNDLE_DIR ;
     echo "---> Bundle directory cleaned"
fi


#remove shared lib/gobal dir if it exists
echo ""
echo "-> cleaning up the shared libraries directory"
if [ -d "$WLP_LOCAL_DIR/usr/shared/config/lib/global" ]; then
     rm -rf $WLP_LOCAL_DIR/usr/shared/config/lib/global ;
     echo "---> shared global lib folder removed"
fi

echo ""
echo "-> cleaning up the pbw apps directory"
#remove pbw app from apps dir if it exists
if [  -f "$WLP_LOCAL_DIR/usr/servers/pbwserver/apps/plantsbywebsphereee6.ear" ]; then
    rm $WLP_LOCAL_DIR/usr/servers/pbwserver/apps/plantsbywebsphereee6.ear ;
    echo "---> removed the plantsbywebsphereee6.ear app"
fi

echo ""
echo "----------------------"
echo "Cleanup complete" 
echo "----------------------"
echo "" 
sleep 3

echo "" | tee $LOG
echo "=======================================" | tee -a $LOG
echo "Setup local Liberty server for PBW app" | tee -a $LOG
echo "=======================================" | tee -a $LOG
echo "" | tee -a $LOG


echo "" | tee -a $LOG
echo "===========================================" 
echo "1. Create a new directory to unpack the migration bundle" | tee -a $LOG
echo "--------------------------" 
echo " " 
echo "   1. ---> mkdir $PBW_BUNDLE_DIR" | tee -a $LOG
echo " " 
echo "--------------------------"
echo ""
sleep 2 


if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
mkdir $PBW_BUNDLE_DIR
sleep 2


echo "" | tee -a $LOG
echo "===========================================" 
echo "2. unzip the TA bundle to the new directory" | tee -a $LOG
echo "--------------------------" 
echo " " 
echo "   2. ---> unzip -d $PBW_BUNDLE_DIR $TA_DOWNLOADED_BUNDLE" | tee -a $LOG
echo " " 
echo "--------------------------"
echo ""
sleep 2 


if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
unzip -d $PBW_BUNDLE_DIR $TA_DOWNLOADED_BUNDLE
sleep 2


echo "" | tee -a $LOG
echo "===========================================" 
echo "3. create the shared lib/global dir" | tee -a $LOG
echo "--------------------------" 
echo " " 
echo "   3. ---> mkdir $WLP_LOCAL_DIR/usr/shared/config/lib/global" | tee -a $LOG
echo " " 
echo "--------------------------"
echo ""
sleep 2 


if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
mkdir $WLP_LOCAL_DIR/usr/shared/config/lib/global
sleep 2



echo "" | tee -a $LOG
echo "===========================================" 
echo "4. copy pbw DB2 drivers to shared/config/lib/global dir" | tee -a $LOG
echo "--------------------------" 
echo " " 
echo "   4. ---> cp $DB2_DRIVERS_DIR/*  $WLP_LOCAL_DIR/usr/shared/config/lib/global" | tee -a $LOG
echo " " 
echo "--------------------------"
echo ""
sleep 2 


if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
cp $DB2_DRIVERS_DIR/*  $WLP_LOCAL_DIR/usr/shared/config/lib/global
sleep 2


echo "" | tee -a $LOG
echo "===========================================" 
echo "5. copy pbw app to apps dir" | tee -a $LOG
echo "--------------------------" 
echo " " 
echo "   5. ---> cp $PBW_EAR_FILE  $WLP_LOCAL_DIR/usr/servers/pbwserver/apps" | tee -a $LOG
echo " " 
echo "--------------------------"
echo ""
sleep 2 


if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
cp $PBW_EAR_FILE  $WLP_LOCAL_DIR/usr/servers/pbwserver/apps
sleep 2



echo "" | tee -a $LOG
echo "===========================================" 
echo "6. cp server.xml from BUNDLE to usr/servers dir" | tee -a $LOG
echo "--------------------------" 
echo " " 
echo "   6. ---> cp $PBW_BUNDLE_DIR/src/main/liberty/config/server.xml $WLP_LOCAL_DIR/usr/servers/pbwserver" | tee -a $LOG
echo " " 
echo "--------------------------"
echo ""
sleep 2 


if [[ $INTERACTIVE_MODE == "true" ]]; then
  read -n 1 -r -s -p $'Press enter to continue...\n'
  echo ""
fi    
\cp $PBW_BUNDLE_DIR/src/main/liberty/config/server.xml $WLP_LOCAL_DIR/usr/servers/pbwserver
sleep 2


    
echo "" | tee -a $LOG
echo "========================================" | tee -a $LOG
echo "local-liberty-config.sh script completed" | tee -a $LOG
echo "========================================" | tee -a $LOG
echo "" | tee -a $LOG

exit 0