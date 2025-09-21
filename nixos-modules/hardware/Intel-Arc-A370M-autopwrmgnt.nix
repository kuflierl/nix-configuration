_: {
  systemd.services."A370M-dGPU-autopwrmgnt" = {
    script = ''
      set -eu
      echo "auto" > /sys/bus/pci/devices/0000:03:00.0/power/control
    '';
    wantedBy = [ "multi-user.target" ];
    description = "Enables D3 sleep for the Intel Arc A370M dGPU";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
