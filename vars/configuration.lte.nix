{ config, pkgs, ... }:

# NOTICE!
#
# varsrtr01p.ja4.org will not be commissioned until August 14th, 2020
#   at the earliest, and hopefully no later than August 16th, 2020

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
    hostName = "varsrtr01p";
    wireless.enable = false;
    useDHCP = false;

    nameservers = [ "8.8.8.8" ];

	interfaces.enp0s16u2.useDHCP = true;
    interfaces.enp1s0.useDHCP = false;
    interfaces.enp2s0.useDHCP = false;
    interfaces.enp3s0.useDHCP = false;

    interfaces.br1.ipv4.addresses =
      [ { address = "10.0.0.1"; prefixLength = 24; } ];
    interfaces.br2_dhcp.ipv4.addresses =
      [ { address = "10.0.2.1"; prefixLength = 24; } ];
    interfaces.br3_servers.ipv4.addresses =
      [ { address = "10.0.3.1"; prefixLength = 24; } ];

    vlans = {
      v2_dhcp = {
        id = 2;
        interface = "br1";
      };
      v3_servers = {
        id = 3;
        interface = "br1";
      };
    };

    bridges = {
      br1.interfaces = [ "enp0s16u2" ];
      br2_dhcp.interfaces = [ "v2_dhcp" ];
      br3_servers.interfaces = [ "v3_servers" ];
    };

    nat.enable = true;
    nat.externalInterface = "enp0s16u2";
    nat.internalInterfaces = [ "br1" "br2_dhcp" "br3_servers" ];

    nat.forwardPorts = [
      # Minecraft
      #{ destination = "10.0.0.10"; proto = "tcp"; sourcePort = 25565; }
      # Vintage Story
      #{ destination = "10.0.0.10"; proto = "tcp"; sourcePort = 42424; }
      # Xonotic
      #{ destination = "10.0.0.10"; proto = "udp"; sourcePort = 26000; }
      # Factorio
      #{ destination = "10.0.0.10"; proto = "udp"; sourcePort = 34197; }
    ];

  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "br1" "br2_dhcp" ];
    extraConfig = ''
      ddns-update-style none;

      subnet 10.0.0.0 netmask 255.255.255.0 {
        range 10.0.0.100 10.0.0.199;
        option subnet-mask 255.255.255.0;
        option routers 10.0.0.1;
        option domain-name-servers 8.8.8.8;
        authoritative;
      }

      subnet 10.0.2.0 netmask 255.255.255.0 {
        range 10.4.0.100 10.4.0.199;
        option subnet-mask 255.255.255.0;
        option routers 10.4.0.1;
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

  system.stateVersion = "20.03";
}