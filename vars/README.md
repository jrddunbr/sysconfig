# vars.ja4.org (VARS)

## Network Topology

![Network Topology](network.png)

| hostname | IP | Details |
| --- | --- |--- |
| `rtr01pce` | `10.1` | PC Engines Router (apu 3c4) |
| `msw01tp` | `10.2` | TP Link T2500G-10TS |
| `wifi01u` | DHCP | Unifi Wifi AC LR |
| `vmh01d` | `10.5`  | VM Host |
| `arch01d`, `win01d` | DHCP | Desktop |
| `print01hp` | DHCP | HP Officejet 9015 |
| `nest01go` | DHCP | Nest Thermostat |
| `alexa01az` | DHCP | Alexa |

## Configurations

* `rtr01pce`:
    * [Router Config](rtr01pce.nix)
    * [Hardware Config](rtr01pce.hardware-configuration.nix)

* `vmh01d`:
    * [VM Host Config](vmh01d.nix)
    * [Hardware Config](vmh01d.hardware-configuration.nix)