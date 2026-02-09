{ config, pkgs, ... }:
{
 

  xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;

  xdg.configFile."foot/foot.ini".source  = ./dotfiles/foot/foot.ini;
  
  xdg.configFile."waybar".source = ./waybar;

  home.username = "developer";

  home.homeDirectory = "/home/developer";

  home.stateVersion = "25.05";

  home.packages = with pkgs;[
      font-awesome
      nerd-fonts.blex-mono 
      nerd-fonts.proggy-clean-tt
  ];
  fonts = {
    fontconfig = {
      enable = true;
      # defaultFonts = {
      #   serif = [  "BlexMono Nerd Font" ];
      #   sansSerif = [ "BlexMono Nerd Font" ];
      #   monospace = [ "BlexMono Nerd Font" ];
      # };
    };
  };



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