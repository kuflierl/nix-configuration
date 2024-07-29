{ config, lib, pkgs, ... }:

{
  services.displayManager.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  imports = [ ./xserver.nix ];
  # todo add theme
}
