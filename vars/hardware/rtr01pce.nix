{ config, lib, pkgs, ... }:
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  services.udev.extraRules = "
  KERNEL==\"*\", ATTR{address}==\"00:0d:b9:56:20:10\", NAME=\"ethernet0\"\n
  KERNEL==\"*\", ATTR{address}==\"00:0d:b9:56:20:11\", NAME=\"ethernet1\"\n
  KERNEL==\"*\", ATTR{address}==\"00:0d:b9:56:20:12\", NAME=\"ethernet2\"\n
  ";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/mmcblk0";
  boot.kernelParams = [ "console=ttyS0,115200" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/6583e192-89fb-4948-b877-8c3ebeb43180";
      fsType = "f2fs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/79dcf9c8-b2b2-421d-9519-a2aad100ca89";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
}
