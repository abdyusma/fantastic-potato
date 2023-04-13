#!/bin/sh
# Filename: deploy_zerotouch_setup.sh
resource_group_name=zerotouch-rg
vm_name=INSERT_VM_NAME_HERE
subscription_id=INSERT_SUBSCRIPTION_ID_HERE
storage_account_name=INSERT_STORAGE_ACCOUNT_NAME_HERE
location=southeastasia

az group create --subscription $subscription_id -l $location -n $resource_group_name

az vm create --subscription $subscription_id \
  --resource-group $resource_group_name \
  --name $vm_name \
  --image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
  --size Standard_B1s \
  --custom-data prepare_vsts_agent.sh \
  --admin-username azureuser \
  --admin-password "PUTYOUROWNPASSWORDHERE" \
  --location $location \
  --os-disk-delete-option Delete \
  --public-ip-address ""

az storage account create --subscription $subscription_id -n $storage_account_name -g $resource_group_name -l $location --sku Standard_LRS

az storage container create --subscription $subscription_id -n terraform --account-name $storage_account_name

az vm identity assign -g $resource_group_name -n $vm_name --role "Storage Blob Data Contributor" --scope /subscriptions/$subscription_id/resourceGroups/$resource_group_name
