_:

# a slightly hardened network manager configuration that randomizes mac addresses
# on a ssid basis by default (IOS behavior)
# It is recommended to further harden the configuration on a ssid basis

{
  networking.networkmanager = {
    enable = true;
    # stable for a single ssid may be set to "stable" to make this change between boot sessions
    wifi.macAddress = "stable-ssid";
    wifi.scanRandMacAddress = true;
    ethernet.macAddress = "stable";
    # enableStrongSwan = true; # iKEw vpns
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
