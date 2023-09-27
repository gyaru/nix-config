{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd" "amd-pstate"];
  boot.extraModulePackages = [];

  # root
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/caf259ee-b2be-4cf8-b41a-752a09d344a7";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd" "noatime"];
  };
  # home
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/caf259ee-b2be-4cf8-b41a-752a09d344a7";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd" "noatime"];
  };
  # nix
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/caf259ee-b2be-4cf8-b41a-752a09d344a7";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };
  # persist
  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/caf259ee-b2be-4cf8-b41a-752a09d344a7";
    fsType = "btrfs";
    options = ["subvol=persist" "compress=zstd" "noatime"];
    neededForBoot = true;
  };
  # boot
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/601B-12CD";
    fsType = "vfat";
  };

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
