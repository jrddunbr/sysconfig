{ config, pkgs, ... }:

# NOTICE!
#
# nyhjrtr04p.ja4.org is scheduled to be DECOMMISSIONED on August 13th, 2020
# The physical hardware will be relocated and configured with
#    varsrtr01p.ja4.org's config hopefully no later than August 16th, 2020.
#
# This also means that nyhj.ja4.org will be decommissioned,
#   and vars.ja4.org will be created, with the same timeline.

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/mmcblk0";
  boot.kernelParams = [ "console=ttyS0,115200" ];

  networking = {
    hostName = "nyhjrtr04p";
    wireless.enable = false;
    useDHCP = false;

    nameservers = [ "8.8.8.8" ];

    interfaces.enp1s0.useDHCP = true;
    interfaces.enp2s0.useDHCP = false;
    interfaces.enp3s0.useDHCP = false;

    interfaces.br1.ipv4.addresses =
      [ { address = "10.0.0.1"; prefixLength = 24; } ];
    interfaces.br4_vzw.ipv4.addresses =
      [ { address = "10.4.0.1"; prefixLength = 24; } ];
    interfaces.br5_dhcp.ipv4.addresses =
      [ { address = "10.5.0.1"; prefixLength = 24; } ];
    interfaces.br8_servers.ipv4.addresses =
      [ { address = "10.8.0.1"; prefixLength = 24; } ];

    vlans = {
      v4_vzw = {
        id = 4;
        interface = "br1";
      };
      v5_dhcp = {
        id = 5;
        interface = "br1";
      };
      v8_servers = {
        id = 8;
        interface = "br1";
      };
    };

    bridges = {
      br1.interfaces = [ "enp2s0" ];
      br4_vzw.interfaces = [ "v4_vzw" ];
      br5_dhcp.interfaces = [ "v5_dhcp" ];
      br8_servers.interfaces = [ "v8_servers" ];
    };

    nat.enable = true;
    nat.externalInterface = "enp1s0";
    nat.internalInterfaces = [ "br1" "br4_vzw" "br5_dhcp" "br8_servers" ];

    nat.forwardPorts = [
      # Minecraft
      { destination = "10.0.0.10"; proto = "tcp"; sourcePort = 25565; }
      # Vintage Story
      { destination = "10.0.0.10"; proto = "tcp"; sourcePort = 42424; }
      # Xonotic
      { destination = "10.0.0.10"; proto = "udp"; sourcePort = 26000; }
      # NixOS VM Host
      { destination = "10.0.0.9"; proto = "tcp"; sourcePort = 13699; }
      # Factorio
      { destination = "10.0.0.10"; proto = "udp"; sourcePort = 34197; }
      # FreeCiv
      { destination = "10.0.0.10"; proto = "tcp"; sourcePort = 5556; }
    ];

  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "br1" "br4_vzw" "br5_dhcp" ];
    extraConfig = ''
      ddns-update-style none;

      subnet 10.0.0.0 netmask 255.255.255.0 {
        range 10.0.0.100 10.0.0.199;
        option subnet-mask 255.255.255.0;
        option routers 10.0.0.1;
        option domain-name-servers 8.8.8.8;
        authoritative;
      }

      subnet 10.4.0.0 netmask 255.255.255.0 {
        range 10.4.0.100 10.4.0.199;
        option subnet-mask 255.255.255.0;
        option routers 10.4.0.1;
        option domain-name-servers 8.8.8.8;
        authoritative;
      }

      subnet 10.5.0.0 netmask 255.255.255.0 {
        range 10.5.0.100 10.5.0.199;
        option subnet-mask 255.255.255.0;
        option routers 10.5.0.1;
        option domain-name-servers 8.8.8.8;
        authoritative;
      }
      '';
  };

  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    wget vim htop python3 bind tcpdump
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

  users.users.thajohns = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV2/9Hg0BVvUXsMDWpgZEo1KPLUOGjnP9G+U90UPOlX primary@tj" ];
  };

  system.stateVersion = "19.09";

}