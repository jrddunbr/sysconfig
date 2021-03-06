{ config, pkgs, ... }:
{
  imports =
    [
      /sysconfig/vars/hardware/eln01.nix
      /sysconfig/nix-template/base-system.nix
      /sysconfig/nix-template/eln-server.nix
      /sysconfig/nix-template/vintage-story.nix
      /sysconfig/nix-template/factorio.nix
      /sysconfig/nix-template/users.nix
    ];

  networking = {
    hostName = "eln01";
    defaultGateway = { address = "10.0.0.1"; interface = "net0"; };
    interfaces.net0.useDHCP = false;
    interfaces.net0.ipv4.addresses =
      [ { address = "10.0.0.30"; prefixLength = 24; } ];
    firewall.allowedTCPPorts = [ 22 ];
  };
}
