{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  swapsize ? throw "Set this to your swapsize, recomended size is your ram size",
  ...
}:
{
  disko.devices = {
    disk.primary = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "2G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
              ];
            };
          };
          luks = {
            size = "100%";
            content = {
              name = "nixos";
              type = "luks";
              settings = {
                allowDiscards = true;
                # keyFile = "/tmp/secret.key";
              };
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                preUnmountHook = "chattr +C /mnt/@var-lib-libvirt";
                subvolumes = {
                  "@root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "discard=async"
                      "noexec"
                    ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "discard=async"
                      "nosuid"
                    ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "discard=async"
                      "exec"
                    ];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "discard=async"
                      "noexec"
                    ];
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "discard=async"
                      "noexec"
                    ];
                  };
                  "@swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = swapsize;
                    mountOptions = [
                      "noatime"
                      "discard=async"
                      "noexec"
                    ];
                  };
                  "@var-lib-libvirt" = {
                    mountpoint = "/var/lib/libvirt";
                    mountOptions = [
                      "noatime"
                      "discard=async"
                      "noexec"
                    ];
                  };
                  "@nixbldtmp" = {
                    mountpoint = "/var/nixbldtmp";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "discard=async"
                      "nosuid"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
