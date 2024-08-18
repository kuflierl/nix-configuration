{ config, lib, pkgs, ... }:
{
  networking = {
    useNetworkd = true;
    useDHCP = false;
  };
  # enable systemd networkd for static interfaces
  systemd.network.enable = true;
  systemd.network.networks = {
    "81-iphone-hotspot" = {
      # the following line checks if the driver is ipeth
      # ipeth is the kernel driver for ios tethering
      matchConfig.Driver = "ipheth";
      linkConfig.Name = "iphone";
      networkConfig.DHCP = "ipv4";
      # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
      networkConfig.IPv6AcceptRA = true;
      # temporarily enable dns protections
      # networkConfig.DNSOverTLS = true;
      networkConfig.DNSSEC = true;
      networkConfig.IPv6PrivacyExtensions = false;
      networkConfig.IPForward = true;
      linkConfig.RequiredForOnline = false;
    };
    "20-eth0" = {
      matchConfig.Name = "end0";
      networkConfig.DHCP = true;
    }
    "10-lan" = {
      matchConfig.Name = "lan";
      networkConfig.DHCP = true;
    };
  };
}
