{ ... }:
{
  imports = [
    ../../nixos-modules/hardware/Intel-Arc-A370M-autopwrmgnt.nix
  ];

  nix.settings.build-dir = "/var/nixbldtmp";

  hardware = {
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
    graphics.enable = true;
    # enable mode switching for multi certain USB WLAN and WWAN adapters
    usb-modeswitch.enable = true;
  };
}
