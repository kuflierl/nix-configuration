{ nixpkgs, self, ... }: {
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixPath = [ "nixpkgs=${nixpkgs}" ];
  };
  nixpkgs.overlays = [ self.overlays.default ];
}
