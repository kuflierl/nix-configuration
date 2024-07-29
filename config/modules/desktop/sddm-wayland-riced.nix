{ config, lib, pkgs, ... }:

{
  services.displayManager.sddm.enable = true;
  services.displayManager.wayland.enable = true;
  # todo add theme
}
