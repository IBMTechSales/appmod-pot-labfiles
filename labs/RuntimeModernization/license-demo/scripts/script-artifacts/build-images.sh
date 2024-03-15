######################
#  build-images.sh 
######################

## No input parameters required to run this script. 

LICENSE_DEMO_DIR="/home/techzone/Student/labs/appmod/license-demo"
PBW_BUILD_DIR="$LICENSE_DEMO_DIR/pbw_migrationBundle"
RESORTS_BUILD_DIR="$LICENSE_DEMO_DIR/modresorts_migrationBundle"

OC_PROJECT="license-demo"


#Verify the build directories exist. The demo-setup script creates them

if [ ! -d "$PBW_BUILD_DIR" ]; then
     echo ""
     echo "ERROR! Directory does not exist: $PBW_BUILD_DIR"
     echo "Exiting!"
     exit 1
fi

if [ ! -d "$RESORTS_BUILD_DIR" ]; then
     echo ""
     echo "ERROR! Directory does not exist: $RESORTS_BUILD_DIR"
     echo "Exiting!"
     exit 1
fi

# Build the pbw docker image

cd $PBW_BUILD_DIR
sleep 1
echo ""
echo "-> working directory: $PWD" 
echo ""

ls -al
sleep 2

echo ""
echo "--------------------------------------"
echo "---> Build and tag the 'PlantsByWebSphere'application container image"
echo "--------------------------------------"
echo ""
echo "   ---> docker build -f $PBW_BUILD_DIR/Containerfile --tag default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/pbw:1.0 ." 
echo " " 
echo "--------------------------------------------------"
sleep 5
docker build -f $PBW_BUILD_DIR/Containerfile --tag default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/pbw:1.0 .

sleep 2 

cd $RESORTS_BUILD_DIR
sleep 1
echo ""
echo "-> working directory: $PWD" 
echo ""
ls -al

sleep 2


echo ""
echo "--------------------------------------"
echo "---> Build and tag the 'modresorts'application container image"
echo "--------------------------------------"
echo ""
echo "   ---> docker build -f $RESORTS_BUILD_DIR/Containerfile --tag default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/resorts:1.0 ." 
echo " " 
echo "--------------------------------------------------"
sleep 5
docker build -f $RESORTS_BUILD_DIR/Containerfile --tag default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/resorts:1.0 .

sleep 2


#Push the PBW and Resorts images to OCP internal registry

echo ""
echo "--------------------------------------"
echo "---> Login to OCP"
echo "--------------------------------------"
echo ""
echo "   ---> oc login -u ocadmin -p ibmrhocp" 
echo "--------------------------"
echo ""
sleep 3
oc login -u ocadmin -p ibmrhocp
sleep 3
echo ""
echo "--------------------------------------"
echo "---> go to the '$OC_PROJECT' project"
echo "--------------------------------------"
echo ""
echo "   ---> oc project $OC_PROJECT" 
echo "--------------------------"
echo ""
sleep 3
oc project $OC_PROJECT
sleep 2

echo ""
echo "--------------------------------------"
echo "---> Login to the OCP internal registry"
echo "--------------------------------------"
echo ""
echo "   ---> docker login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp.ibm.edu" 
echo "--------------------------"
echo ""
sleep 3
docker login -u $(oc whoami) -p $(oc whoami -t) default-route-openshift-image-registry.apps.ocp.ibm.edu
sleep 2

echo ""
echo "--------------------------------------"
echo "---> Push the PBW image to OCP internal registry"
echo "--------------------------------------"
echo ""
echo "   ---> docker push default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/pbw:1.0" 
echo " "
sleep 3
docker push default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/pbw:1.0
sleep 2


echo ""
echo "--------------------------------------"
echo "---> Push the modresorts images to OCP internal registry"
echo "--------------------------------------"
echo ""
echo "   ---> docker push default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/resorts:1.0" 
echo " "
sleep 3
docker push default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/resorts:1.0
sleep 2

echo ""
echo "--------------------------------------"
echo "---> List the two contaier image streams in OCP"
echo "--------------------------------------"
echo ""
sleep 2
oc get is -n $OC_PROJECT
echo ""


echo "================================" 
echo "build-images script completed" 
echo "================================" 
echo "" 


echo "=========================================" 
echo "The licensing demo environment is READY!."
echo "=========================================" 
echo "" 


exit 0