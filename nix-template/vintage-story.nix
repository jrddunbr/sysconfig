{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 42420 ];
  environment.systemPackages = with pkgs; [ mono sqlite ];
  users.users.vintagestory = {
    isNormalUser = true;
  };
}
