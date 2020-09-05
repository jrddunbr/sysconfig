# ctha.ja4.org (DNET)

## Network Topology

![Network Topology](network.png)

| Hostname | IP | Description |
| --- | --- | --- |
| `mdm01c` | `192.168.100.1` | Cisco DPC3216 |
| `rtr01pce` | `10.1` | PC Engines APU 2c4 |
| `msw01tp` | Unknown | TP Link TL-SG105E |
| `wifi01u` | DHCP | Unifi WiFi AC LR |

## Configurations

* cthartr01p
    * [Router Config](rtr01pce.nix)
    * [Hardware Config](rtr01pce.hardware-configuration.nix)