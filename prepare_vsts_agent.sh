#!/bin/sh
# Filename: prepare_vsts_agent.sh

personal_access_token=AZDO_PERSONAL_TOKEN
vm_name=VM_NAME_HERE
vsts_url="https://dev.azure.com/ORGANIZATION_NAME"

# update package index
sudo apt update

# install terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# install vsts agent
wget https://vstsagentpackage.azureedge.net/agent/3.218.0/vsts-agent-linux-x64-3.218.0.tar.gz
cd ~azureuser
sudo -u azureuser tar zxvf /vsts-agent-linux-x64-3.218.0.tar.gz 
sudo -u azureuser ./config.sh --unattended --url $vsts_url --auth pat --token $personal_access_token --pool default --agent $vm_name--acceptTeeEula
./svc.sh install
./svc.sh start
