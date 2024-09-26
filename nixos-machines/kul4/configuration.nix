{ config, lib, pkgs, ... }:
{
  # configuration for travel service hotspot
  imports = [
    ../../nixos-templates/raspberrypi4-headless/configuration.nix
    ../../nixos-modules/misc/ios-device-core.nix
    ../../nixos-modules/misc/usbmuxd2.nix
    ../../nixos-modules/hardware/rtl88x2bu.nix
    # users
    ../../nixos-modules/users/kuflierl/default.nix
    ../../nixos-modules/users/mflierl/default.nix
    # system specific config
    ./network/default.nix
    ./sops.nix
  ];

  networking.hostName = "kul4";

  # automatic timezone setting
  time.timeZone = lib.mkDefault "Europe/Berlin";
  services.automatic-timezoned.enable = true;

  nix.settings.allowed-users = [
    "@wheel"
    mflierl
  ];

  users = {
    mutableUsers = false;
    users."kuflierl" = {
      extraGroups = [ "wheel" ];
    };
  };
}
