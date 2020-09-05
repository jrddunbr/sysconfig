{ config, pkgs, ... }:
{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ];
  ec2.hvm = true;

  networking = {
    firewall.allowedUDPPorts = [ 51820 ];
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.0.20.1/24" ];
        listenPort = 51820;
        privateKeyFile = "/var/wg/wg.private";

        peers = [
          {
            publicKey = "OvwcAkH9MSJAngAwZvhyEUVN3laRO5FFOxowi5Va1Dw=";
            allowedIPs = [ "10.0.20.0/24" ];
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wget vim htop git
  ];

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  users.users.jared = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7MRJEMwHMb5H5kZz6ws8pEwu4uWu0UhFDZ77dEVlxU jared@jrd-ryzen" ];
  };

  users.users.cameron = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbRWc8z3PaIuMPMPGKDHuDHUVqFYZ8ra6H8pdSQwYJS" ];
  };
}
