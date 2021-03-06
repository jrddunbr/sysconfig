{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 42420 ];
  environment.systemPackages = with pkgs; [ mono sqlite.out ];
  users.users.vintagestory = {
    isNormalUser = true;
  };
}
