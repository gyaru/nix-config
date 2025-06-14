{
  config,
  lib,
  ...
}: let
  cfg = config.modules.impermanence;
in {
  options.modules.impermanence = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable impermanence with BTRFS rollback";
    };

    btrfsRootUuid = lib.mkOption {
      type = lib.types.str;
      description = "UUID of the BTRFS root partition";
      example = "caf259ee-b2be-4cf8-b41a-752a09d344a7";
    };

    persistentDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional directories to persist";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd = {
      systemd.services.rollback = {
        description = "rollback BTRFS root subvolume to a clean state";
        wantedBy = ["initrd.target"];
        before = ["sysroot.mount"];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /mnt
          mount -t btrfs -o subvol=/ /dev/disk/by-uuid/${cfg.btrfsRootUuid} /mnt
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
      directories =
        [
          "/var/log"
          "/etc/secureboot"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
        ]
        ++ cfg.persistentDirectories;
    };

    fileSystems."/persist".neededForBoot = true;
  };
}
