$RegistryName = "k8s.gcr.io"
$ResourceGroup = "teamResources"
$SourceRegistry = "k8s.gcr.io"
$ControllerImage = "ingress-nginx/controller"
$ControllerTag = "v1.0.4"
$PatchImage = "ingress-nginx/kube-webhook-certgen"
$PatchTag = "v1.1.1"
$DefaultBackendImage = "defaultbackend-amd64"
$DefaultBackendTag = "1.5"

#Import-AzContainerRegistryImage -ResourceGroupName $ResourceGroup -RegistryName $RegistryName -SourceRegistryUri $SourceRegistry -SourceImage "${ControllerImage}:${ControllerTag}"
#Import-AzContainerRegistryImage -ResourceGroupName $ResourceGroup -RegistryName $RegistryName -SourceRegistryUri $SourceRegistry -SourceImage "${PatchImage}:${PatchTag}"
#Import-AzContainerRegistryImage -ResourceGroupName $ResourceGroup -RegistryName $RegistryName -SourceRegistryUri $SourceRegistry -SourceImage "${DefaultBackendImage}:${DefaultBackendTag}"

#az acr import --name registrymsd2910.azurecr.io --force --source k8s.gcr.io/ingress-nginx/controller:v1.0.4 --image ingress-nginx/controller:v1.0.4
#az acr import --name registrymsd2910.azurecr.io --force --source k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1 --image ingress-nginx/kube-webhook-certgen:v1.1.1
#az acr import --name registrymsd2910.azurecr.io --force --source k8s.gcr.io/defaultbackend-amd64:1.5 --image defaultbackend-amd64:1.5
# Add the ingress-nginx repository
#helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Set variable for ACR location to use for pulling images
$AcrUrl = $RegistryName 

# Use Helm to deploy an NGINX ingress controller
helm.exe install nginx-ingress ingress-nginx/ingress-nginx `
    --namespace ingress-basic --create-namespace `
    --set controller.replicaCount=2 `
    --set controller.nodeSelector."kubernetes\.io/os"=linux `
    --set controller.image.registry=$AcrUrL `
    --set controller.image.image=$ControllerImage `
    --set controller.image.tag=$ControllerTag `
    --set controller.image.digest="" `
    --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux `
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz `
    --set controller.admissionWebhooks.patch.image.registry=$AcrUrl `
    --set controller.admissionWebhooks.patch.image.image=$PatchImage `
    --set controller.admissionWebhooks.patch.image.tag=$PatchTag `
    --set controller.admissionWebhooks.patch.image.digest="" `
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux `
    --set defaultBackend.image.registry=$AcrUrl `
    --set defaultBackend.image.image=$DefaultBackendImage `
    --set defaultBackend.image.tag=$DefaultBackendTag `
    --set defaultBackend.image.digest=""