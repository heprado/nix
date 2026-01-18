{ config, lib, pkgs, ... }:
{

  imports = [
    ./disko.nix  
  ];

  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  # Bootloader UEFI
  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "dm_mod" "xfs" "ext4" ]; 

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}