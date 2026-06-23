_: {
  fileSystems."/persist".neededForBoot = true;

  system.etc.overlay = {
    enable = true;
    mutable = true; # may still be needed for auto-generated files
  };

  preservation = {
    enable = true;
    preserveAt."/persist/system" = {
      commonMountOptions = [ "x-gvfs-hide" ];
      directories = [
        "/var/lib/bluetooth" # bluetooth settings and connected devices
        "/var/lib/upower" # battery power statistics
        "/var/lib/sbctl" # secureboot keys
        "/var/lib/NetworkManager" # network manager leases, keys, etc
        "/var/lib/systemd" # various keys, timer timestamps and coredumps
        "/etc/NetworkManager/system-connections" # system connections network manager
        {
          # persistent user uid mappings
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key.pub";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key.pub";
          how = "symlink";
          configureParent = true;
        }
      ];
    };
  };

  # bugfix with machine-id-setup
  # https://nix-community.github.io/preservation/examples.html#compatibility-with-systemds-conditionfirstboot
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persistent/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persist/system"
    ];
  };

  boot.initrd.systemd = {
    enable = true;
    services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];
      after = [ "systemd-cryptsetup@nixos.service" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script =
        let
          btrfs_root_subvol = "@root";
          btrfs_old_roots_name = "old_roots";
          root_vol_time_keep = "30";
          mnt_tmp_dir = "/btrfs_tmp";
          mnt_dev = "/dev/mapper/nixos";
        in
        ''
          mkdir -p ${mnt_tmp_dir}
          mount ${mnt_dev} ${mnt_tmp_dir}

          if [[ -e ${mnt_tmp_dir}/${btrfs_root_subvol} ]]; then
              mkdir -p ${mnt_tmp_dir}/${btrfs_old_roots_name}
              timestamp=$(date --date="@$(stat -c %Y ${mnt_tmp_dir}/${btrfs_root_subvol})" "+%Y-%m-%-d_%H:%M:%S")
              mv ${mnt_tmp_dir}/${btrfs_root_subvol} "${mnt_tmp_dir}/${btrfs_old_roots_name}/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "${mnt_tmp_dir}/$i"
              done
              btrfs subvolume delete "$1"
          }

          for i in $(find ${mnt_tmp_dir}/${btrfs_old_roots_name} -maxdepth 1 -mtime +${root_vol_time_keep}); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create ${mnt_tmp_dir}/${btrfs_root_subvol}
          umount ${mnt_tmp_dir}
        '';
    };
  };
}
