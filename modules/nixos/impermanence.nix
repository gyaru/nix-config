# Impermanence configuration with BTRFS rollback
_: {
  boot.initrd = {
    systemd.services.rollback = {
      description = "rollback BTRFS root subvolume to a clean state";
      wantedBy = ["initrd.target"];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt
        mount -t btrfs -o subvol=/ /dev/nvme0n1p4 /mnt
        btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "deleting /root subvolume..." &&
          btrfs subvolume delete /mnt/root
        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root
        umount /mnt
      '';
    };

    systemd.services.persisted-files = {
      description = "hard-link persisted files from /persist";
      wantedBy = ["initrd.target"];
      after = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /sysroot/etc/
        ln -snfT /persist/etc/machine-id /sysroot/etc/machine-id
      '';
    };
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/etc/secureboot"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/flatpak"
      "/etc/coolercontrol"
    ];
  };

  fileSystems."/persist".neededForBoot = true;
}
