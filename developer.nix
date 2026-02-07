{ config, pkgs, ... }:
{
 

  xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;

  xdg.configFile."foot/foot.ini".source  = ./dotfiles/foot/foot.ini;

  home.username = "developer";

  home.homeDirectory = "/home/developer";

  home.stateVersion = "25.05";


  programs.home-manager = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch";
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