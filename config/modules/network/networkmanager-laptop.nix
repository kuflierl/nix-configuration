{ config, lib, pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    # stable for a single ssid may be set to "stable" to make this change between boot sessions
    wifi.macAddress = "stable-ssid"
    wifi.scanRandMacAddress = true;
    ethernet.macAddress = "stable"
    enableStrongSwan = true; # iKEw vpns
  };
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
