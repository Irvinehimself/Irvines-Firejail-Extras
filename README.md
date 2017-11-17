# Irvines-Firejail-Extras
Extra profiles, local customisations and tools for Firejail

#### Introduction
Inspired by recent security threats and the new [SubGraph OS](https://subgraph.com/), my current long term project is to experiment with building a high-security Os using [Arch Linux](https://www.archlinux.org)

Apart from a commercial Vpn, disk encryption ... etc, the project basically consists of two parts:
1. **Use Firejail to sandbox everything!!!**
1. My [apparmor enabled](https://aur.archlinux.org/pkgbase/linux-hardened-apparmor/) linux-hardened kernel

It is the first item on the list that this GitHub project is concerned with.

#### Profiles
Mainly, I intend to post any Firejail profiles I have written, along with my local customisations of upstream profiles. Several of these profiles have already been accepted for inclusion upstream, while others have not yet been submitted. You can tell which is which by the following comment:
* \# This file is overwritten after every install/update
* \# This profile will be automatically replaced when an upstream profile becomes available.

#### Local customisations
Currently, most of my local customisations are concerned with globally enabling apparmor confinement and/or disabling internet connectivity. However, I have recently started work on strengthening internet connected profiles.

The following `.local` files have potentially useful customisations which strengthen their respective upstream profiles:
```
  inox.local        		: private-bin, private-etc, private-dev, caps.keep whitelist and more
  opera.local       		: private-bin, private-etc, private-dev, caps.keep whitelist and more
  firefox.local     		: private-bin, private-etc and private-dev, (private-lib work in progress)
  makepkg.local     		: restrict access to ${HOME}
  cower.local       		: restrict access to ${HOME}
```

**Note1:** It is expected that the above list will usually be incomplete. You can check the `local-customisations` folder for useful customisations by grepping for `# Further restrict the`.

**Note2:** Both `profiles` and `local-customisations` are very much works in progress, so frequent updates are to be expected.

#### FjTools
This is just a little extra. It contains a set of bash shells that provide extra functionality for controlling Firejail and/or writing profiles. Currently, it consists of:
* `FjTools-Shared`                  : Contains the paths used by FjTools, and distro specific commands. For example:
  * (Note, I only use Arch Linux, so the following is untested and may need some tweaking for non-arch based distros)
```
# Distro specific package owner search, comment/uncomment as needed.
GetPckgOwner="pacman -Qoq"          ### Arch based distro's
# GetPckgOwner="dpkg --search"      ### Debian based distro's
# GetPckgOwner="rpm -qf"            ### Fedora based distro's

NoPckgOwns="error: No package owns" ### For non-arch distros, you may need to edit this string
```

* `FjTools-DisableSymlinks`         : A tool to temporarily disable desktop integration
  * Note, I keep my firejail symlinks in a custom folder `/usr/local/bin/FjSymlinks/` which I added to my ${PATH}. So, you will need to edit the `$FjSymlinks` variable to your own usage.

* `FjTools-UnusedProfiles`          : Finds unused Firejail profiles and offer's to create a symlink in the `$FjSymlinks` folder

* `FjTools-SymlinkedProfiles`       : Lists which applications are using Firejail by default.

* `FjTools-HomeGrownProfiles`       : Lists profiles in `/etc/firejail` which are not owned by Firejail

* `FjTools-FjTools-DebugProfile`    : A wrapper to launch applications in `firejail --debug` mode.
  1. It has a lot of nice features like automatically making indexed backups of `<App>.profile`, `<App>.local`, and `<App>.net` all of which are cross-referenced to the relevant `firejail --debug` output
  1. By default, it creates the work directory `${HOME}/Desktop/FjTools-DebugFolder` this can be changed in `FjTools-shared`
  1. You should note that there is a great deal of useful in formation to gleaned from `stderr`, so both `stdout` and `stderr` are `tee`ed to the debug log file.

* `FjTools-BackupProfile`           : Backup and/or restore a last working cop of <AppName>.profile, <AppName>.local and <AppName>.net
  1. The difference between this backup function and the one in above, is that `FjTools-FjTools-DebugProfile` automatically backs up an indexed copy of the profile being tested, which may or may not work. This backup function however, has it's own `LastWorkingCopy` sub-folder of the `FjTools-DebugFolder`, and, as the name suggests, is used to backup important milestones.

**Important Tip:** Being old, and a very un-natural typist, I am not generally a great fan of *keybindings*. However, in this case, I have to admit that having *hotkeys* to launch `FjTools-FjTools-DebugProfile` and `FjTools-BackupProfile` greatly speeds up my workflow.
