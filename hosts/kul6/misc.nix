_: {
  services.flatpak.enable = true;

  # virt-manager with spice redirection support
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;

  # distrobox support for matlab
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # enable udev rules for logic analysers
  programs.pulseview.enable = true;
}
