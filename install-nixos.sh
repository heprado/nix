#!/usr/bin/env bash
set -euo pipefail

#DISK="/dev/sda";
#HOSTNAME="dev-machine";
#USE_SWAP=1;


# === PADROES ===
DISK="/dev/sda"       
HOSTNAME="dev-machine"
USERNAME="heprado" 
TIMEZONE="America/Sao_Paulo"
SWAP_SIZE="2G"         
# ==================================

if [[ ! -d /sys/firmware/efi ]]; then
  echo "Erro: Sistema não está em modo UEFI. Hyprland + LVM requer UEFI."
  exit 1
fi

echo "Particionando disco..."
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 513MiB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart LVM 513MiB 100%

echo "Formatando EFI..."
mkfs.fat -F 32 "${DISK}1"

echo "Configurando LVM..."
pvcreate -ff -y "${DISK}2"
vgcreate -ff -y vg0 "${DISK}2"
lvcreate -L "$SWAP_SIZE" -n lv-swap vg0
lvcreate -l 100%FREE -n lv-root vg0

echo "Formatando volumes..."
mkfs.ext4 -L nixos /dev/vg0/lv-root
mkswap -L swap /dev/vg0/lv-swap
swapon /dev/vg0/lv-swap

echo "Montando filesystems..."
mount /dev/vg0/lv-root /mnt
mkdir -p /mnt/boot
mount "${DISK}1" /mnt/boot

echo "Gerando hardware-configuration.nix..."
nixos-generate-config --root /mnt

mv "./configuration.nix" "/mnt/etc/nix/configuration.nix"

nixos-install --no-root-passwd



