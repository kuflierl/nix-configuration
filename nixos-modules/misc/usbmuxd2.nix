{ config, lib, pkgs, ... }:

{
  services.usbmuxd.package = pkgs.usbmuxd2;
}
