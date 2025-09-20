{ ... }:
{
  imports = [
    ../../nixos-modules/network/networkmanager-laptop.nix
  ];
  services.syncthing.openDefaultPorts = true;
  # open firewall for kde connect
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
}
