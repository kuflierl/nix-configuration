_: {
  fileSystems."/persist".neededForBoot = true;

  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth" # bluetooth settings
      "/var/lib/nixos" # persistent user uid mappings
      "/var/lib/upower" # battery power statistics
      "/var/lib/sbctl" # secureboot keys
      "/var/lib/NetworkManager" # network manager leases, keys, etc
      "/var/lib/systemd/coredump"
      "/var/db/sudo/lectured" # sudo lectures
      "/etc/NetworkManager/system-connections" # system connections network manager
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/machine-id"
      #  "/var/lib/logrotate.status"
      {
        file = "/var/keys/secret_file";
        parentDirectory = {
          mode = "u=rwx,g=,o=";
        };
      }
    ];
  };

  boot.initrd.systemd = {
    enable = true;
    services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = [
        "initrd.target"
      ];
      after = [
        "systemd-cryptsetup@nixos.service"
      ];
      before = [
        "sysroot.mount"
      ];
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
