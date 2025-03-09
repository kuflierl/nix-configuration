{ config, lib, pkgs, ... }:
{
  fileSystems."/persist".neededForBoot = true;

  nix.settings.build-dir = "/var/nixbldtmp";

  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
}
