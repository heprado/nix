{ config, pkgs, ... }:
{
 

  xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;

  home.username = "developer";

  home.homeDirectory = "/home/developer";

  home.stateVersion = "25.05";

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      font-awesome
      nerd-fonts.blex-mono 
      nerd-fonts.proggy-clean-tt
    ];

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