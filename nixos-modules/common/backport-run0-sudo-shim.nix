{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.security.run0;
in
{
  options.security.run0 = {
    sudo-shim.enable = lib.mkEnableOption "make {command}`sudo` an alias to {command}`run0`.";
    sudo-shim.package = lib.mkPackageOption pkgs "run0-sudo-shim" { };
  };

  config = {
    assertions = [
      {
        assertion =
          cfg.sudo-shim.enable
          -> (!config.security.sudo.enable && !config.security.sudo-rs.enable && !cfg.enableSudoAlias);
        message = "`security.run0.sudo-shim.enable` cannot be enabled if `security.sudo`, `security.sudo-rs` or `security.run0.enableSudoAlias` are enabled.";
      }

    ];

    environment.systemPackages = lib.optional cfg.sudo-shim.enable cfg.sudo-shim.package;
  };
}
