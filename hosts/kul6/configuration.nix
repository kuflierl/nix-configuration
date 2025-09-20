# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, inputs, ... }:
{
  imports = [
    ../../nixos-modules/misc/flakes-enable.nix
    ../../nixos-modules/sound/pipewire.nix
    ../../nixos-modules/desktop/kde-plasma-6.nix
    # system config
    ./impermanence.nix
    ./hardware-configuration.nix
    ./sops.nix
    ./misc.nix
    ./boot.nix
    ./networking.nix
    # users
    ../../nixos-modules/users/kuflierl/default.nix
  ];

  networking.hostName = "kul6";

  time.timeZone = "Europe/Berlin";

  # keyboard layout
  console.keyMap = "de";
  services.xserver.xkb.layout = "de";

  i18n =
    let
      en_us = "en_US.UTF-8";
      de_de = "de_DE.UTF-8";
    in
    {
      defaultLocale = en_us;
      extraLocaleSettings = {
        LC_ADDRESS = de_de;
        LC_IDENTIFICATION = de_de;
        LC_MEASUREMENT = de_de;
        LC_MONETARY = de_de;
        LC_NAME = de_de;
        LC_NUMERIC = en_us;
        LC_PAPER = de_de;
        LC_TELEPHONE = de_de;
        LC_TIME = de_de;
      };
    };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  users = {
    mutableUsers = false;
    users."kuflierl" = {
      extraGroups = [
        "wheel"
        "libvirtd"
        "wireshark"
      ];
    };
  };

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    # kio-fuse
    kdePackages.kio-fuse
    kdePackages.kio-extras
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
