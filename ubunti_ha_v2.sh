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
echo -e "\n Loading... \n v_001"


# Função para obter a última versão do Ubuntu Server
get_latest_ubuntu_server_iso() {
  # URL da página de releases do Ubuntu
  URL="https://releases.ubuntu.com/focal/"

  # Padrao para o nome do arquivo ISO que você deseja encontrar
  ISO_PATTERN="live-server-amd64.iso"

  # Baixa o HTML da página
  HTML=$(curl -s "$URL")

  # Extrai o link do arquivo ISO usando grep
  ISO_LINK=$(echo "$HTML" | grep -oP '(?<=href=")[^"]*'"$ISO_PATTERN" | head -n 1)

  # Se o link for encontrado, faça o download
  if [ -n "$ISO_LINK" ]; then
    echo "Encontrado o link para o arquivo ISO: $ISO_LINK"
    echo "Baixando o arquivo ISO..."
    wget "$URL$ISO_LINK"
  else
    echo "O arquivo ISO não foi encontrado."
  fi
}

# Chama a função
get_latest_ubuntu_server_iso


