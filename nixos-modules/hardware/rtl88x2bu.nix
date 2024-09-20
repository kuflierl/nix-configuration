{ config, lib, pkgs, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl88x2bu
  ];
}
