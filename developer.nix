{ config, pkgs, ... }:
{
 

  config.allowUnfree = true;
  xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;

  home.username = "developer";

  home.homeDirectory = "/home/developer";

  home.stateVersion = "25.05";


  programs.home-manager = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake github:heprado/nix#dev-machine";
    };
  };

  programs.vscode = {
    enable = true;
  };

  programs.fastfetch = {
    enable = true;
  };
  
  programs.firefox = {
    enable = true;
  };

}