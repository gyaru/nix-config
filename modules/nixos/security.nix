_: {
  boot.kernel.sysctl = {
    "kernel.unprivileged_userns_clone" = 1;
    "kernel.printk" = "3 3 3 3";
  };

  security = {
    polkit.enable = true;
  };
}
