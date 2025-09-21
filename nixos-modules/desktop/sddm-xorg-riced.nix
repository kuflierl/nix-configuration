_: {
  services.displayManager = {
    enable = true;
    sddm.enable = true;
    sddm.wayland.enable = false;
  };
  imports = [ ./xserver.nix ];
  # todo add defualt theme
}
