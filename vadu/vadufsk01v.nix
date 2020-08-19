{ config, pkgs, ... }:
{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ];
  ec2.hvm = true;

  networking.hostName = "vadufsk01v";
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  environment.systemPackages = with pkgs; [
    wget vim htop python3
  ];

  security.sudo.wheelNeedsPassword = false;

  services.nginx.enable = true;
  services.nginx.virtualHosts.flask = {
    locations."/".proxyPass = "http://127.0.0.1:3000";
    serverName = "vadufsk01v.ja4.org";
  };

  users.users.jared = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7MRJEMwHMb5H5kZz6ws8pEwu4uWu0UhFDZ77dEVlxU jared@jrd-ryzen" ];
  };
  users.users.cameron = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbRWc8z3PaIuMPMPGKDHuDHUVqFYZ8ra6H8pdSQwYJS" ];
  };
}
