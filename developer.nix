{ config, pkgs, ... }:
{
  imports = [
      inputs.noctalia.homeModules.default
  ];


  home.username = "developer";

  home.homeDirectory = "/home/developer";

  home.stateVersion = "25.05";

  home.packages = with pkgs;[
      font-awesome
      nerd-fonts.blex-mono 
      nerd-fonts.proggy-clean-tt
  ];

  programs.niri = {
    package = niri;
    settings = {
        # ...
      spawn-at-startup = [
          {
            command = [
              "noctalia-shell"
            ];
          }
        ];
      };
  };
  
  programs.noctalia-shell = {

    enable = true;

    colors = {
      # you must set ALL of these
      mError = "#dddddd";
      mOnError = "#111111";
      mOnPrimary = "#111111";
      mOnSecondary = "#111111";
      mOnSurface = "#828282";
      mOnSurfaceVariant = "#5d5d5d";
      mOnTertiary = "#111111";
      mOnHover = "#ffffff";
      mOutline = "#3c3c3c";
      mPrimary = "#aaaaaa";
      mSecondary = "#a7a7a7";
      mShadow = "#000000";
      mSurface = "#111111";
      mHover = "#1f1f1f";
      mSurfaceVariant = "#191919";
      mTertiary = "#cccccc";
    };

    settings = {

      bar = {
        density = "compact";
        position = "right";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      general = {
        avatarImage = "/home/drfoobar/.face";
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = true;
        name = "Marseille, France";
      };
    };
    # this may also be a string or a path to a JSON file.
  };

  fonts = {
    fontconfig = {
      enable = true;
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