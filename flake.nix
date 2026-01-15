{
  description = "My NixOS system with disko + LVM + /nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    # Optional: lock disko to a specific rev for reproducibility
    # disko.url = "github:nix-community/disko/rev/abc123...";
  };

  outputs = { self, nixpkgs, disko }:
    {
      nixosConfigurations.dev-machine = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit disko; };  # ← makes 'disko' available in modules
        system = "x86_64-linux"
        modules = [
          ./machines/dev-machine/configuration.nix
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