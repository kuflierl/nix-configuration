{ config, lib, pkgs, ... }:
{
  # inspired from the following:
  # https://github.com/ghostbuster91/blogposts/blob/a2374f0039f8cdf4faddeaaa0347661ffc2ec7cf/router2023-part2/main.md
  imports = [
    ./dnsmasq.nix
    ./wireless.nix
  ];
  networking = {
    useNetworkd = true;
    useDHCP = false;

    nat.enable = false;
    firewall.enable = false;

    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0; policy drop;

            iifname { "br-lan" } accept comment "Allow local network to access the router"
            iifname { "wlan0" } tcp dport { ssh } accept comment "enable specific services from wlan"
            iifname { "iphone", "wlan0" } ct state { established, related } accept comment "Allow established traffic"
            iifname { "iphone", "wlan0" } icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
            iifname { "iphone", "wlan0" } counter drop comment "Drop all other unsolicited traffic from wan"
            iifname "lo" accept comment "Accept everything from loopback interface"
          }
          chain forward {
            type filter hook forward priority filter; policy drop;

            iifname { "br-lan" } oifname { "iphone", "wlan0" } accept comment "Allow trusted LAN to WAN"
            iifname { "iphone", "wlan0" } oifname { "br-lan" } ct state { established, related } accept comment "Allow established back to LANs"
          }
        }

        table ip nat {
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname { "iphone", "wlan0" } masquerade
          }
        }
      '';
    };
  };
  # enable systemd networkd for static interfaces
  systemd.network.enable = true;
  # set custom interface names
  systemd.network.links = {
    "80-iphone-hotspot" = {
      # the following line checks if the driver is ipeth
      # ipeth is the kernel driver for ios tethering
      matchConfig.Driver = "ipheth";
      linkConfig.Name = "iphone";
    };
  };
  systemd.network.netdevs = {
    "10-br-lan" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br-lan";
      };
    };
  };
  systemd.network.networks = {
    "20-end0" = {
      matchConfig.Name = "end0";
      linkConfig.RequiredForOnline = "enslaved";
      networkConfig.Bridge = "br-lan";
      networkConfig.ConfigureWithoutCarrier = true;
    };
    "81-iphone-hotspot" = {
      matchConfig.Name = "iphone";
      networkConfig.DHCP = "ipv4";
      # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
      networkConfig.IPv6AcceptRA = true;
      networkConfig.IPv6PrivacyExtensions = false;
      networkConfig.IPForward = true;
      linkConfig.RequiredForOnline = false;
      dhcpV4Config.RouteMetric = 400;
    };
    "30-br-lan" = {
      matchConfig.Name = "br-lan";
      networkConfig.DHCP = false;
      bridgeConfig = { };
      address = [
        "192.168.10.1/24"
      ];
      networkConfig = {
        ConfigureWithoutCarrier = true;
      };
    };
    "40-wlan0" = {
      matchConfig.Name = "wlan0";
      networkConfig.DHCP = true;
      networkConfig.IPv6AcceptRA = true;
      linkConfig.RequiredForOnline = false;
      networkConfig.IPForward = true;
      dhcpV4Config.RouteMetric = 600;
    };
  };
}
