{ config, lib, pkgs, ... }:
{

  imports =
      [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
      ];

  services.udev.extraRules = "
  KERNEL==\"*\", ATTR{address}==\"52:54:00:14:35:2c\", NAME=\"net0\"\n
  ";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5902f8d5-f946-4c3f-8202-a3b8ad603cdc";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
}