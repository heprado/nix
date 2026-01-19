{ config, pkgs, ... }:

let
  dotfiles = "github:heprado/nix/hyprland.conf";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr = "hypr";
  };
in
{
  imports = [
    "github:heprado/nix/theme.nix"
  ];

  home.username = "developer";
  home.homeDirectory = "/home/developer";
  home.stateVersion = "25.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake github:heprado/nix/hyprland.conf";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

}