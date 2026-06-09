_:

# a slightly hardened network manager configuration that randomizes mac addresses
# on a ssid basis by default (IOS behavior)
# It is recommended to further harden the configuration on a ssid basis

{
  networking.networkmanager = {
    # stable for a single ssid may be set to "stable" to make this change between boot sessions
    wifi.macAddress = "stable-ssid";
    wifi.scanRandMacAddress = true;
    ethernet.macAddress = "stable";
  };
}
