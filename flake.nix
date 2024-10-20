{
  description = "kuflierl's main nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:kuflierl/lanzaboote";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:kuflierl/nixos-hardware";
    disko = {
      url = "github:nix-community/disko/v1.6.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix =  {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  outputs = { self, nixpkgs, sops-nix, lanzaboote, disko, nixos-hardware, impermanence }@inputs: {
    nixosConfigurations = {
      kul2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          lanzaboote.nixosModules.lanzaboote
          ./nixos-machines/kul2/configuration.nix
        ];
      };
      kul4 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit self;};
        modules = [
          sops-nix.nixosModules.sops
          nixos-hardware.nixosModules.raspberry-pi-4
          ./nixos-machines/kul4/configuration.nix
        ];
      };
      kul6 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.dell-xps-15-9530
          (import ./nixos-disko/kul6.nix { device  = "/dev/nvme0n1"; })
          ./nixos-machines/kul6/configuration.nix
        ];
      };
    };
  };

}
