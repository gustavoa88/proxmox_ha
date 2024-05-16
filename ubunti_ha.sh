#!/bin/bash

# Verificar se está executando como root
if [ "$(id -u)" -ne 0 ]; then
  echo "Este script deve ser executado como root."
  exit 1
fi

# Definir variáveis
VMID=100
VM_NAME="ubuntu-ha"
ISO_URL="https://releases.ubuntu.com/22.04/ubuntu-22.04-live-server-amd64.iso"
ISO_PATH="/var/lib/vz/template/iso/ubuntu-22.04-live-server-amd64.iso"
DISK_SIZE="32G"
MEMORY="4096"
CORES="2"

# Baixar a imagem ISO do Ubuntu Server
if [ ! -f "$ISO_PATH" ]; then
  echo "Baixando a ISO do Ubuntu Server..."
  wget -O "$ISO_PATH" "$ISO_URL"
fi

# Criar a VM no Proxmox
qm create $VMID --name $VM_NAME --memory $MEMORY --cores $CORES --net0 virtio,bridge=vmbr0
qm importdisk $VMID $ISO_PATH local-lvm
qm set $VMID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$VMID-disk-0
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --ide2 local-lvm:cloudinit
qm set $VMID --serial0 socket --vga serial0

# Configurar a instalação automática do Ubuntu
qm set $VMID --ide2 local-lvm:cloudinit
qm set $VMID --ciuser ubuntu --cipassword ubuntu --ipconfig0 ip=dhcp
qm set $VMID --ide2 local-lvm:cloudinit
qm set $VMID --sshkey <(ssh-keygen -t rsa -N "" -f /tmp/id_rsa && cat /tmp/id_rsa.pub)
qm set $VMID --nameserver 8.8.8.8 --searchdomain local
qm template $VMID

# Iniciar a VM
qm start $VMID

# Esperar a VM estar acessível via SSH
while ! nc -z $(pvesh get /nodes/$(hostname)/qemu/$VMID/status/current | jq -r '.qmpstatus') 22; do
  echo "Aguardando a VM iniciar..."
  sleep 10
done

# Instalar o Home Assistant no Ubuntu Server
ssh -o "StrictHostKeyChecking=no" ubuntu@$(pvesh get /nodes/$(hostname)/qemu/$VMID/status/current | jq -r '.ip') <<'EOF'
sudo apt update
sudo apt upgrade -y
sudo apt install -y python3 python3-venv python3-pip
sudo useradd -rm homeassistant -G dialout,gpio,i2c
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant
sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate
pip install wheel
pip install homeassistant
hass --open-ui
EOF

echo "Instalação concluída."
