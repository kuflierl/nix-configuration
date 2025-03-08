{ config, lib, pkgs, ... }:
{
  fileSystems."/persist".neededForBoot = true;

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.enable = true;
  hardware.opengl.enable = true;
}
