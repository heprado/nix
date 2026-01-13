{ config, pkgs, ... }:
let
  # Importa disko do nixpkgs (disponível desde ~23.11)
  disko = builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz";
in
{
  imports = [ 
    "${disko}/module.nix"
     ];

  swapDevices = [
    { device = "/swapfile"; size = 4096; }  # 4 GB
  ];

  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  # Configuração do disko
  disko.devices.disk.main = {
    device = "/dev/sda";  # ← ajuste se for NVMe (/dev/nvme0n1)
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

  disko.devices.lvm_vg.vg0 = {
    type = "lvm_vg";
    lvs = {
      lv-swap = {
        size = "2G";
        content = {
          type = "swap";
          randomEncryption = false;  # ou true, se quiser criptografia
        };
      };
      lv-root = {
        size = "100%FREE"; #Ocupa tudo.
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
        };
      };
    };
  };


  # Bootloader UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LVM
  services.lvm.enable = true;
  boot.supportedFilesystems = [ "ext4" ];

  # Desativar X11 (Hyprland é Wayland-only)
  services.xserver.enable = false;

  # Hyprland
  programs.hyprland.enable = true;

  # Drivers Intel (Skylake)
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Firmware adicional
  hardware.enableRedistributableFirmware = true;

  # Rede
  networking.networkmanager.enable = true;
  networking.hostName = "dev-machine";

  # Localização
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  console.keyMap = "br-abnt2";

  # Usuário
  # rofi waybar swaybg wl-clipboard grim slurp pavucontrol
  users.users.heprado = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox alacritty  
    ];
    # initialPassword = "changeme";  # descomente se quiser senha fixa
  };

  # Pacotes globais
  environment.systemPackages = with pkgs; [
    vim git curl wget htop xdg-utils lvm2
  ];



  # Segurança e manutenção
  nix.gc.automatic = true;


  nix.gc.options = "--delete-older-than 7d";

  system.stateVersion = "24.11";
}