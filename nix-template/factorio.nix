{ config, pkgs, ... }:
{
  networking.firewall.allowedUDPPorts = [ 34197 ];
  users.users.factorio = {
    isNormalUser = true;
  };
}
