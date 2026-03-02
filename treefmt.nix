# treefmt.nix
_: {
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    # rfc nix formater
    nixfmt = {
      enable = true;
      strict = true;
    };
    # detect antipaterns in nix code
    statix = {
      enable = true;
      disabled-lints = [ ];
    };
    # look for dead nix code
    deadnix = {
      enable = true;
    };
  };
}
