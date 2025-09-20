{ ... }:

# see https://elvishjerricco.github.io/2018/12/06/encrypted-boot-on-zfs-with-nixos.html
# Include the cryptographic keys for dm-crypt in the initrd to mitigate
# having to reenter the password

{
  boot = {
    loader.grub = {
      enableCryptodisk = true;
    };
    initrd = {
      luks.devices."nixos".keyFile = "/nixos.keyfile.bin";
      secrets = {
        "/nixos.keyfile.bin" = "/persist/boot/nixos.keyfile.bin";
      };
    };
  };
}
