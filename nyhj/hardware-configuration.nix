{ config, lib, pkgs, ... }:

# NOTICE!
#
# nyhjrtr04p.ja4.org is scheduled to be DECOMMISSIONED on August 13th, 2020
# The physical hardware will be relocated and configured with
#    varsrtr01p.ja4.org's config hopefully no later than August 16th, 2020.
#
# This also means that nyhj.ja4.org will be decommissioned,
#   and vars.ja4.org will be created, with the same timeline.

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

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