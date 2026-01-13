{ config, pkgs, ... }:

let
  disko = builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz";
in
{
  imports = [ "${disko}/module.nix" ];

  disko.devices = {
    disk = {
      main = {  # nome arbitrário: "main", "my-disk", etc.
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";  # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            lvm = {
              size = "100%";  # ocupa o resto do disco
              content = {
                type = "lvm_pv";
                vg = "vg0";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        lvs = {
          lv-swap = {
            size = "2G";
            content = {
              type = "swap";
              randomEncryption = false;
            };
          };
          lv-root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };

  # Restante da configuração (bootloader, hyprland, etc.)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.lvm.enable = true;
  boot.supportedFilesystems = [ "ext4" ];

  # ... (resto do teu configuration.nix)
}