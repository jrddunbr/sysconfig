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
    interfaces.br4_work.ipv4.addresses =
      [ { address = "10.0.4.1"; prefixLength = 24; } ];

    vlans = {
      v2_dhcp = {
        id = 2;
        interface = "br1";
      };
      v3_servers = {
        id = 3;
        interface = "br1";
      };
      v4_work = {
        id = 4;
        interface = "br1";
      };
    };

    bridges = {
      br1.interfaces = [ "ethernet1" ];
      br2_dhcp.interfaces = [ "v2_dhcp" ];
      br3_servers.interfaces = [ "v3_servers" ];
      br4_work.interfaces = ["v4_work"];
    };

    nat.enable = true;
    nat.externalInterface = "ethernet0";
    nat.internalInterfaces = [ "br1" "br2_dhcp" "br3_servers" "br4_work"];

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
      { destination = "10.0.0.30"; proto = "tcp"; sourcePort = 25565; }
    ];
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "br1" "br2_dhcp" "br4_work"];
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
        option routers 10.0.2.1;
        option domain-name-servers 8.8.8.8;
        authoritative;
      }

      subnet 10.0.4.0 netmask 255.255.255.0 {
        range 10.0.4.100 10.0.4.199;
        option subnet-mask 255.255.255.0;
        option routers 10.0.4.1;
        option domain-name-servers 8.8.8.8;
        authoritative;
      }

      host arch01d {
        hardware ethernet b4:2e:99:a3:eb:7e;
        fixed-address 10.0.0.10;
      }

      host wifi01u {
        hardware ethernet e0:63:da:30:cd:77;
        fixed-address 10.0.0.3;
      }

      host printer01hp {
        hardware ethernet b0:5c:da:fa:2e:25;
        fixed-address 10.0.2.20;
      }

      host alexa01az {
        hardware ethernet 0c:ee:99:21:74:69;
        fixed-address 10.0.2.21;
      }

      host nest01go {
        hardware ethernet 64:16:66:1f:aa:5d;
        fixed-address 10.0.2.22;
      }
      '';
  };
}
