# Resource group where your AKS and App Gateway reside
RESOURCE_GROUP="k8s"

# Name of your AKS cluster
AKS_NAME="k8s-cluster"

# Name of your Application Gateway
APPGW_NAME="k8s-appgw"


# Connect to your AKS cluster
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME

# Enable AGIC add-on
az aks enable-addons --resource-group k8s --name k8s-cluster --addons ingress-appgw --appgw-name k8s-appgw
