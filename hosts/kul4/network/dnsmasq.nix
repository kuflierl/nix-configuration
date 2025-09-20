{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.resolved.enable = false;
  services.dnsmasq = {
    enable = true;
    settings = {
      # upstream DNS servers
      server = [
        "9.9.9.9"
        "1.1.1.1"
      ];
      # sensible behaviours
      domain-needed = true;
      bogus-priv = true;
      no-resolv = true;

      # Cache dns queries.
      cache-size = 1000;

      dhcp-range = [ "br-lan,192.168.10.50,192.168.10.254,24h" ];
      interface = "br-lan";
      dhcp-host = "192.168.10.1";

      # local domains
      local = "/lan/";
      domain = "lan";
      expand-hosts = true;

      # don't use /etc/hosts as this would advertise surfer as localhost
      no-hosts = true;
      address = "/kul4.lan/192.168.10.1";
    };
  };
}
