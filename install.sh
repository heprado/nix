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


nix shell nixpkgs#disko -c disko --mode disko "./machines/$MACHINE/disko.nix"

nixos-generate-config --root /mnt 

echo "Aplicando configs"

echo "Instalando"

cp /mnt/etc/nixos/hardware-configuration.nix ./machines/$MACHINE/
#cp /mnt/etc/nixos/configuration.nix ./machines/$MACHINE/
nixos-install --flake ".#$MACHINE" --no-root-passwd





