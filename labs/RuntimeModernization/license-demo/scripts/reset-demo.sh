######################
#  reset-demo.sh 
######################

## No input parameters required to run this script. 
## You will be prompted to continue, as this script cleans up lab resources


#Have user reply "y" to continue the script to contiue 
echo ""
echo "This script will cleanup resurces in the lab environemnt:"
echo ""
read -p "---> Are you sure you want to continue? (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        echo continuing... 
    ;;
    * )
        exit 1
    ;;
esac

LICENSE_DEMO_DIR="/home/techzone/Student/labs/appmod/license-demo"
PBW_BUILD_DIR="$LICENSE_DEMO_DIR/pbw_migrationBundle"
RESORTS_BUILD_DIR="$LICENSE_DEMO_DIR/modresorts_migrationBundle"

OC_PROJECT="license-demo"


echo ""
echo "----------------------------------"
echo "Running demo cleanup steps" 
echo "----------------------------------"
echo ""

# Cleanup any existing components
echo "login to ocp"
oc login -u ocadmin -p ibmrhocp
sleep 2
echo "go to the $OC_PROJECT in ocp"
oc project $OC_PROJECT
sleep 2
echo "change to the PBW Build directory"
cd $PBW_BUILD_DIR/deploy/kustomize
echo "delete the PBW deployent from ocp"
oc delete -n $OC_PROJECT -k overlays/pbw_1.0
sleep 2
echo "change to the RESORTS Build directory"
cd $RESORTS_BUILD_DIR/deploy/kustomize
echo "delete the RESORTS deployent from ocp"
oc delete -n $OC_PROJECT -k overlays/resorts_1.0
sleep 2
echo "delete the PBW image stream from ocp"
oc delete -n $OC_PROJECT is pbw
echo "delete the PRESORTS image stream from ocp"
oc delete -n $OC_PROJECT is resorts
sleep 2

echo "switch to default ocp project"
oc project default

echo "delete project $OC_PROJECT"
oc delete project $OC_PROJECT

echo "remove the PBW docker image"
docker rmi default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/resorts:1.0
echo "remove the RESORTS docker image"
docker rmi default-route-openshift-image-registry.apps.ocp.ibm.edu/$OC_PROJECT/pbw:1.0

## comment out for now
#echo "Logout of ocp internal registry"
#docker logout
#echo "logout of ocp"
#oc logout


echo "remove the demo directory, if it exists." 

if [ -d "$LICENSE_DEMO_DIR" ]; then
     echo ""
     echo "cleaning up the demo directory: $LICENSE_DEMO_DIR"
     rm -rf $LICENSE_DEMO_DIR
fi


echo "-----------------------------------------"
echo "End of demo cleanup steps"
echo "-----------------------------------------"

    
echo "" 
echo "================================" 
echo "reset-demo.sh script completed" 
echo "================================" 
echo "" 

exit 0

