{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "amd-pstate" ];
  boot.extraModulePackages = [ ];

  # root
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e64da22e-6b00-4e94-9e50-58d98b23fcd4";
    fsType = "btrfs";
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
