{
  description = "My NixOS system";

  inputs = {
    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };


  };

  outputs = { self, nixpkgs, home-manager, niri, noctalia, ... }:
    let 
      system = "x86_64-linux";
      hostname = "dev-machine";
      default_user = "developer";
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          {
            imports = [
              home-manager.nixosModules.home-manager
              niri.homeModules.niri
              noctalia.homeModules.default
            ];

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.developer = { ... }: {
              imports = [ ./developer.nix ];
              home.stateVersion = "24.05";
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