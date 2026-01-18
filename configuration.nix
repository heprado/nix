{ config, lib, pkgs, ... }:
{

  imports = [
    ./disko.nix  
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  
  boot = {
    initrd = {
      systemd.enable = true;
      availableKernelModules = [ "dm_mod" "xfs" "ext4" ];
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ext4"];

  };

  services = {
    lvm.enable = true;
    xserver.enable = false;
  };

  # programs = {
  #   hyprland.enable = true;
  # };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    enableRedistributableFirmware = true;
  };


  networking = {
    networkmanager.enable = true;
    hostName = "dev-machine";
  };

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
    # packages = with pkgs; [
    #   firefox alacritty  
    # ];
    # initialPassword = "changeme";  # descomente se quiser senha fixa
  };

  # Pacotes globais
  environment.systemPackages = with pkgs; [
    vim git curl wget htop lvm2
  ];

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  system.stateVersion = "25.11";
}