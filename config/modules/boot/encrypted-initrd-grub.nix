{ config, lib, pkgs, ... }:

{
  # Use the GRUB bootloader
  # see https://elvishjerricco.github.io/2018/12/06/encrypted-boot-on-zfs-with-nixos.html
  boot.loader = {
    grub = {
      useOSProber = true;
    # Disable Legacy boot
      device = "nodev";
      efiSupport = true;
    # Include the cryptographic keys for dm-crypt in the initrd to mitigate
    # having to reenter the password
      #extraInitrd = "/boot/initrd.keys.gz";
      enableCryptodisk = true;   
    };
    # seperate efi mountpoint from kernel and initrd storage
    efi.efiSysMountPoint = "/efi";
    efi.canTouchEfiVariables = true;
  };
}
