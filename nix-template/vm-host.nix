{ config, pkgs, ... }:
{
  # I dislike that it uses the British English spelling when everything else seems to be American English.
  virtualisation.libvirtd.enable = true;
}