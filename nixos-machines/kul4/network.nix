{ config, lib, pkgs, ... }:
{
  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
  # set custom interface names
  systemd.network.links = {
    "80-iphone-hotspot" = {
      # the following line checks if the driver is ipeth
      # ipeth is the kernel driver for ios tethering
      matchConfig.Driver = "ipheth";
      linkConfig.Name = "iphone";
    };
  };
  # enable systemd networkd for static interfaces
  systemd.network.enable = true;
  systemd.network.networks = {
    "81-iphone-hotspot" = {
      matchConfig.Name = "iphone";

      address = [
        # configure addresses including subnet mask
        "172.20.10.2/28"
        # "2001:DB8::2/64"
      ];

      dns = [
        "172.20.10.1"
      ];

      routes = [
        # create default routes ipv4
        { routeConfig.Gateway = "172.20.10.1"; }
      ];

      # networkConfig.DHCP = "ipv4";
      # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
      networkConfig.IPv6AcceptRA = true;
      # temporarily enable dns protections
      # networkConfig.DNSOverTLS = true;
      # networkConfig.DNSSEC = true;
      networkConfig.IPv6PrivacyExtensions = false;
      networkConfig.IPForward = true;
      linkConfig.RequiredForOnline = false;
    };
    "20-eth0" = {
      matchConfig.Name = "end0";
      networkConfig.DHCP = true;
    };
    "10-lan" = {
      matchConfig.Name = "lan";
      networkConfig.DHCP = true;
    };
  };
}
