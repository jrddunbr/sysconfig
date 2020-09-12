{ config, pkgs, ... }:
{
  imports =
    [
      /sysconfig/vars/hardware/vmh01d.nix
      /sysconfig/nix-template/base-system.nix
      /sysconfig/nix-template/vm-host.nix
      /sysconfig/nix-template/users.nix
    ];

  networking = {
    hostName = "vmh01d";
    hostId = "8425e349";
    wireless.enable = false;
    useDHCP = false;

    defaultGateway = { address = "10.0.0.1"; interface = "br1"; };
    nameservers = [ "8.8.8.8" ];

    interfaces.ethernet0.useDHCP = false;
    interfaces.wifi0.useDHCP = false;
    interfaces.br1.ipv4.addresses =
      [ { address = "10.0.0.5"; prefixLength = 24; } ];

    bridges = {
      br1.interfaces = [ "ethernet0" ];
    };

    firewall.allowedTCPPorts = [ 22 ];
  };
}
