#!/usr/bin/env bash

# Copyright (c) 2024-2024 gustavoa88
# Author: gustavoa88 (Gustavo Augusto)

function header_info {
  clear
  cat <<"EOF"

   000000  0000  000                                                    000000                            
   000000  0000 0000                               0                   00000000                           
    0000    00   000                             000                  0000  000                           
    0000    00   000 000   000  000    00 000   000000  000  000      00000  00   0000   000 00  00000 000
    0000    00   00000000 0000 0000  000000000  000000 0000 0000      0000000    00 000 00000000 00000 000
    0000    00   000  000  000  000   000  000   000    000  000       0000000  000 000  0000000  000  00 
    0000    00   000  000  000  000   000  000   000    000  000        0000000 0000000  000 00    00000  
    0000    00   000  000  000  000   000  000   000    000  000      0   00000 000      000       00000  
    00000  000   000  000  000  000   000  000   000    000  000      00   0000 0000  0  000        000   
     00000000    000  00   000000000 00000 0000  00000  000000000     00000000   000000 00000       000   
      000000       0000     000 000  00000 0000   000    000 000       000000     0000  00000        0  

---------------------------------------------------------------------------- With Home Assitant -----------

EOF
}
header_info
echo -e "\n Loading..."

# Função para obter a última versão do Ubuntu Server
get_latest_ubuntu_server_iso() {
    # Baixa a página HTML do site do Ubuntu Server e filtra a versão mais recente
    UBUNTU_URL=$(curl -s https://ubuntu.com/download/server | grep -oP 'https:\/\/releases.ubuntu.com\/\K[0-9]+(\.[0-9]+)?(?=\/)' | sort -V | tail -n 1)
    
    # Constrói a URL do arquivo ISO
    ISO_URL="https://releases.ubuntu.com/$UBUNTU_URL/ubuntu-$UBUNTU_URL-live-server-amd64.iso"
    
    # Extrai o nome do arquivo ISO
    ISO_FILENAME="ubuntu-$UBUNTU_URL-live-server-amd64.iso"
    
    # Exibe a última versão do Ubuntu Server e o URL do arquivo ISO
    echo "Última versão do Ubuntu Server: $UBUNTU_URL"
    echo "Nome do arquivo ISO: $ISO_FILENAME"
    echo "URL do ISO: $ISO_URL"
}

# Chama a função
get_latest_ubuntu_server_iso

