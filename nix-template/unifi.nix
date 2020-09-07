{ config, pkgs, ... }:
{
  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifiStable;
    openPorts = false; # Too unrestrictive
  };
}
