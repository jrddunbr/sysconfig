# sysconfig

A set of configuration files and basic systems documentation for systems I maintain.

## Locations

* [`ctha`](ctha/README.md) - DNET Location
* [`nyhj`](nyhj/README.md) - Eagle's Nest
* [`vars`](vars/README.md) - VARS - Note: Not commissioning before Aug 14, 2020
* [`vadu`](vadu/README.md) - us-east-1 (aws)
* [`ohhi`](ohhi/README.md) - us-east-2 (aws)

## Hostname Decoding

There are two styles of hostnames - location alias codes and hostnames.

* The location alias codes are for a particular location router, they are the four letter location code, followed by the TLD.
* The regular hostnames are all as follows:
    * `[location code][purpose code][number][device type]`

All the hostnames are on top of the infrastructure TLD, `ja4.org`.

### Location Code

4 character location code (generally, 2 letters of state and 2 letters of city), only letters `a-z`

* `ctha` - DNET
* `nyhj` - Eagle's Nest
* `vars` - VARS

### Purpose Code

3 character purpose code (service), only letters `a-z`

* Network Infrastructure:
    * `rtr` - Router
    * `mtr` - Modem Router Combo (ick!)
    * `otn` - Fiber POP Box
    * `mdm` - Cable Modem
    * `msw` - Managed Switch
    * `usw` - Unmanaged Switch
    * `ufw` - Unifi WiFi Dish
    * `vct` - Verizon Cell Tower
* General computing devices:
    * `gln` - General Linux System
    * `rch` - Arch Linux
    * `gwn` - General Windows System
    * `win` - Windows 10
* Purpose Built Machines:
    * `vmh` - VM Host
    * `cth` - Container Host
    * `eln` - Probably related to [eln2](https://eln2.org)
    * `git` - Git Server (likely Gitea)
    * `web` - Web Server (of some kind)

### Device Type

Only letters `a-z`

* `a` - ARM System
* `c` - Cisco
* `d` - Desktop
* `f` - Media Converter (for fiber)
* `l` - Laptop
* `m` - MicroTik
* `n` - Stands for "Not Worthy" (but works). Typically, some consumer-y device.
* `o` - Other
* `p` - PC Engines APU
* `r` - Raspberry Pi
* `s` - Server
* `t` - TP-Link
* `u` - Ubiquiti
* `v` - Virtual Machine/Container

### Examples:

`cthartr01p` - Router located at DNET, it's the 1st router iteration, and it's a PC Engines device (apu3c4).

## Generating DOT files on Linux

```shell script
dot -Tpng network.dot -o network.png
```

## Generating DOT files from Git Bash

```shell script
/c/Program\ Files\ \(x86\)/Graphviz2.38/bin/dot.exe -Tpng network.dot -o network.png
```

*You're welcome*.
