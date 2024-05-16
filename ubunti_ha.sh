#!/bin/bash

# Parâmetros de configuração
VMID=101
VMNAME="ubuntu-server"
ISO_URL="https://releases.ubuntu.com/20.04/ubuntu-20.04.5-live-server-amd64.iso"
STORAGE="local-lvm"
MEMORY=2048
CORES=2
DISK_SIZE=32G

# Baixar ISO do Ubuntu Server
wget -O /var/lib/vz/template/iso/ubuntu-server.iso $ISO_URL

# Criar VM no Proxmox
qm create $VMID --name $VMNAME --memory $MEMORY --cores $CORES --net0 virtio,bridge=vmbr0
qm importdisk $VMID /var/lib/vz/template/iso/ubuntu-server.iso $STORAGE
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$VMID-disk-0 --boot c --bootdisk scsi0
qm set $VMID --ide2 local:iso/ubuntu-server.iso,media=cdrom
qm set $VMID --serial0 socket --vga serial0

# Iniciar instalação do Ubuntu Server
qm start $VMID

# Instrução para o usuário completar a instalação manualmente
echo "Complete a instalação manual do Ubuntu Server. Depois de concluir, execute o script de instalação do Home Assistant manualmente."

# Script de instalação do Home Assistant para ser executado manualmente após a instalação do Ubuntu Server
cat <<'EOF' > install_home_assistant.sh
#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y python3 python3-venv python3-pip

# Criar ambiente virtual para Home Assistant
python3 -m venv /srv/homeassistant
source /srv/homeassistant/bin/activate

# Instalar Home Assistant
pip install wheel
pip install homeassistant

# Criar serviço systemd para Home Assistant
cat <<'EOL' | sudo tee /etc/systemd/system/home-assistant@homeassistant.service
[Unit]
Description=Home Assistant
After=network.target

[Service]
Type=simple
User=%i
ExecStart=/srv/homeassistant/bin/hass -c "/home/%i/.homeassistant"

[Install]
WantedBy=multi-user.target
EOL

# Iniciar e habilitar o serviço do Home Assistant
sudo systemctl --system daemon-reload
sudo systemctl enable home-assistant@$(whoami)
sudo systemctl start home-assistant@$(whoami)
EOF

echo "Script de instalação do Home Assistant criado. Copie-o para a VM e execute-o após a instalação do Ubuntu Server."
