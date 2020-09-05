{ config, pkgs, ... }:
{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ];
  ec2.hvm = true;

  networking.hostName = "ohhires01v";

  environment.systemPackages = with pkgs; [
    wget vim htop python3
  ];

  security.sudo.wheelNeedsPassword = false;

  users.users.jared = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7MRJEMwHMb5H5kZz6ws8pEwu4uWu0UhFDZ77dEVlxU jared@jrd-ryzen" ];
  };
}
