{ config, lib, pkgs, ... }:
{

imports =
  [
      ./hardware-configuration.nix
  ];

  fileSystems."/nix" = {
     device = "/dev/sda2/vg0-lv--nix/nix";
     fsType = "ext4";
     neededForBoot = true;
     options = [ "noatime" ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  nixpkgs.config.allowUnfree = true;
  
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
    xserver.enable = true;
    displayManager.sddm.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = pkgs.stdenv.hostPlatform.system.hyprland;
    # portalPackage = pkgs.stdenv.hostPlatform.system.xdg-desktop-portal-hyprland;
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
    vim git curl wget lvm2 xfce.thunar waybar rofi foot gtk4 
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      nerd-fonts.blex-mono 
    ];

    # fontconfig = {
    #   defaultFonts = {
    #     serif = [  "BlexMono Nerd Font" ];
    #     sansSerif = [ "BlexMono Nerd Font" ];
    #     monospace = [ "BlexMono Nerd Font" ];
    #   };
    # };
  };

  environment.variables = {
    XDG_CURRENT_DESKTOP="Hyprland";
    XDG_SESSION_TYPE="wayland";
    XDG_SESSION_DESTOP="Hyprland";
    WLR_NO_HARDWARE_CURSORS=1;
    WLR_RENDERER_ALLOW_SOFTWARE=1;
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };

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