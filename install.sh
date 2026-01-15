#!/usr/bin/env bash

set -euo pipefail

MACHINE="dev-machine"

# Verifica modo UEFI
if [[ ! -d /sys/firmware/efi ]]; then
  echo "Erro: Sistema não está em modo UEFI. Hyprland + LVM requer UEFI." >&2
  exit 1
fi

echo "Montando tmpfs em /tmp para builds temporários..."
mount -t tmpfs -o size=4G tmpfs /tmp  # ajuste o tamanho se quiser

echo "Particionando com disko..."
nix shell --extra-experimental-features nix-command nixpkgs#disko -c disko --mode disko "./machines/$MACHINE/disko.nix"

echo "Gerando configuração do hardware..."
nixos-generate-config --root /mnt

echo "Instalando NixOS..."
# Escolha UMA das opções abaixo:

# Opção 1: se usar flakes (recomendado)
#nixos-install --flake "./machines/$MACHINE#$(hostname)" --no-root-passwd

# Opção 2: se usar configuração tradicional (sem flakes)
 nixos-install -f "./machines/$MACHINE/configuration.nix"