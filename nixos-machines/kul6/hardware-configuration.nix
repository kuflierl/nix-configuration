{ config, lib, pkgs, ... }:
{
  fileSystems."/persist".neededForBoot = true;
}
