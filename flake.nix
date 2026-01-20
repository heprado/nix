{
  description = "My NixOS system with disko + LVM + Hyprland";

  inputs = {
    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, hyprland, home-manager, disko, ... }:
    let 
      system = "x86_64-linux";
      hostname = "dev-machine";
      default_user = "developer";
    in
    {
      homeConfiguration."developer@dev-machine" = home-manager.lib.homeManagerConfiguration {
        inherit system;

        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        modules = [
          ./configuration.nix
          {
            imports = [
              disko.nixosModules.disko
              home-manager.nixosModules.home-manager
              hyprland.nixosModules.default 
            
            ];

            wayland.windowManager.hyprland = {
            enable = true;
            # set the flake package
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
          };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.developer = { ... }: {
              imports = [ ./developer.nix ];
              home.stateVersion = "25.05";
            };
          }
        ];
      };

      # Optional: provide an installer script
      # scripts.installDevMachine = {
      #   description = "Install dev-machine";
      #   type = "app";
      #   program = "${self}/machines/dev-machine/install.sh";
      # };
    };
}