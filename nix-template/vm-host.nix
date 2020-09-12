{ config, pkgs, ... }:
{
  # I dislike that it uses the British English spelling when everything else seems to be American English.
  virtualisation.libvirtd.enable = true;

  # Add users to libvirtd so that they can do the thing
  users.users.jared.extraGroups = [ "libvirtd" ];
}