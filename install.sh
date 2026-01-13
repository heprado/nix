#!/usr/bin/env bash

set -euo pipefail

# export NIX_DISK="/dev/sda"
# export NIX_HOSTNAME="dev-machine"
# export NIX_USERNAME="heprado"
# export NIX_TIMEZONE="America/Sao_Paulo"
# export NIX_LOCALE="pt_BR.UTF-8"
# export NIX_KEYMAP="br-abnt2"

if [[ ! -d /sys/firmware/efi ]]; then


  echo "Erro: Sistema não está em modo UEFI. Hyprland + LVM requer UEFI."

  exit 1

fi

# 1. Preparar disco temporário
sgdisk --zap-all /dev/sda
parted /dev/sda mklabel gpt 
parted /dev/sda mkpart primary ext4 1MiB 20GiB 
mkfs.ext4 /dev/sda1 
mount /dev/sda1 /mnt 

# 2. Configurar ambiente
export TMPDIR=/mnt/tmp
mkdir -p $TMPDIR

mkdir -p /mnt/etc/nixos

touch /mnt/etc/nixos/configuration.nix

curl -o /mnt/etc/nixos/configuration.nix https://raw.githubusercontent.com/heprado/nix/refs/heads/main/configuration.nix x

nixos-install --root /mnt 
