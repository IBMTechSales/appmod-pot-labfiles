######################
#  setup-docker-network.sh 
######################

## No input parameters required to run this script. 
## -i  If you want to run the commands in the script by being prompted to continue
## exmple: build-container.sh -i

numParms=$#
parm1=$1

#echo "numparms: $numParms"

STUDENT_LAB_DIR="/home/techzone/Student/labs/appmod"
STUDENT_PBW_BUNDLE="/home/techzone/Student/labs/appmod/pbw-bundle-complete"
PWD=pwd



cd $STUDENT_PBW_BUNDLE

#echo ""
#echo "-> working directory: $PWD" | tee $LOG
#echo ""
# Cleanup any existing components


# if db2 is running, check if its connected to pbw network
# if it is, disconnect from the network, then stop the db
#
echo ""
echo "----------------------"
echo "Running cleanup steps" 
echo "----------------------"


sleep 2

#stop the pbw container, if running
echo "-> Esnure pbw application is stopped"
/home/techzone/wlp/bin/server stop pbwserver > /dev/null 2>&1
sleep 1
docker stop pbw > /dev/null 2>&1
sleep 2

# Just disconnect db2_demo_data from pbw-network, and ignore errors in case it is not connected. 
echo "-> Esnure db2_demo_data is disconnected from pbw-network"
docker network disconnect -f pbw-network db2_demo_data > /dev/null 2>&1
sleep 2

echo "-> Ensure db2_demo_data is stopped"
docker stop db2_demo_data > /dev/null 2>&1
sleep 2

echo "-> Ensure docker network 'pbw-network' is removed"
docker network rm pbw-network > /dev/null 2>&1
sleep 2

echo "----------------------"
echo "End of cleanup steps"
echo "----------------------"

sleep 2


#build the container


echo ""
echo "=======================================" 
echo "Setup docker network for DB2 and PBW containers" 
echo "=======================================" 
echo ""

echo ""
echo "==========================================="
echo "1. Start PBW database in container"
echo "--------------------------"
echo " " 
echo "   ---> docker start db2_demo_data" 
echo " " 
echo "--------------------------"
echo ""
sleep 2
docker start db2_demo_data
sleep 2


echo ""
echo "==========================================="
echo "2. Create the docker network, pbw-network"
echo "---------------------------------"
echo " " 
echo "   ---> docker network create pbw-network" 
echo " " 
echo "---------------------------------"
echo ""
sleep 2
docker network create pbw-network
sleep 2

echo ""
echo "==========================================="
echo "3. Connect database container to the Docker network"
echo "------------------------------------------------"
echo " " 
echo "   ---> docker network connect pbw-network db2_demo_data" 
echo " " 
echo "------------------------------------------------"
echo ""
sleep 2 
docker network connect pbw-network db2_demo_data
sleep 2


echo "" 
echo "====================================" 
echo "setup-docker-network script complete" 
echo "====================================" 
echo "" 

exit 0