{
  description = "kuflierl's main nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    preservation.url = "github:nix-community/preservation";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      # causes breakage on stable
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Add cachix/devenv as an input so we can provide a devenv-based devShell
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-parts,
      sops-nix,
      lanzaboote,
      disko,
      nixos-hardware,
      preservation,
      git-hooks,
      home-manager,
      nvf,
      devenv,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (_: {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
          # compute the git-hooks pre-commit check used to provide packages and shellHook
          preCommitCheck = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              convco.enable = true;
              treefmt = {
                enable = true;
              };
            };
          };
        in
        {
          checks.pre-commit-check = preCommitCheck;

          # Replace the old mkShell devShell with a devenv-based shell. The
          # devenv configuration is kept in ./devenv.nix and receives the
          # computed preCommitCheck so it can include the same packages and
          # shellHook that the old shell provided.
          devShells.default = devenv.lib.mkShell {
            inherit pkgs;
            modules = [ (import ./devenv.nix { inherit pkgs preCommitCheck; }) ];
          };

          packages.myNVF =
            (nvf.lib.neovimConfiguration {
              pkgs = nixpkgs-unstable.legacyPackages.${system};
              modules = [ ./nvf ];
            }).neovim;
        };

      flake = {
        overlays.default = import ./overlays;

        nixosConfigurations = {
          kul6 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit self nixpkgs; };
            modules = [
              disko.nixosModules.disko
              preservation.nixosModules.preservation
              sops-nix.nixosModules.sops
              lanzaboote.nixosModules.lanzaboote
              nixos-hardware.nixosModules.dell-xps-15-9530
              ./nixos-modules/common
              ./nixos-modules/common-config
              ./hosts/kul6/configuration.nix
            ];
          };
        };

        homeConfigurations."kuflierl" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home/kuflierl/home.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = { inherit self; };
        };
      };
    });
}
