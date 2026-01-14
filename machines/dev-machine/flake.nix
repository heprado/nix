{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.disko.url = "github:nix-community/disko/latest";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, disko, nixpkgs }: {
    nixosConfigurations.mymachine = nixpkgs.legacyPackages.x86_64-linux.nixos [
      ./configuration.nix
      disko.nixosModules.disko
      {
              disko.devices = 
  {
    disk = {
      main = { 
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
        
      }
    ];
  };
}
        