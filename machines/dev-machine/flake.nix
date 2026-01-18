{
  description = "My NixOS system with disko + LVM + /nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }:
    let 
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.dev-machine = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./disko.nix
          ./configuration.nix
          disko.nixosModules.disko
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