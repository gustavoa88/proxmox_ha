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
echo -e "\n Loading... \n v_003"


# Função para obter a última versão do Ubuntu Server
get_latest_ubuntu_server_iso() {
    # Baixa a página HTML do site do Ubuntu Server
    curl -s "https://ubuntu.com/download/server" > ubuntu_server.html
    
    # Extrai o link que contém 'eventCategory' : 'Server download'
    DOWNLOAD_LINK=$(grep -o 'eventCategory' : 'Server download' ubuntu_server.html | grep -o 'href="[^"]*' | cut -d '"' -f2)
    
    # Verifica se o link do botão de download foi encontrado
    if [ -z "$DOWNLOAD_LINK" ]; then
        echo "Erro: Não foi possível encontrar o link do botão de download."
        return 1
    fi
    
    # Exibe o link do botão de download
    echo "Link do botão de download: $DOWNLOAD_LINK"
    
    # Remove o arquivo HTML temporário
    rm ubuntu_server.html
}

# Chama a função
get_latest_ubuntu_server_iso


