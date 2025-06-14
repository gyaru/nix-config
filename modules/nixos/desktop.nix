_: {
  boot.kernel.sysctl = {
    "fs.file-max" = 2097152;

    "kernel.sched_autogroup_enabled" = 1;
    "kernel.sched_child_runs_first" = 1;
    "kernel.sched_fake_interactive_win_time_ms" = 1000;
    "kernel.sched_migration_cost_ns" = 5000000;
    "kernel.sched_nr_fork_threshold" = 3;

    "vm.dirty_background_ratio" = 2;
    "vm.dirty_ratio" = 60;
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 75;

    "net.core.default_qdisc" = "fq_pie";
    "net.core.netdev_max_backlog" = 16384;
    "net.core.optmem_max" = 65536;
    "net.core.rmem_default" = 1048576;
    "net.core.rmem_max" = 16777216;
    "net.core.somaxconn" = 8192;
    "net.core.wmem_default" = 1048576;
    "net.core.wmem_max" = 16777216;

    "net.ipv4.tcp_congestion_control" = "bbr2";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_keepalive_intvl" = 10;
    "net.ipv4.tcp_keepalive_probes" = 6;
    "net.ipv4.tcp_keepalive_time" = 60;
    "net.ipv4.tcp_mtu_probing" = 1;
    "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "net.ipv4.udp_rmem_min" = 8192;
    "net.ipv4.udp_wmem_min" = 8192;
  };

  boot.tmp.useTmpfs = true;

  services = {
    flatpak.enable = true;
    earlyoom.enable = true;
  };

  hardware.bluetooth.enable = true;
}
