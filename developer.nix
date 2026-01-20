{ pkgs, ... }:
# let
#   dotfiles = "${config.home.homeDirectory}/dotfiles";
#   create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

#   configs = {
#     hypr = "hypr";
#   };
# in
{
  # imports = [
  #   ./theme.nix
  # ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  wayland.windowManager.hyprland.enable = true;
  
  # Enable Hyprland as display manager session
  programs.hyprland.enable = true;

  # Optional: enable wayland session support
  services.xserver.enable = false; 

  programs.kitty.enable = true; #Para a configuração padrão do Hyprland.

  home.username = "developer";
  home.homeDirectory = "/home/developer";
  home.stateVersion = "25.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake github:heprado/nix#dev-machine";
    };
    profileExtra = ''
      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };

  home.sessionVariables = {
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