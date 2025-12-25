{ pkgs, ... }:

{
  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    libimobiledevice
    idevicerestore
    ifuse # optional, to mount using 'ifuse'
  ];
}
