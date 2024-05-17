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
    # Baixa a página HTML do site do Ubuntu Server
    curl -s "https://ubuntu.com/download/server" | pup 'a[href^="/download/server"] attr{href}' > download_links.txt
    
    # Extrai o link do botão de download do último link disponível
    DOWNLOAD_LINK=$(tail -n 1 download_links.txt)
    
    # Extrai o nome do arquivo ISO do link do botão de download
    ISO_FILENAME=$(echo "$DOWNLOAD_LINK" | grep -oE 'ubuntu-[0-9]+\.[0-9]+(\.[0-9]+)?-server-amd64\.iso')
    
    # Verifica se o nome do arquivo ISO foi encontrado
    if [ -z "$ISO_FILENAME" ]; then
        echo "Erro: Não foi possível determinar o nome do arquivo ISO."
        return 1
    fi
    
    # Exibe o nome do arquivo ISO
    echo "Nome do arquivo ISO mais recente: $ISO_FILENAME"
    
    # Remove o arquivo temporário de links de download
    rm download_links.txt
}

# Chama a função
get_latest_ubuntu_server_iso

