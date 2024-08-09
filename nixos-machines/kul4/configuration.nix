{ config, lib, pkgs, ... }:
{
  # configuration for travel service hotspot
  imports = [
    ../../nixos-templates/raspberrypi4-headless/configuration.nix
    ../../nixos-modules/misc/ios-device-core.nix
  ];

  networking.hostName = "kul4";

  # automatic timezone setting
  time.timeZone = lib.mkDefault "Europe/Berlin";
  services.automatic-timezoned.enable = true;
}
