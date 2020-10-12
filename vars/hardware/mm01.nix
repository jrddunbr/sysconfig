{ config, lib, pkgs, ... }:
{

  imports =
      [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
      ];

  services.udev.extraRules = "
  KERNEL==\"*\", ATTR{address}==\"52:54:00:87:df:66\", NAME=\"net0\"\n
  ";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/59041bdd-a414-4c8a-a903-94cdb4c0fb5a";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
}