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

get_latest_ubuntu_iso() {
    # Baixa a página HTML do site do Ubuntu Server
    curl -s "https://ubuntu.com/download/server" > ubuntu_server.html
    
    # Extrai o link do arquivo ISO mais recente
    latest_iso=$(grep -o 'https://releases.ubuntu.com/[0-9]+\.[0-9]+/ubuntu-[0-9]+\.[0-9]+.[0-9]+-server-amd64\.iso' ubuntu_server.html | head -n1)
    
    # Extrai apenas o nome do arquivo ISO do link
    iso_filename=$(echo "$latest_iso" | awk -F'/' '{print $NF}')
    
    # Exibe o nome do arquivo ISO mais recente
    echo "O arquivo ISO mais recente do Ubuntu Server é: $iso_filename"
    
    # Limpa o arquivo HTML temporário
    rm ubuntu_server.html
}

# Chama a função
get_latest_ubuntu_iso
