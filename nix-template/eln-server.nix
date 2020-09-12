{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 25565 ];
  environment.systemPackages = with pkgs; [ openjdk8 ];
  users.users.minecraft = {
    isNormalUser = true;
  };
}