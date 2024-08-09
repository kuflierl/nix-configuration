{ config, pkgs, lib, ... }:

let
  user = "tempuser";
  password = "somepass";
  nixosHardwareVersion = "7f1836531b126cfcf584e7d7d71bf8758bb58969";

  extraLocale = "de_DE.UTF-8";
in {
  imports = ["${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/${nixosHardwareVersion}.tar.gz" }/raspberry-pi/4"];

  services.openssh.enable = lib.mkDefault true;

  i18n = {
    defaultLocale = en_US.UTF-8;
    extraLocaleSettings = {
      LC_ADDRESS = extraLocale;
      LC_IDENTIFICATION = extraLocale;
      LC_MEASUREMENT = extraLocale;
      LC_MONETARY = extraLocale;
      LC_NAME = extraLocale;
      LC_NUMERIC = extraLocale;
      LC_PAPER = extraLocale;
      LC_TELEPHONE = extraLocale;
      LC_TIME = extraLocale;
    };
  };

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [ "wheel" ];
    };
  };

  system.stateVersion = "24.05";
}
