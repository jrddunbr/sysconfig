{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "vmh01d";
    hostId = "8425e349";
    wireless.enable = false;
    useDHCP = false;

    defaultGateway = { address = "10.0.0.1"; interface = "br1"; };
    nameservers = [ "8.8.8.8" ];

    interfaces.enp7s0.useDHCP = false;
    interfaces.wlp1s0.useDHCP = false;
    interfaces.br1.ipv4.addresses =
      [ { address = "10.0.0.5"; prefixLength = 24; } ];

    bridges = {
      br1.interfaces = [ "enp7s0" ];
    };

    firewall.allowedTCPPorts = [ 22 ];
  };

  environment.systemPackages = with pkgs; [
    wget vim htop git
  ];

  services.openssh.enable = true;

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
