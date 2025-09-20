{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.wireless = {
    enable = true;
    interfaces = [
      "wlan0"
    ];
    environmentFile = config.sops.templates."wifi_env".path;
    networks = {
      "@HOME1_SSID@" = {
        psk = "@HOME1_PSK@";
      };
    };
  };
}
