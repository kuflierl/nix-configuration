{ config, pkgs, lib, ... }:

let
  extraLocale = "de_DE.UTF-8";
in {
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

  system.stateVersion = "24.05";
}
