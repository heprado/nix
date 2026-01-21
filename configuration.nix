{ config, lib, pkgs, ... }:
{

imports =
  [
      ./hardware-configuration.nix
  ];
  
  hardware.opengl.enable = true;
  
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
    getty = {
      autologinUser = "developer";
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  
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
  users.users.developer = {
    isNormalUser = true;
    description = "Developer";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    initialPassword = "changeme";
  };

  # Pacotes globais
  environment.systemPackages = with pkgs; [
    vim git curl wget lvm2 uwsm
  ];

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      experimental-features = ["nix-command" "flakes"];
    };
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  system.stateVersion = "25.11";
}