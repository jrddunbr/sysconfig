{ config, pkgs, ... }:
{
  networking = {
    wireless.enable = false;
    useDHCP = false;
    nameservers = [ "8.8.8.8" ];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget vim htop git
  ];

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "America/New_York";

  system.stateVersion = "20.03";
}
