{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [ ./hardware-configuration.nix ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  networking = {
    hostName = "radiata";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ]; # cloudflare, google as backup
  };

  boot = {
    consoleLogLevel = 0;
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    kernelParams = [
      "preempt=full"
      "mitigations=off"
      "amd_pstate=passive"
      "amd_pstate.shared_mem=1"
      "initcall_blacklist=acpi_cpufreq_init"
      "quiet"
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

    bootspec.enable = true;
    initrd = {
      systemd.enable = true;
      supportedFilesystems = [ "btrfs" ];
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        configurationLimit = 3;
        consoleMode = "max";
        editor = false;
      };
      systemd-boot.enable = lib.mkForce false;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  # zsh goes brum
  environment = {
    binsh = "${pkgs.zsh}/bin/zsh";
    pathsToLink = [ "/share/zsh" ];
    shells = with pkgs; [ zsh ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # try to run electron w/ wayland
    };
    systemPackages = __attrValues {
      inherit (pkgs)
        file nano curl fd man-pages man-pages-posix ripgrep wget home-manager
        nixfmt sbctl ntfs3g comma;
    };
  };

  # fonts TODO: change to shit i like
  fonts = {
    packages = __attrValues {
      inherit (pkgs)
        noto-fonts noto-fonts-emoji noto-fonts-cjk-sans noto-fonts-cjk-serif
        rounded-mgenplus maple-mono-NF;
    };

    fontconfig = {
      enable = lib.mkDefault true;

      # TODO: edit fonts to something i actually like
      defaultFonts = {
        monospace = [ "Maple Mono NF" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # locales
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
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
  };

  # TODO: move?
  qt.platformTheme = "qt5ct";

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
    };
  };

  # user
  users.users.lis = {
    isNormalUser = true;
    home = "/home/lis";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "audio" "realtime" "input" ];
  };

  # systemd
  systemd = {
    services.rtkit-daemon.serviceConfig.ExecStart = [
      ""
      "${pkgs.rtkit}/libexec/rtkit-daemon --our-realtime-priority=95 --max-realtime-priority=90"
    ];
    user.services = {
      pipewire.wantedBy = [ "default.target" ];
      pipewire-pulse.wantedBy = [ "default.target" ];
    };
  };

  # time
  time = { timeZone = "Europe/Stockholm"; };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
