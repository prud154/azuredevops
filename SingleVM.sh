RG='AZB38RSV'

az group create --location eastus -n ${RG}

az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 172.16.0.0/16 \
    --subnet-name ${RG}-Subnet-1 --subnet-prefix 172.16.1.0/24 -l eastus

echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

# echo "Creating Virtual Machines"
# az vm create --resource-group ${RG} --name DEV1 --image $IMAGE --security-type Standard --vnet-name ${RG}-vNET1 \
#     --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
#     --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.4 \
#     --zone 1 --custom-data ./clouddrive/azureb38.txt

# az vm create --resource-group ${RG} --name PROD1 --image $IMAGE --security-type Standard --vnet-name ${RG}-vNET1 \
#     --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
#     --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.6 \
#     --zone 1 --custom-data ./clouddrive/azureb38.txt

az vm create --resource-group ${RG} --name BACKUPVM1 --image Win2022Datacenter --security-type Standard --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.5 \
    --zone 1

az vm create --resource-group ${RG} --name REPLVM1 --image Win2022Datacenter --security-type Standard --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.6 \
    --zone 1

watch ls
