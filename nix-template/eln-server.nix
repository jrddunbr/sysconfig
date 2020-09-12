{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 25565 ];

  users.users.minecraft = {
    isNormalUser = true;
  }
}