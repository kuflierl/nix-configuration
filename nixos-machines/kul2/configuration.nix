# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ modulesPath, config, lib, pkgs, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ../../nixos-disko/luks-btrfs-subvolumes.nix
      ../../nixos-templates/encrypted-secureboot-sddm/configuration.nix
    ];

  networking.hostName = "kul2"; # Define your hostname.

  boot.lanzaboote.pkiBundle = "/persist/secureboot";

  # automatic timezone setting
  time.timeZone = lib.mkDefault "Europe/Berlin";
  services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
  #   font = "Lat2-Terminus16";
    keyMap = "de";
  #   useXkbConfig = true; # use xkb.options in tty.
  };
  services.xserver.xkb.layout = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };
}
