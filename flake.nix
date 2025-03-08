{
  description = "kuflierl's main nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:kuflierl/lanzaboote";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:kuflierl/nixos-hardware/dell-xps-15-9530-nofingerprint";
    disko = {
      url = "github:nix-community/disko/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix =  {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
          (import ./nixos-disko/kul6.nix {
            device  = "/dev/nvme0n1";
            swapsize = "64G";
          })
          ./nixos-machines/kul6/configuration.nix
        ];
      };
      kul6l = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.dell-xps-15-9530
          (import ./nixos-disko/kul6.nix {
            device  = "/dev/nvme1n1";
            swapsize = "48G";
          })
          ./nixos-machines/kul6/configuration.nix
        ];
      };
    };
  };

}
