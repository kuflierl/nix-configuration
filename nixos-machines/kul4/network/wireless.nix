{ config, lib, pkgs, ... }:
{
  networking.wireless = {
    enable = true;
    interfaces = [
      "wlan0"
    ];
    environmentFile = "/run/secrets/wifi_env";
    networks = {
      "@HOME1_SSID@" = {
        psk = "@HOME1_PSK@";
      };
    };
  };
}
