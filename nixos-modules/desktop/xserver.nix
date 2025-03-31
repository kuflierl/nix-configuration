{ ... }:

{
  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
