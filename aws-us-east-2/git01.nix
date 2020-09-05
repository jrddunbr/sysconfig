{ config, pkgs, ... }:
{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ];
  ec2.hvm = true;

  networking.hostName = "ohhigit01v";
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  environment.systemPackages = with pkgs; [
    wget vim htop python3
  ];

  security.sudo.wheelNeedsPassword = false;

  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
  services.mysql.bind = "127.0.0.1";
  services.mysql.ensureUsers = [
    {
      name = "gitea";
      ensurePermissions = {
        "gitea.*" = "ALL PRIVILEGES";
      };
    }
  ];
  services.mysql.ensureDatabases = [ "gitea" ];

  services.gitea.enable = true;
  services.gitea.database.type = "mysql";
  services.gitea.database.passwordFile = "/etc/gitea_pw";
  services.gitea.domain = "git.ja4.org";
  services.gitea.httpAddress = "127.0.0.1";
  services.gitea.disableRegistration = true;

  services.nginx.enable = true;
  services.nginx.virtualHosts.gitea.locations."/".proxyPass = "http://127.0.0.1:3000";
  services.nginx.virtualHosts.gitea.locations."/".proxyWebsockets = true;
  services.nginx.virtualHosts.gitea.serverName = "git.ja4.org";
  services.nginx.virtualHosts.gitea.forceSSL = true;
  services.nginx.virtualHosts.gitea.enableACME = true;

  security.acme.acceptTerms = true;
  security.acme.certs."git.ja4.org".email = "jrddunbr@gmail.com";

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
