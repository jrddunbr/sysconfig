#!/usr/bin/python3

# Created by Jared Dunbar
# All rights reserved (for now)

# This file provides functions to manipulate hostnames and collect useful information about a host just by the hostname.
# It can handle the legacy format as well as the new format

import string

REGION_NYHJ = "nyhj"
DEFAULT_DOMAIN = "ja4.org"
DEFAULT_REGION = "vars"
HOME_PROVIDER = "home"
LAB_PROVIDER = "lab"

def hostname_information(hostname):
    # Split the hostname out
    full_name = hostname.lower().strip().split(".")

    # If there's no text, nope.
    if full_name[0].strip() == "":
        return None

    # Legacy Hostname Decoder
    if full_name[0][0:4] == REGION_NYHJ:
        region = REGION_NYHJ
        purpose = translate_legacy_purpose_code(full_name[0][4:7])
        identifier = full_name[0][7:9]
        hardware_type = translate_legacy_hardware_code(full_name[0][9])
        return purpose, identifier, hardware_type, region, DEFAULT_DOMAIN

    # Standard Hostname. We want at least the first two parts, can guess the rest.
    parts = len(full_name)

    # We assume don't know the region nor the domain and fill em in if we have em.
    region = DEFAULT_REGION
    domain = DEFAULT_DOMAIN
    # We don't know the domain
    if parts == 2 or parts == 3:
        region = full_name[1]
    # We know all
    if parts == 4:
        region = full_name[1]
        domain = "{}.{}".format(full_name[2], full_name[3])

    hardware_type = ""
    hardware_type_offset = 0
    if full_name[0][-1] not in string.ascii_letters:
        # Hardware type omitted, assuming Virtual Machine (v)
        hardware_type = "v"
        # Identifier is at the end
        identifier = full_name[0][-2:]
    else:
        # Locate the hardware type string end by reversing up it to the identifier number
        for x in full_name[0][::-1]:
            if x not in string.ascii_letters:
                break
            hardware_type = x + hardware_type
        hardware_type_offset = len(hardware_type)
        # Identifier is found based on the hardware type length
        identifier = full_name[0][-(hardware_type_offset + 2):-hardware_type_offset]

    # Purpose is whatever is left of the identifier
    purpose = full_name[0][:-(hardware_type_offset + 2)]

    return purpose, identifier, hardware_type, region, domain


def build_hostname_tuple(data):
    size = len(data)
    if size == 4:
        return build_hostname(data[0], data[1], data[2], data[3])
    if size == 5:
        return build_hostname(data[0], data[1], data[2], data[3], data[4])
    return None


def build_hostname(purpose, identity, hardware_type, region, domain=DEFAULT_DOMAIN):
    # Condensed VM type
    if hardware_type == "v":
        return "{}{}.{}.{}".format(purpose, identity, region, domain)
    # Not a VM
    return "{}{}{}.{}.{}".format(purpose, identity, hardware_type, region, domain)


def translate_legacy_purpose_code(purpose_code):
    if purpose_code == "ufw":
        return "wifi"
    if purpose_code == "vct":
        return "cell"
    # Catch all for the other purpose codes that have not changed (rtr, mdm, msw)
    return purpose_code


def translate_legacy_hardware_code(hardware_code):
    if hardware_code == "f":
        return "fc"
    if hardware_code == "n":
        return "nw"
    if hardware_code == "t":
        return "tpl"
    # Catch all for the other hardware codes that have not changed (o, u)
    return hardware_code


# Returns fancy region name, provider name
def fancy_region(region):

    # Home/lab locations
    if region == "vars":
        return "VARS", HOME_PROVIDER
    if region == "nyhj":
        return "Eagle's Nest", HOME_PROVIDER
    if region == "ctha":
        return "DNET", HOME_PROVIDER
    if region == "nypd":
        return "NYPD", LAB_PROVIDER

    # Cloud service providers
    if "-" not in region:
        return region

    provider, region_name = region.split("-", 1)
    # Nitpick, capitalize AWS.
    if provider == "aws":
        provider = "AWS"
    else:
        provider = provider.capitalize()
    return region_name, provider


# Returns the device fancy purpose name
def fancy_purpose(purpose):

    # Network Infrastructure
    if purpose == "rtr":
        return "Router"
    if purpose == "mdmrtr":
        return "Modem-Router"
    if purpose == "otn":
        return "Fiber OTN"
    if purpose == "mdm":
        return "Modem"
    if purpose == "msw":
        return "Managed Ethernet Switch"
    if purpose == "sw":
        return "Unmanaged Ethernet Switch"
    if purpose == "wifi":
        return "WiFi Access Point"
    if purpose == "cell":
        return "Cell Tower"

    # General computing devices
    if purpose == "linux":
        return "Linux System"
    if purpose == "arch":
        return "Arch Linux System"
    if purpose == "win":
        return "Microsoft Windows System"
    if purpose == "nixos":
        return "NixOS System"

    # Purpose built services
    if purpose == "vmh":
        return "Virtual Machine Host"
    if purpose == "eln":
        return "Electrical Age Server"
    if purpose == "web":
        return "Web Server"
    if purpose == "git":
        return "Git Server"
    if purpose == "resume":
        return "Resume Build Server"


# Return fancy device name or vendor
def fancy_device(device):
    if device == "arm":
        return "ARM Hardware"
    if device == "cis":
        return "Cisco"
    if device == "d":
        return "Desktop"
    if device == "mc":
        return "Media Converter"
    if device == "l":
        return "Laptop"
    if device == "mt":
        return "MicroTik"
    if device == "nw":
        return "Other Consumer-y Device"
    if device == "o":
        return "Other Device"
    if device == "pce":
        return "PC Engines"
    if device == "rpi":
        return "Raspberry Pi"
    if device == "s":
        return "Server"
    if device == "tpl":
        return "TP Link"
    if device == "u":
        return "Ubiquiti Networks"
    if device == "v":
        return "Virtual Machine"


