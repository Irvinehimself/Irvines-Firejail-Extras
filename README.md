# The Beggars Hardening Project

## Overview
My current long term project is to experiment with building a high-security Os using [Arch Linux](https://www.archlinux.org). Apart from a commercial Vpn, disk encryption ... etc, the project basically consists of the following parts:
1. My [apparmor enabled version](https://aur.archlinux.org/packages/firejail-apparmor/) of Firejail
1. Use my `firejail-apparmor` package to sandbox **ALL** top level applications
1. My [apparmor enabled version](https://aur.archlinux.org/pkgbase/linux-hardened-apparmor/)  of the linux-hardened kernel
1. Write restrictive Apparmor profiles for sensitive low level daemons. eg `NetworkManager`, `openvpn`, `wpa-supplicant`, `gvfsd`, `udisks2`, `tumblerd`, .... etc
1. Write tools for Firejail and AppArmor to help manage the enviroment.
1. Write other tools and packages as needed to generally increase the overall security of the environment

*Note:* Even though I am using Arch Linux, most of what I am doing is very usable/applicable by other Linux distros.

I have split things up into the following sections
* [Firejail profiles and local customisations](Firejail)
* [Tools to manage Firejail profiles](FjTools)
* [Apparmor profiles for daemons and low level utilites](AppArmor)
* [Tools to help manage and write Apparmor profiles](ApTools)
* [Anti-virus tools](AvTools)
* [Security and monitoring tools](HsTools)
* [Simple update scheduler](UpdateScheduler)

For your convenience, each section has it's own *readme* with the important details
