{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/mmcblk0"; # or "nodev" for efi only
  boot.kernelParams = [ "console=ttyS0,115200" ];

  networking = {
    hostName = "rtr01pce";
    wireless.enable = false;
    useDHCP = false;

    nameservers = [ "8.8.8.8" ];

    interfaces.enp1s0.useDHCP = true;
    interfaces.enp2s0.useDHCP = false;
    interfaces.enp3s0.useDHCP = false;

    interfaces.br1.ipv4.addresses =
      [ { address = "10.0.0.1"; prefixLength = 24; } ];

    bridges = {
      br1.interfaces = [ "enp2s0" ];
    };

    nat.enable = true;
    nat.externalInterface = "enp1s0";
    nat.internalInterfaces = [ "br1" ];

    nat.forwardPorts = [
      #{ destination = "10.0.0.24"; proto = "tcp"; sourcePort = 42420; }
    ];

    firewall = {
      allowedTCPPorts = [ 22 80 443 9000 ];
      interfaces.br1.allowedTCPPorts = [ 22 8080 8443 8880 8843 6789 ];
      interfaces.br1.allowedUDPPorts = [ 3478 10001 ];
    };
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "br1" ];
    extraConfig = ''
      ddns-update-style none;

      subnet 10.0.0.0 netmask 255.255.255.0 {
        range 10.0.0.100 10.0.0.199;
        option subnet-mask 255.255.255.0;
        option routers 10.0.0.1;
        option domain-name-servers 8.8.8.8;
        authoritative;
      }
      '';
  };

  services.nginx = {
    enable = true;
    commonHttpConfig = ''
  ssl_prefer_server_ciphers on;
  # header crap
  add_header X-Frame-Options "SAMEORIGIN" always;
  add_header X-XSS-Protection "1; mode=block" always;
  add_header X-Content-Type-Options "nosniff" always;
  add_header Referrer-Policy "no-referrer" always;
  # erg.. fix this eventually.
  add_header Content-Security-Policy 'self' always;
'';
    virtualHosts = {
      irc_ja13_org = {
        serverName = "irc.ja13.org";
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000";
          proxyWebsockets = true;
        };
      };
    };
  };

  security.acme.acceptTerms = true;
  security.acme.certs = {
    "irc.ja13.org".email = "jrddunbr@gmail.com";
  };

  nixpkgs.config.allowUnfree = true;

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifiStable;
    openPorts = false; # Too unrestrictive
  };

  services.thelounge = {
    enable = true;
    private = true;
  };

  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    wget vim htop python3 certbot git
  ];

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  users.motd = "
 _  o | _|_
 /_ | |  |_ \/
            /";

  users.users.jared = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7MRJEMwHMb5H5kZz6ws8pEwu4uWu0UhFDZ77dEVlxU jared@jrd-ryzen" ];
  };

  system.stateVersion = "20.03";
}
