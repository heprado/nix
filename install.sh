if [[ ! -d /sys/firmware/efi ]]; then


   echo "Erro: Sistema não está em modo UEFI. Hyprland + LVM requer UEFI."

  exit 1

fi


FLAKE="/mnt/etc/nixos#dev-machine"

DISK_DEVICE=/dev/sda

export NIX_CONFIG="
experimental-features = nix-command flakes 
build-use-substitutes = true
"

nix \
    run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko.nix --yes-wipe-all-disks

nix-collect-garbage

echo "Copiando store e var para disko" $DISK_DEVICE

rsync --archive --hard-links --acls --one-file-system /nix/store/ /mnt/store
rsync --archive --hard-links --acls --one-file-system /nix/var/ /mnt/var

mount /dev/mapper/vg0-lv--nix /nix

cp -f -r ./* /mnt/etc/nixos

nixos-generate-config --root /mnt

nixos-install --flake $FLAKE --no-root-passwd



