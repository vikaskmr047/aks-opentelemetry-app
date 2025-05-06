
az group create --name k8s --location centralindia

# Create k8s cluster
az aks create \
  --resource-group k8s \
  --name k8s-cluster \
  --location centralindia \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 3 \
  --node-vm-size Standard_A2_v2 \
  --network-plugin azure \
  --enable-addons ingress-appgw \
  --appgw-name k8s-appgw \
  --appgw-subnet-cidr "10.225.0.0/16" \
  --generate-ssh-keys


# Get application gateway id from AKS addon profile
appGatewayId=$(az aks show -n k8s-cluster -g k8s -o tsv --query "addonProfiles.ingressApplicationGateway.config.effectiveApplicationGatewayId")

# Get Application Gateway subnet id
appGatewaySubnetId=$(az network application-gateway show --ids $appGatewayId -o tsv --query "gatewayIPConfigurations[0].subnet.id")

# Get AGIC addon identity
agicAddonIdentity=$(az aks show -n k8s-cluster -g k8s -o tsv --query "addonProfiles.ingressApplicationGateway.identity.clientId")

# Assign network contributor role to AGIC addon identity to subnet that contains the Application Gateway
az role assignment create --assignee $agicAddonIdentity --scope $appGatewaySubnetId --role "Network Contributor"



# Connect to your AKS cluster
az aks get-credentials --resource-group k8s --name k8s-cluster

# Enable AGIC add-on
az aks enable-addons --resource-group k8s --name k8s-cluster --addons ingress-appgw --appgw-name k8s-appgw
