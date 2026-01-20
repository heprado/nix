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
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix  # optional: if you have a separate system config
          {
            imports = [
              disko.nixosModules.disko
              home-manager.nixosModules.home-manager
              hyprland.nixosModules.default 
            ];

            # Enable Hyprland as display manager session
            programs.hyprland.enable = true;

            # Optional: enable wayland session support
            services.xserver.enable = false;  # Hyprland is a Wayland compositor
            
            # Home Manager integration
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.your-username = { ... }: {
              imports = [ ./home.nix ];
              home.stateVersion = "25.05";  # match your NixOS version
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