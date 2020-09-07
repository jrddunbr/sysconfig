# sysconfig

A set of configuration files and basic systems' documentation, for systems I maintain.

The license is MIT across most (Nix) files. 
Proper (python) source code is currently All Rights Reserved, for now (as noted at the top of relevant files).

## Table of Contents

* [Locations](README.md#locations)
* [Hostname Decoding](README.md#hostname-decoding)
    * [Location Jumps](README.md#location-jumps)
    * [Host Decoding](README.md#host-decoding)
    * [Legacy Host Decoding](README.md#legacy-hostname-decoding)
        * [Legacy Location Code](README.md#legacy-location-code)
        * [Legacy Purpose Code](README.md#legacy-purpose-code)
        * [Legacy Device Type](README.md#legacy-device-type)
* [Generating Dot files on Linux](README.md#generating-dot-files-on-linux)
* [Generating Dot files from Git Bash](README.md#generating-dot-files-from-git-bash)

## Locations

* [`ctha`](ctha/README.md) - DNET
* [`nyhj`](nyhj/README.md) - Eagle's Nest
* [`vars`](vars/README.md) - VARS
* [`aws-us-east-1`](aws-us-east-1/README.md) - us-east-1 (aws)
* [`aws-us-east-2`](aws-us-east-2/README.md) - us-east-2 (aws)

## Hostname Decoding

There are three kinds of hostnames - proper hostnames, location jumps, and legacy hostnames.

### Location Jumps

A location jump is used to jump from one server to another within a logical region.

The format is a location domain directly off the subdomain.

A location can be defined as something like `vars.ja4.org` or `aws-us-east-1.ja4.org`.

A location jump generally just uses the location code, but in some cases, a DNS record may be created called `jump`.

For instance, if a server fronts a website, but you have to jump somewhere else, `jump.<location.ja4.org` will get there.

### Host Decoding

The hostname is made up of 5 parts:

* Purpose code, a 2 or more character code that defines precisely the server's purpose
* Identity code, a 2 digit number
* Hardware Type code, an optional 0-3 character code
    * If omitted, the type code is actually a compressed form of `v`
* Region, a basic string that is unique to the location
* Domain, the infrastructure domain (`ja4.org`)

Examples of possible domains:

* `nix01v.vars.ja4.org`
* `git01.aws-us-east-1.ja4.org`
* `rtr02d.ctha.ja4.org`

#### Regions

Regions have generally two formats - a 2 character state and city, or, a cloud company followed by their region name.

Home examples:

* `ctha`
* `nyhj`
* `vars`

Cloud examples:

* `aws-us-east-1`
* `aws-us-east-2`
* `aws-us-west-2`
* `google-us-east1`
* `azure-eastus`

#### Purpose Codes

Purpose codes can be two or more alphanumeric characters.

* Network Infrastructure:
    * `rtr` - Router
    * `mdmrtr` - Modem Router Combo (ick!)
    * `otn` - Fiber POP Box
    * `mdm` - Cable Modem
    * `msw` - Managed Switch
    * `sw` - Unmanaged Switch
    * `wifi` - WiFi Dish
    * `cell` - Cell Tower
* General computing devices:
    * `linux` - General Linux System
    * `arch` - Arch Linux
    * `win` - MS Windows
    * `nixos` - NixOS
* Purpose Built Machines:
    * `vmh` - VM Host (Can also have containers)
    * `eln` - Probably related to [eln2](https://eln2.org)
    * `git` - Git Server (likely Gitea)
    * `web` - Web Server (of some kind)
    * `resume` - For my resume and CV, of course
    
#### Device Types

0-3 characters from `a-z` , with the field omitted meaning `v`.

* `arm` - ARM System
* `cis` - Cisco
* `d` - Desktop
* `mc` - Media Converter (for fiber)
* `l` - Laptop
* `mt` - MicroTik
* `nw` - Stands for "Not Worthy" (but works). Typically, some consumer-y device.
* `o` - Other
* `pce` - PC Engines APU
* `rpi` - Raspberry Pi
* `s` - Server
* `tpl` - TP-Link
* `u` - Ubiquiti
* `v` - Virtual Machine/Container

### Legacy Hostname Decoding

Legacy hostnames are only left because they are physically labeled with stickers at `nyhj`. This will hopefully be remediated in November 2020.

* The regular hostnames are all as follows:
    * `[location code][purpose code][number][device type]`

#### Legacy Location Code

* `nyhj` - Eagle's Nest

#### Legacy Purpose Code

* Network Infrastructure:
    * `rtr` - Router (one at `nyhj`)
    * `mdm` - Cable Modem (one at `nyhj`)
    * `msw` - Managed Switch (one at `nyhj`)
    * `ufw` - Unifi WiFi Dish (two at `nyhj`)
    * `vct` - Verizon Cell Tower (one at `nyhj`)

#### Legacy Device Type

Only letters `a-z`

* `f` - Media Converter (for fiber)
* `n` - Stands for "Not Worthy" (but works). Typically, some consumer-y device.
* `o` - Other
* `t` - TP-Link
* `u` - Ubiquiti

## Generating DOT files on Linux

```shell script
dot -Tpng network.dot -o network.png
```

## Generating DOT files from Git Bash

```shell script
/c/Program\ Files\ \(x86\)/Graphviz2.38/bin/dot.exe -Tpng network.dot -o network.png
```

*You're welcome*.
