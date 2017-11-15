# Irvines-Firejail-Extras
Extra profiles, local customisations and tools for Firejail

#### Introduction
Inspired by recent security threats and the new [SubGraph OS](https://subgraph.com/), my current long term project is to experiment with building a high-security Os using [Arch Linux](https://www.archlinux.org)

Apart from a commercial Vpn, disk encryption ... etc, the project basically consists of two parts:
1. **Use Firejail to sandbox everything!!!**
1. My apparmor enabled linux-hardened [kernel](https://aur.archlinux.org/pkgbase/linux-hardened-apparmor/)

It is the first item on the list that this GitHub project is concerned with.

#### Profiles
Mainly, I intend to post any Firejail profiles I have written, along with my local customisations of upstream profiles. Several of these profiles have already been accepted for inclusion upstream, while others have not yet been submitted. You can tell which is which by the following comment:
* \# This file is overwritten after every install/update
* \# This profile will be automatically replaced when an upstream profile becomes available.

#### Local customisations
Currently, most of my local customisations are concerned with globally enabling apparmor confinement and/or disabling internet connectivity. However, I have recently started work on strengthening internet connected profiles. 

At the time of writing, the following `.local` files have potentially useful customisations which strengthen their respective upstream profiles:
1. inox.local
1. firefox.local
1. makepkg.local
1. cower.local

Note1: It is expected that the above list will usually be incomplete. You can check the `local-customisations` folder for useful customisations by grepping for `# Further restrict the`.

Note2: Both `profiles` and `local-customisations` are very much works in progress, so frequent updates are to be expected.

#### FjTools
This is just a little extra. It contains a set of bash shells that provide extra functionality for controlling Firejail and writing profiles. Currently, it consists of:
* `FjTools-Shared`: Contains the paths used by FjTools, and distro specific commands. For example:
  * (Note, I only use Arch Linux, so the following is untested and may need some tweaking for non-arch based distros)
```
# Distro specific package owner search, comment/uncomment as needed.
GetPckgOwner="pacman -Qoq"          ### Arch based distro's
# GetPckgOwner="dpkg --search"      ### Debian based distro's
# GetPckgOwner="rpm -qf"            ### Fedora based distro's
```
* `FjTools-DisableSymlinks`: A tool to temporarily disable desktop integration
  * Note, I keep my firejail symlinks in custom folder `/usr/local/bin/FjSymlinks/` which I added to my ${PATH}. So, you will need to edit the `$FjSymlinks` variable to your own usage.
* `FjTools-UnusedProfiles`: Finds unused Firejail profiles and offer's to create a symlink in the `$FjSymlinks` folder
* `FjTools-SymlinkedProfiles`: Lists which applications are using Firejail by default.
* `FjTools-HomeGrownProfiles`: Lists profiles in `/etc/firejail` which are not owned by Firejail
