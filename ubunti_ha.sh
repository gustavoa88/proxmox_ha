#!/bin/bash

# Variáveis de configuração
VMNAME="ubuntu-server"
STORAGE="local-lvm"
MEMORY=4096
CORES=1
DISK_SIZE=32G
ISO_DIR="/var/lib/vz/template/iso"
CLOUD_INIT_DIR="/var/lib/vz/template/cloud-init"
SSH_PORT=2222

# Função para obter a última versão do Ubuntu Server
get_latest_ubuntu_server_iso() {
    UBUNTU_URL=$(curl -s https://releases.ubuntu.com | grep -oP 'https:\/\/releases.ubuntu.com\/\K[0-9]+(\.[0-9]+)?(?=\/)' | sort -V | tail -n 1)
    ISO_URL="https://releases.ubuntu.com/$UBUNTU_URL/ubuntu-$UBUNTU_URL-live-server-amd64.iso"
    echo "$UBUNTU_URL|$ISO_URL"
}

# Função para encontrar um VMID disponível
find_available_vmid() {
    local vmid=100
    while qm status $vmid &>/dev/null; do
        vmid=$((vmid+1))
    done
    echo $vmid
}

# Função para baixar o ISO se necessário
download_iso() {
    local iso_url=$1
    local iso_path=$2
    if [ ! -f $iso_path ]; then
        echo "Baixando o ISO do Ubuntu Server..."
        wget -O $iso_path $iso_url
    else
        echo "ISO já existe: $iso_path"
    fi
}

# Obter a última versão do Ubuntu Server e o URL do ISO
latest_ubuntu_info=$(get_latest_ubuntu_server_iso)
UBUNTU_VERSION=$(echo $latest_ubuntu_info | cut -d '|' -f 1)
ISO_URL=$(echo $latest_ubuntu_info | cut -d '|' -f 2)
ISO_PATH="$ISO_DIR/ubuntu-server-$UBUNTU_VERSION.iso"
CLOUD_INIT_ISO="$CLOUD_INIT_DIR/${VMNAME}-cloudinit.iso"

# Baixar o ISO se necessário
download_iso $ISO_URL $ISO_PATH

# Encontrar um VMID disponível
VMID=$(find_available_vmid)
echo "Usando VMID: $VMID"

# Criar VM
echo "Criando VM..."
qm create $VMID --name $VMNAME --memory $MEMORY --cores $CORES --net0 virtio,bridge=vmbr0 --cdrom $ISO_PATH --ostype l26 --scsi0 $STORAGE:$DISK_SIZE --scsihw virtio-scsi-pci --boot c --bootdisk scsi0

# Iniciar a instalação do Ubuntu Server na VM
echo "Iniciando a VM para instalação do Ubuntu Server..."
qm start $VMID

# Esperar até a VM desligar (instalação completa)
while [ "$(qm status $VMID | grep -c stopped)" -eq "0" ]; do
    sleep 10
done

# Reiniciar a VM
qm stop $VMID --force
sleep 5
qm start $VMID

# Esperar até que a VM esteja online
while [ "$(qm status $VMID | grep -c running)" -eq "0" ]; do
    sleep 5
done

# Executar atualizações no sistema
echo "Atualizando o sistema..."
ssh -p $SSH_PORT root@localhost "apt-get update && apt-get upgrade -y"
sleep 5

# Reiniciar a VM
echo "Reiniciando a VM..."
qm stop $VMID --force
sleep 5
qm start $VMID

# Esperar até que a VM esteja online
while [ "$(qm status $VMID | grep -c running)" -eq "0" ]; do
    sleep 5
done

# Instalar o Home Assistant
echo "Instalando o Home Assistant..."
ssh -p $SSH_PORT root@localhost << EOF
apt-get install -y python3 python3-venv python3-pip
useradd -rm homeassistant -G dialout,gpio,i2c
mkdir /srv/homeassistant
chown homeassistant:homeassistant /srv/homeassistant
sudo -u homeassistant -H -s /bin/bash -c 'python3 -m venv /srv/homeassistant && source /srv/homeassistant/bin/activate && pip install wheel homeassistant'
systemctl daemon-reload
systemctl enable home-assistant@homeassistant   # Habilitar inicialização automática
systemctl start home-assistant@homeassistant
EOF

# Reiniciar a VM
echo "Reiniciando a VM..."
qm stop $VMID --force
sleep 5
qm start $VMID

# Esperar até que a VM esteja online
while [ "$(qm status $VMID | grep -c running)" -eq "0" ]; do
    sleep 5
done

# Iniciar o Home Assistant
echo "Iniciando o Home Assistant..."
ssh -p $SSH_PORT root@localhost << EOF
systemctl start home-assistant@homeassistant
EOF

# Abrir tela para configurar o SSH
echo "Para configurar o SSH, use o seguinte comando: ssh -p $SSH_PORT root@<IP_DA_VM>"
