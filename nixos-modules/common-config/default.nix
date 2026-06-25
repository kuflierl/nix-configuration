{ lib, ... }: {
  imports = lib.mapAttrsToList (name: _: ./. + "/${name}") (
    lib.filterAttrs (
      name: type: type == "regular" && name != "default.nix" && lib.hasSuffix ".nix" name
    ) (builtins.readDir ./.)
  );
}
