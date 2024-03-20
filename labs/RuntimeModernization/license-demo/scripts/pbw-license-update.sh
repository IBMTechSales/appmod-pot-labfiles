######################
#  pbw-license-update.sh 
######################

## No input parameters required to run this script. 
## You will be prompted to continue, as this script cleans up lab resources

OC_PROJECT="license-demo"

LICENSE_DEMO_DIR="/home/techzone/Student/labs/appmod/license-demo"
CLONE_REPO_DIR="/home/techzone/appmod-pot-labfiles/labs/RuntimeModernization/license-demo"
PBW_DEPLOY_DIR="$LICENSE_DEMO_DIR/pbw_migrationBundle/deploy"

#copy the application-cr.yaml from git repo to the pbw kustomize/base dir
#this file includes
#      CP4apps - Liberty Base license annotations
#      CPU limit of 1 core
#      4 replicas (4 pods)  

echo ""
echo "-------------------------------------------------"
echo "Update the PBW deployment as follows:" 
echo "   --> CP4apps - Liberty Base license annotations"
echo "   --> CPU limit of 1 core"
echo "   --> 4 replicas (4 pods)"  
echo "-------------------------------------------------"
echo "" 
sleep 3

echo "cp -r $CLONE_REPO_DIR/demo-files/pbw/application-cr.yaml $PBW_DEPLOY_DIR/kustomize/base"
cp -r $CLONE_REPO_DIR/demo-files/pbw/application-cr.yaml $PBW_DEPLOY_DIR/kustomize/base



echo ""
echo "================================================================"
echo ""
echo "To deploy the updated configuration, run the folloingc commands:" 
echo ""
echo "   cd $PBW_DEPLOY_DIR/kustomize"
echo ""   
echo "   oc apply -n $OC_PROJECT -k overlays/pbw_1.0"  
echo ""
echo "================================================================"
echo "" 

echo "" 
echo "======================================" 
echo "pbw-license-update.sh script completed" 
echo "======================================" 
echo "" 

exit 0

