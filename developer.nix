{ config, pkgs, ... }:
let
  xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;
in
{
  # imports = [
  #   ./theme.nix
  # ];

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.kitty.enable = true; #Para a configuração padrão do Hyprland.

  home.pkgs = [
    pkgs.thunar
    pkgs.waybar
    pkgs.rofi
  ];

  home.username = "developer";

  home.homeDirectory = "/home/developer";

  home.stateVersion = "25.05";

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake github:heprado/nix#dev-machine";
    };
    # profileExtra = ''
    #   if uwsm check may-start; then
    #     exec uwsm start hyprland-uwsm.desktop
    #   fi
    # '';
  };


  home.sessionVariables = {
    XDG_CURRENT_DESKTOP="Hyprland";
    XDG_SESSION_TYPE="wayland";
    XDG_SESSION_DESTOP="Hyprland";
    WLR_NO_HARDWARE_CURSORS=1;
    WLR_RENDERER_ALLOW_SOFTWARE=1;
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };

  # xdg.configFile = builtins.mapAttrs
  #   (name: subpath: {
  #     source = create_symlink "${dotfiles}/${subpath}";
  #     recursive = true;
  #   })
  #   configs;

}