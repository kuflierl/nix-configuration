{
  description = "kuflierl's main nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      sops-nix,
      lanzaboote,
      disko,
      nixos-hardware,
      impermanence,
      git-hooks,
      treefmt-nix,
      home-manager,
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
        };

      flake = {
        nixosConfigurations = {
          kul6 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit nixpkgs; };
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

        homeConfigurations."kuflierl" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home/kuflierl/home.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
      };
    });
}
