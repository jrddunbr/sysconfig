{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 25565 ];
  environment.systemPackages = with pkgs; [ openjdk8 screen ];
  users.users.minecraft = {
    isNormalUser = true;
  };
}