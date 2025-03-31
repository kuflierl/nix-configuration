{ ... }:
{
  imports = [
    ../../nixos-modules/hardware/Intel-Arc-A370M-autopwrmgnt.nix
  ];

  nix.settings.build-dir = "/var/nixbldtmp";

  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
}
