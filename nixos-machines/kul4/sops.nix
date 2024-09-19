{ config, lib, pkgs, ... }:
{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/kul4/default.yaml;
  sops.defaultSopsFormat = "yaml";
  # secrets go here
  sops.secrets."wifi/main_passwd" = {};
}
