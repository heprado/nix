{
  description = "My NixOS system with disko + LVM + /nix";

  inputs = {
    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, disko, ... }:
    let 
      system = "x86_64-linux";
      hostname = "dev-machine";
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager = {
               useGlobalPkgs = true;
               useUserPackages = true;
               users.developer = import "github:heprado/nix/developer.nix";
               backupFileExtension = "backup";
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