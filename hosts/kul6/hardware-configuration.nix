{ lib, ... }: {
  imports = [
    (import ./disko.nix {
      device = "/dev/nvme0n1";
      swapsize = "64G";
    })
  ];

  services.udev.extraRules = ''
    # Intel Arc A370M dGPU: restore automatic power management.
    ACTION=="add|bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0x5693", TEST=="power/control", ATTR{power/control}="auto"
  '';

  nix.settings.build-dir = "/var/nixbldtmp";

  hardware = {
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
    graphics.enable = true;
    intelgpu = {
      driver = "i915";
      vaapiDriver = "intel-media-driver";
      mediaRuntime = "vpl-gpu-rt";
    };
    # enable mode switching for multi certain USB WLAN and WWAN adapters
    usb-modeswitch.enable = true;
  };

  specialisation.xe-graphics.configuration = {
    hardware.intelgpu.driver = lib.mkForce "xe";
  };
}
