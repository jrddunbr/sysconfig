# sysconfig

A set of configuration files and basic systems documentation

## Locations

* [`ctha`](ctha/README.md) - DNET Location
* [`nyhj`](nyhj/README.md) - Eagle's Nest - **NOTICE** - Soon to be decommissioned Aug 13, 2020
* [`vars`](vars/README.md) - VARS - Note: Not commissioning before Aug 14, 2020
* [`ohhi`](ohhi/README.md) - AWS us-east-2

## Hostname Decoding

There are two styles of hostnames - location alias codes and hostnames.

* The location alias codes are for a particular location router, they are the four letter location code, followed by the TLD.
* The regular hostnames are all as follows:
    * `[location code][purpose code][number][device type]`

All the hostnames are on top of the infrastructure TLD, `ja4.org`.

### Location Code

4 character location code (generally, 2 letters of state and 2 letters of city)

* `ctha` - DNET
* `nyhj` - Eagle's Nest
* `vars` - VARS

### Purpose Code

3 character purpose code (service)

* Network Infrastructure:
    * `rtr` - Router
    * `msw` - Managed Switch
    * `usw` - Unmanaged Switch
    * `ufw` - Unifi WiFi Dish
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

### Device Type

* `p` - PC Engines APU
* `s` - Server
* `d` - Desktop
* `l` - Laptop
* `t` - TP-Link
* `u` - Ubiquiti
* `v` - Virtual Machine/Container
* `f` - Media Converter (for fiber)

### Examples:

`nyhjrtr04p` - Router located at Eagle's Nest, it's the 4th router iteration and it's a PC Engines device (apu3c4).

## Generating DOT files from Git Bash

```shell script
/c/Program\ Files\ \(x86\)/Graphviz2.38/bin/dot.exe -Tpng network.dot -o network.png
```

*You're welcome*.