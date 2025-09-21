_: {
  # Use the GRUB bootloader
  boot.loader = {
    grub = {
      useOSProber = true;
      # Disable Legacy boot
      device = "nodev";
      efiSupport = true;
    };
    # seperate efi mountpoint from kernel and initrd storage
    efi.efiSysMountPoint = "/efi";
    efi.canTouchEfiVariables = true;
  };
}
