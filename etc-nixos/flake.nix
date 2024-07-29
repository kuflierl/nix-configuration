{
  description = "flake for kul2-secureboot";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote }: {
    nixosConfigurations = {
      kul2-secureboot = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/kul2-secureboot/configuration.nix
        ];
      };
    };
  };
}
