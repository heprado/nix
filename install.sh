#!/usr/bin/env bash

set -euo pipefail

MACHINE="dev-machine";

export NIX_CONFIG="experimental-features = nix-command flakes"

if [[ ! -d /sys/firmware/efi ]]; then


  echo "Erro: Sistema não está em modo UEFI. Hyprland + LVM requer UEFI."

  exit 1

fi
echo "Montando tmpfs em /tmp para builds temporários..."
mount -t tmpfs -o size=8G tmpfs /tmp  

echo "Particionando realmente"

#nix run github:nix-community/disko -- --mode disko ./machines/$MACHINE/disko.nix


nix shell nixpkgs#disko -c disko --mode disko "./machines/$MACHINE/disko.nix"

nixos-generate-config --root /mnt

echo "Aplicand configs"
mv ./machines/$MACHINE/configuration.nix /mnt/etc/nixos/

echo "Instalando"

nixos-install -f ./machines/$MACHINE/configuration.nix

#echo "Criando partição temporaria de instalação"
# 1. Preparar disco temporário
# sgdisk --zap-all /dev/sda
# parted /dev/sda mklabel gpt 
# parted /dev/sda mkpart primary ext4 1MiB 20GiB 
# mkfs.ext4 /dev/sda1 
# mount /dev/sda1 /mnt 

#echo "Criando arquivos necessarios"

# 2. Configurar ambiente



# mkdir -p /mnt/etc/nixos

# mkdir -p /mnt/tmp





