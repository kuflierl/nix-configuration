{
  description = "kuflierl's main nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:kuflierl/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      sops-nix,
      lanzaboote,
      disko,
      nixos-hardware,
      impermanence,
      git-hooks,
      treefmt-nix,
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      treefmtEval = forAllSystems (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      checks = forAllSystems (system: {
        pre-commit-check = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            convco.enable = true;
            treefmt = {
              enable = true;
              packageOverrides.treefmt = self.formatter.${system};
            };
          };
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          # packages = with nixpkgs.legacyPackages.${system}; [];
        };
      });

      nixosConfigurations = {
        kul2 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            ./hosts/kul2/configuration.nix
          ];
        };
        kul6 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            lanzaboote.nixosModules.lanzaboote
            nixos-hardware.nixosModules.dell-xps-15-9530
            (import ./nixos-disko/kul6.nix {
              device = "/dev/nvme0n1";
              swapsize = "64G";
            })
            ./hosts/kul6/configuration.nix
          ];
        };
      };
    };

}
