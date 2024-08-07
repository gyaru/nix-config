{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    (inputs.impermanence + "/nixos.nix")
  ];

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath =
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://anyrun.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  networking = {
    hostName = "radiata";
    useDHCP = lib.mkDefault true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ]; # cloudflare, google as backup
  };

  fileSystems = {
    # root
    "/" = {
      device = "/dev/disk/by-uuid/caf259ee-b2be-4cf8-b41a-752a09d344a7";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime" "discard=async" "space_cache=v2"];
    };
    # nix
    "/nix" = {
      device = "/dev/disk/by-uuid/caf259ee-b2be-4cf8-b41a-752a09d344a7";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime" "discard=async" "space_cache=v2"];
    };
    # persist
    "/persist" = {
      device = "/dev/disk/by-uuid/caf259ee-b2be-4cf8-b41a-752a09d344a7";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime" "discard=async" "space_cache=v2"];
      neededForBoot = true;
    };
    # boot
    "/boot" = {
      device = "/dev/disk/by-uuid/601B-12CD";
      fsType = "vfat";
      neededForBoot = true;
    };
    # efi
    "/efi" = {
      device = "/dev/disk/by-uuid/6A71-B54B";
      fsType = "vfat";
      neededForBoot = true;
    };
  };

  boot = {
    #consoleLogLevel = 0;
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    kernelParams = [
      "preempt=full"
      "mitigations=off"
      "amd_pstate=guided"
      "amd_pstate.shared_mem=1"
      "initcall_blacklist=acpi_cpufreq_init"
      #"quiet"
      "udev.log_level=3"
    ];

    kernel.sysctl = {
      "fs.file-max" = 2097152;
      "kernel.printk" = "3 3 3 3";
      "kernel.sched_migration_cost_ns" = 5000000;
      "kernel.sched_nr_fork_threshold" = 3;
      "kernel.sched_fake_interactive_win_time_ms" = 1000;
      "kernel.unprivileged_userns_clone" = 1;
      "net.core.default_qdisc" = "fq_pie";
      "vm.dirty_ratio" = 60;
      "vm.dirty_background_ratio" = 2;
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 75;
      "net.core.netdev_max_backlog" = 16384;
      "net.core.somaxconn" = 8192;
      "net.core.rmem_default" = 1048576;
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_default" = 1048576;
      "net.core.wmem_max" = 16777216;
      "net.core.optmem_max" = 65536;
      "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.udp_rmem_min" = 8192;
      "net.ipv4.udp_wmem_min" = 8192;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_keepalive_time" = 60;
      "net.ipv4.tcp_keepalive_intvl" = 10;
      "net.ipv4.tcp_keepalive_probes" = 6;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_congestion_control" = "bbr2";
    };

    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    bootspec.enable = true;
    initrd = {
      kernelModules = [];
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      systemd.enable = true;
      supportedFilesystems = ["btrfs"];
      systemd.services.rollback = {
        description = "rollback BTRFS root subvolume to a clean state";
        wantedBy = [
          "initrd.target"
        ];
        before = [
          "sysroot.mount"
        ];
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
        wantedBy = [
          "initrd.target"
        ];
        after = [
          "sysroot.mount"
        ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /sysroot/etc/
          ln -snfT /persist/etc/machine-id /sysroot/etc/machine-id
        '';
      };
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/efi";
      systemd-boot = {
        enable = lib.mkForce (config.boot.lanzaboote.enable != true);
        configurationLimit = 2;
        consoleMode = "max";
        editor = false;
      };
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
    };
  };

  environment = {
    binsh = "${pkgs.zsh}/bin/zsh";
    pathsToLink = ["/share/zsh"];
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [
      file
      nano
      curl
      fd
      git
      man-pages
      man-pages-posix
      ripgrep
      wget
      jq
      home-manager
      alejandra
      sbctl
      ntfs3g
      comma
      atool
      unzip
      p7zip
      nix-output-monitor
      edk2-uefi-shell
    ];

    persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/etc/secureboot"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
      ];
    };
  };

  # fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-monochrome-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      maple-mono-NF
      (callPackage ../../pkgs/mplus-fonts {}) # TODO: do I really need to call it like this?
      (callPackage ../../pkgs/balsamiqsans {})
      (callPackage ../../pkgs/lucide-icons {})
    ];
    fontconfig = {
      enable = lib.mkDefault true;
      defaultFonts = {
        monospace = ["M PLUS 1 Code"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  # locales
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # set cpu freq governor
  powerManagement.cpuFreqGovernor = "performance";

  # programs
  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    zsh.enable = true;
    fuse.userAllowOther = true; # impermanence
  };

  # security
  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  # services
  services = {
    chrony = {
      enable = true;
      servers = [
        "0.nixos.pool.ntp.org"
        "1.nixos.pool.ntp.org"
        "2.nixos.pool.ntp.org"
        "3.nixos.pool.ntp.org"
      ];
    };
    journald.extraConfig = lib.mkForce "";
    pipewire = {
      enable = true;
      socketActivation = false;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    flatpak.enable = true;
  };

  # users
  users.mutableUsers = false;
  users.users.root.hashedPasswordFile = "/persist/passwords/root";
  users.users.lis = {
    isNormalUser = true;
    shell = pkgs.zsh;
    group = "users";
    extraGroups = ["wheel" "video" "audio" "realtime" "input"];
    hashedPasswordFile = "/persist/passwords/lis";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    configPackages = [pkgs.xdg-desktop-portal-hyprland];
    config.common.default = [pkgs.xdg-desktop-portal-hyprland];
  };

  # systemd
  systemd = {
    services.rtkit-daemon.serviceConfig.ExecStart = [
      ""
      "${pkgs.rtkit}/libexec/rtkit-daemon --our-realtime-priority=95 --max-realtime-priority=90"
    ];
    user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };
  };

  # time
  time = {
    timeZone = "Europe/Stockholm";
  };

  system.stateVersion = "23.11";
}
