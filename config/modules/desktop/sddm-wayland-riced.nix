{ config, lib, pkgs, ... }:

{
  #services.displayManager.enable = true;
  #services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.wayland.enable = true;
  
  # todo: move to flakes to get experimental wayland support
  imports = [ ./xserver.nix ];
  services.xserver.displayManager.sddm.enable = true;
  # todo add theme
}
