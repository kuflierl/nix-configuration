{ config, lib, pkgs, ... }:

{
  services.displayManager.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # todo add default theme
}
