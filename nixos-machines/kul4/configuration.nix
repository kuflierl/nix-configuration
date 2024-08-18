{ config, lib, pkgs, ... }:
{
  # configuration for travel service hotspot
  imports = [
    ../../nixos-templates/raspberrypi4-headless/configuration.nix
    ../../nixos-modules/misc/ios-device-core.nix
    ./network.nix
  ];

  networking.hostName = "kul4";

  # automatic timezone setting
  time.timeZone = lib.mkDefault "Europe/Berlin";
  services.automatic-timezoned.enable = true;

  users = {
    #mutableUsers = false;
    users."kuflierl" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6YiltO91AlndYCt8gmu6uhtnrVLW6D1Wm0UunQgdlf5ZVyTclvIiBI34S/iPwkU5JsMorpsfwOZI+natL0NcJQ2Dgoax7yBDov3d2viU3yRJgqaSGsDDfIhS968shUwYg3ZOgp4jb1IL2De0FZqxgJhXRuDe8uR13joCFwbzm+l8WBg5SKc+WH3BXIVo8LM9t1lsQ6Xuc8tjYfCksbFhkmMsto/sYxhvcbrHRCbNTgeN1zwYIW24ewpD/phGKKPivgUSsNyYLz5cib3qfje1lfyblfxKRd6giS84XSGOWsXHTk0TCI/jGjk1Z59fM0p/4RjJDObX/YE2Y5xqKARZEvE0njo1A8gkNpewIrBbpJMuCrXVEpRJQhFTyaAm2IytP/9SzvWxJ3vXBLCgcma9thGw3l1aX6oUjS8OK8ZZPoJrxrpyL42cK/i4HIltZy2AuM3OgW1i3yA0PxoDDXZMbTGv5/icH1UrMJUEU2yrQrrDp/mBhNFYwNYMrz5mZOJE= private"
    ];
    };
  };
}
