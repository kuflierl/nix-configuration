{ pkgs, ... }:

{
  services.usbmuxd.package = pkgs.usbmuxd2;
}