def detailed_host_information(hostname):
    purpose, identifier, hardware_type, region, domain = hostname_information(hostname)
    fqdn = build_hostname(purpose, identifier, hardware_type, region, domain)
    region_name, provider = fancy_region(region)
    print("{} is a {} {} located in the {} region named {}"
          .format(fqdn, fancy_device(hardware_type), fancy_purpose(purpose), provider, region_name))


def fancy_aws_region(aws_region):

    # Americas
    if aws_region == "us-east-1":
        return aws_region, "North Virginia, USA"
    if aws_region == "us-east-2":
        return aws_region, "Ohio, USA"
    if aws_region == "us-west-1":
        return aws_region, "North California, USA"
    if aws_region == "us-west-2":
        return aws_region, "Oregon, USA"
    if aws_region == "ca-central-1":
        return aws_region, "Central Canada"
    if aws_region == "us-gov-east-1":
        return aws_region, "US Govcloud East"
    if aws_region == "us-gov-west-1":
        return aws_region, "US Govcloud West"
    if aws_region == "sa-east-1":
        return aws_region, "São Paulo, Brazil"

    # Africa
    if aws_region == "af-south-1":
        return aws_region, "Cape Town, South Africa"

    # Asia
    if aws_region == "ap-east-1":
        return aws_region, "Hong Kong"
    if aws_region == "ap-south-1":
        return aws_region, "Mumbai, India"
    if aws_region == "ap-northeast-2":
        return aws_region, "Seoul, South Korea"
    if aws_region == "ap-southeast-1":
        return aws_region, "Singapore"
    if aws_region == "ap-southeast-2":
        return aws_region, "Sydney, Australia"
    if aws_region == "ap-northeast-1":
        return aws_region, "Tokyo, Japan"

    # Europe
    if aws_region == "eu-central-1":
        return aws_region, "Frankfurt, Germany"
    if aws_region == "eu-west-1":
        return aws_region, "Ireland"
    if aws_region == "eu-west-2":
        return aws_region, "London, England"
    if aws_region == "eu-south-1":
        return aws_region, "Milan, Italy"
    if aws_region == "eu-west-3":
        return aws_region, "Paris, France"
    if aws_region == "eu-north-1":
        return aws_region, "Stockholm, Sweden"

    # Middle East
    if aws_region == "me-south-1":
        return aws_region, "Bahrain"

def tests():
    print("Empty Hostname Test:")
    print(hostname_information(""))

    print("Some missing info test:")
    print(hostname_information("rtr01pce"))
    print(hostname_information("rtr01pce.vars"))
    print(hostname_information("rtr01pce.vars.ja4"))

    print("Basic router test:")
    nn = hostname_information("rtr01pce.vars.ja4.org")
    print(nn)
    print(build_hostname_tuple(nn))
    print(fancy_region(nn[3]))
    print(fancy_purpose(nn[0]))
    print(detailed_host_information("rtr01pce.vars.ja4.org"))

    print("Basic VM test (with v)")
    n2 = hostname_information("git01v.aws-us-east-1.ja4.org")
    print(n2)
    print(detailed_host_information("git01v.aws-us-east-1.ja4.org"))
    print("Basic VM test (without v)")
    n3 = hostname_information("git01.aws-us-east-1.ja4.org")
    print(n3)
    print(build_hostname_tuple(n2))
    print(build_hostname_tuple(n3))
    print("Basic VM region data:")
    print(fancy_region(n2[3]))

    print("Legacy Region test:")
    lhn = hostname_information("nyhjrtr05n.ja4.org")
    print(lhn)
    print(build_hostname_tuple(lhn))

    print("Other region tests:")
    print(detailed_host_information("web31v.google-us-east4.ja4.org"))
    print(detailed_host_information("nixos20v.azure-northcentralus.ja4.org"))


def get_files(folder_path):
    from os import listdir
    from os.path import isfile, join
    return [join(folder_path, f) for f in listdir(folder_path) if isfile(join(folder_path, f))]


def get_folders(folder_path):
    from os import listdir
    from os.path import isdir, join
    return [f for f in listdir(folder_path) if isdir(join(folder_path, f))]


def give_strings(data):
    strings = []
    build = ""
    for i in range(0, len(data)):
        if (data[i] in (string.ascii_letters + string.digits)):
            build += data[i]
        else:
            strings.append(build)
            build = ""
    strings.append(build)
    return [x for x in list(set([x for x in strings if x != ""])) if len([y for y in x if y in string.digits]) >= 2]


def hostname_report():
    from os import listdir
    from os.path import isfile, join
    path = "/sysconfig"
    dotfiles = []
    dotfolders = get_folders(path)
    for folder in dotfolders:
        dotfiles += [x for x in get_files(path + "/" + folder) if "." in x and x.rsplit(".",1)[1].strip() == "dot"]

    hostname_list = []

    for file in dotfiles:
        f = open(file, "r")
        data = f.read()
        f.close()
        hostname_list += give_strings(data)


    purpose_list = []
    hardware_type_list = []
    for host in hostname_list:
        purpose, _, hardware_type, _, _ = hostname_information(host)
        if purpose not in purpose_list:
            purpose_list.append(purpose)
        if hardware_type not in hardware_type_list:
            hardware_type_list.append(hardware_type)

    purpose_list.sort()
    hardware_type_list.sort()

    print(purpose_list)
    print(hardware_type_list)


#tests()
hostname_report()
