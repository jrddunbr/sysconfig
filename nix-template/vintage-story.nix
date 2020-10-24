{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 42420 ];
  environment.systemPackages = with pkgs; [ mono ];
  users.users.vintagestory = {
    isNormalUser = true;
  };
}