{ config, self, ... }:
let
  wifi_home1_bcfg = {
    sopsFile = self + "/secrets/wifi/home1.yaml";
    format = "yaml";
  };
in
{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../../secrets/machines/kul4.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "wifi/main_passwd" = { }; # for wifi AP
      # wifi
      "wifi/home1/ssid" = wifi_home1_bcfg // {
        key = "ssid";
      };
      "wifi/home1/password" = wifi_home1_bcfg // {
        key = "password";
      };
    };
    templates."wifi_env".content = ''
      HOME1_SSID = "${config.sops.placeholder."wifi/home1/ssid"}"
      HOME1_PSK = "${config.sops.placeholder."wifi/home1/password"}"
    '';
  };
}
