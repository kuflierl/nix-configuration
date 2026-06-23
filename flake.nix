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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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
      inputs.flake-parts.follows = "flake-parts";
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
      treefmt-nix,
      home-manager,
      nvf,
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
          treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          formatter = treefmtEval.config.build.wrapper;
          checks.pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              convco.enable = true;
              treefmt = {
                enable = true;
                packageOverrides.treefmt = config.formatter;
              };
            };
          };
          devShells.default = pkgs.mkShell {
            inherit (config.checks.pre-commit-check) shellHook;
            buildInputs = config.checks.pre-commit-check.enabledPackages;
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
