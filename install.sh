# #!/usr/bin/env bash

# set -euo pipefail

# MACHINE="dev-machine";



# export NIX_CONFIG="experimental-features = nix-command flakes"



# echo "Montando tmpfs em /tmp para builds temporários..."

# mount -t tmpfs -o size=8G tmpfs /tmp  

# echo "Particionando realmente"

# nix shell nixpkgs#disko -c disko --mode disko "./machines/$MACHINE/disko.nix"

# nixos-generate-config --no-filesystems --root /mnt 

# cp ./machines/$MACHINE/* /mnt/etc/nixos/

# cp ./flake.nix /mnt/etc/nixos/

# echo "Aplicando configs"

# echo "Instalando"


# nixos-install --flake "/mnt/etc/nixos#dev-machine" --no-root-passwd


#FLAKE="github:heprado/nix?dir=machines/dev-machine#dev-machine"

if [[ ! -d /sys/firmware/efi ]]; then


   echo "Erro: Sistema não está em modo UEFI. Hyprland + LVM requer UEFI."

  exit 1

fi


FLAKE="./#dev-machine"

DISK_DEVICE=/dev/sda

export NIX_CONFIG="
experimental-features = nix-command flakes 
build-use-substitutes = true
"

nix \
    run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko.nix --yes-wipe-all-disks

echo "Copiando store e var para disko" $DISK_DEVICE

rsync --archive --hard-links --acls --one-file-system /nix/store/ /mnt/store
rsync --archive --hard-links --acls --one-file-system /nix/var/ /mnt/var

nixos-install --flake ./#dev-machine --no-root-passwd

nixos-enter --root /mnt -c 'passwd heprado'

# nix \
#     run github:nix-community/disko#disko-install -- \
#     --flake "$FLAKE" \
#     --write-efi-boot-entries \
#     --disk main "$DISK_DEVICE"


