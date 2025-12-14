{ ... }:
{
  imports = [
    ../../nixos-modules/network/networkmanager-laptop.nix
  ];
  networking.firewall = {
    # open firewall for syncthing
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [
      21027
      22000
    ];
    # open firewall for kde connect
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };
}
