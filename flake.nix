{
  description = "My NixOS system";

  inputs = {
    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake"
    }


  };

  outputs = { self, nixpkgs, home-manager, niri, noctalia ... }:
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
              # disko.nixosModules.disko
              home-manager.nixosModules.home-manager
              niri.homeModules.niri
              noctalia.homeModules.default
            ];

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