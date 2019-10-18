

Create AKS cluster
```
az create --resource-group rg-dns-test --name dns-test --node-count 4 --enable-addons monitoring --network-plugin azure --generate-ssh-keys
az aks install-cli
az aks get-credentials --resource-group rg-dns-test --name dns-test

```


Inject SSH key to AKS VMSS
```
CLUSTER_RESOURCE_GROUP=$(az aks show --resource-group rg-dns-test --name dns-test --query nodeResourceGroup -o tsv)

SCALE_SET_NAME=$(az vmss list --resource-group $CLUSTER_RESOURCE_GROUP --query "[0].name" -o tsv)

az vmss extension set --resource-group $CLUSTER_RESOURCE_GROUP --vmss-name $SCALE_SET_NAME --name VMAccessForLinux --publisher Microsoft.OSTCExtensions --version 1.4 --protected-settings "{\"username\":\"azureuser\", \"ssh_key\":\"$(cat ~/.ssh/id_rsa.pub)\"}"

az vmss update-instances --instance-ids '*' --resource-group $CLUSTER_RESOURCE_GROUP --name $SCALE_SET_NAME

```

SSH into node
```
kubectl run -it --rm aks-ssh --image=debian
kubectl cp ~/.ssh/id_rsa aks-ssh-XXXXXXXXX:/id_rsa

# from the container
apt-get update && apt-get install openssh-client -y
chmod 0600 id_rsa
ssh -i id_rsa azureuser@IP_NODE

```