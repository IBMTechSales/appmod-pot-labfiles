######################
#  demo-setup.sh 
######################

## No input parameters required to run this script. 
#  The script canbe run multiple times without harm!

OC_PROJECT="license-demo" 
CLONE_REPO_DIR="/home/techzone/appmod-pot-labfiles"
LICENSE_DEMO_DIR="/home/techzone/Student/labs/appmod/license-demo"
DEMO_SCRIPTS_DIR="/home/techzone/appmod-pot-labfiles/labs/RuntimeModernization/license-demo/scripts/"
RESORTS_BUNDLE_DEPLOY_DIR="$LICENSE_DEMO_DIR/modresorts_migrationBundle/deploy/kustomize"
PBW_BUNDLE_DEPLOY_DIR="$LICENSE_DEMO_DIR/pbw_migrationBundle/deploy/kustomize"


cd $DEMO_SCRIPTS_DIR 

echo ""
echo "--------------------------------------"
echo "-> working directory: $PWD" 
echo "--------------------------------------"
echo ""


##cleanup steps
# oc delete -n license-demo -k $PBW_BUNDLE_DEPLOY_DIR/overlays/pbw_1.0 
# oc delete -n license-demo -k $RESORTS_BUNDLE_DEPLOY_DIR/overlays/pbw_1.0 
# oc delete project license-demo

# create license-demo project in OCP
# move artifacts from appmod-pot dir to Student dir

echo "remove the demo directory, if it exists. It will get recreated in this script"

if [ -d "$LICENSE_DEMO_DIR" ]; then
     echo ""
     echo "cleaning up the demo directory: $LICENSE_DEMO_DIR"
     rm -rf $LICENSE_DEMO_DIR
fi


echo ""
echo "--------------------------------------"
echo "---> Setup the demo files"
echo "--------------------------------------"
echo ""
echo "cp -r $CLONE_REPO_DIR/labs/RuntimeModernization/license-demo  $LICENSE_DEMO_DIR"
cp -r $CLONE_REPO_DIR/labs/RuntimeModernization/license-demo  $LICENSE_DEMO_DIR
rm -rf $LICENSE_DEMO_DIR/scripts
sleep 3

echo ""
echo "--------------------------------------"
echo "---> Login to OCP"
echo "--------------------------------------"
echo ""
oc login -u ocadmin -p ibmrhocp
sleep 3

echo ""
echo "--------------------------------------"
echo "---> Create the demo project in OCP"
echo "--------------------------------------"
echo ""
oc new-project $OC_PROJECT
sleep 3
echo ""
echo "--------------------------------------"
echo "---> Go to the demo project in OCP"
echo "--------------------------------------"
echo ""
oc project $OC_PROJECT
sleep 2

#call the build-images.sh script to build and push images to OCP
echo "--------------------------------------"
echo "Call the build-images script"
echo "--------------------------------------"
echo "" 
echo "$DEMO_SCRIPTS_DIR/script-artifacts/build-images.sh"
echo ""
sleep 3
$DEMO_SCRIPTS_DIR/script-artifacts/build-images.sh



echo "==========================" 
echo "lab-setup script completed" 
echo "==========================" 
echo "" 

echo ""
echo "================================================================"
echo ""
echo "-------------"
echo "Next Steps:"  
echo "-------------"
echo ""
echo "[1] Browser: Launch License Service Status page"   
echo ""    
echo "   https://ibm-licensing-service-instance-ibm-common-services.apps.ocp.ibm.edu/status?token=WgldsDXi8QuWKFzT9uBXApse"
echo ""   
echo ""
echo "[2] Deploy the PlantsByWebSphere application to OCP"   
echo ""    
echo "   cd $PBW_BUNDLE_DEPLOY_DIR"
echo ""   
echo "   oc apply -n $OC_PROJECT -k overlays/pbw_1.0"  
echo ""
echo ""
echo "[3] Update the PlantsBywebSphere license annotations for CP4Apps: Liberty Base"   
echo ""    
echo "   cd $DEMO_SCRIPTS_DIR"
echo ""   
echo "   ./pbw-license-update.sh"  
echo ""
echo ""
echo "[4] Deploy the Modresorts application to OCP"   
echo ""    
echo "   cd $RESORTS_BUNDLE_DEPLOY_DIR"
echo ""   
echo "   oc apply -n $OC_PROJECT -k overlays/resorts_1.0"  
echo ""
echo "================================================================"
echo "" 



exit 0