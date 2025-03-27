{ config, lib, pkgs, ... }:
{
  imports = [
    ../../nixos-modules/hardware/Intel-Arc-A370M-autopwrmgnt.nix
  ];

  fileSystems."/persist".neededForBoot = true;

  nix.settings.build-dir = "/var/nixbldtmp";

  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
}
