# nix-template

Here you will find generic templates that can be imported in NixOS configs.

## base-system.nix

Includes everything needed for a base system.

## unifi.nix

Includes the Unifi WiFi controller software (firewall rules intentionally not included).

Example firewall rules:

```nix
networking.firewall.interfaces.br1.allowedTCPPorts = [
  8080 8443 8880 8843 6789 27117
];
networking.firewall.interfaces.br1.allowedUDPPorts = [
  3478 5514 10001 1900
];
```

## users.nix

Includes SSH keys and user information and permissions.