{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];


  services.udev.extraRules = "
  KERNEL=\"*\", ATTR(address)==\"08:9e:01:cc:92:5d\", NAME=\"ethernet0\"\n
  KERNEL=\"*\", ATTR(address)==\"58:94:6b:3c:bf:d0\", NAME=\"wifi0\"\n
  ";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "lpvm/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "lpvm/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "lpvm/home";
      fsType = "zfs";
    };

  fileSystems."/virt" =
    { device = "lpvm/virt";
      fsType = "zfs";
    };

  fileSystems."/iso" =
    { device = "lpvm/iso";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/557D-20B0";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
