{ config, pkgs, ... }:

{
  imports =
    [
      /sysconfig/vars/hardware/rtr01pce.nix
      /sysconfig/nix-template/base-system.nix
      /sysconfig/nix-template/unifi.nix
      /sysconfig/nix-template/users.nix
    ];

  networking = {
    hostName = "rtr01pce";

    interfaces.ethernet0.useDHCP = true;
    interfaces.ethernet1.useDHCP = false;
    interfaces.ethernet2.useDHCP = false;

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
      br1.interfaces = [ "ethernet1" ];
      br2_dhcp.interfaces = [ "v2_dhcp" ];
      br3_servers.interfaces = [ "v3_servers" ];
    };

    nat.enable = true;
    nat.externalInterface = "ethernet0";
    nat.internalInterfaces = [ "br1" "br2_dhcp" "br3_servers" ];

    firewall.allowedTCPPorts = [
      22 # External SSH
     ];

    firewall.interfaces.br1.allowedTCPPorts = [
      8080 8443 8880 8843 6789 27117 # Unifi Controller
    ];
    firewall.interfaces.br1.allowedUDPPorts = [
      3478 5514 10001 1900 # Unifi Controller
    ];

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
        range 10.0.2.100 10.0.2.199;
        option subnet-mask 255.255.255.0;
        option routers 10.2.0.1;
        option domain-name-servers 8.8.8.8;
        authoritative;
      }
      '';
  };
}
