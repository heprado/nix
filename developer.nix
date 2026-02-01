{ config, pkgs, ... }:
let
  xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;
in
{
  # imports = [
  #   ./theme.nix
  # ];


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

  # xdg.configFile = builtins.mapAttrs
  #   (name: subpath: {
  #     source = create_symlink "${dotfiles}/${subpath}";
  #     recursive = true;
  #   })
  #   configs;

}