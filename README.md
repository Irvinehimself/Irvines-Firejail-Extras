# Irvines-Firejail-Extras
Extra profiles, local customisations and tools for Firejail

#### Contents
* **Introduction**
* **Profiles**
* **Local customisations**
* **FjTools**
  1. *FjTools-Shared*
  1. *FjTools-DisableSymlinks*
  1. *FjTools-UnusedProfiles*
  1. *FjTools-SymlinkedProfiles*
  1. *FjTools-HomeGrownProfiles*
  1. *FjTools-FjTools-DebugProfile*
  1. *FjTools-BackupProfile*
  1. *FjTools-CreatePrivateLib*


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
inox.local        	: private-bin, private-etc, private-dev, caps.keep whitelist and more
opera.local       	: private-bin, private-etc, private-dev, caps.keep whitelist and more
firefox.local     	: private-bin, private-etc, private-dev, and private-lib (Tested with Firefox 57)
makepkg.local     	: restrict access to ${HOME}
cower.local       	: restrict access to ${HOME}
```

**Note1:** It is expected that the above list will usually be incomplete. You can check the `local-customisations` folder for useful customisations by grepping for `# Further restrict the`.

**Note2:** Both `profiles` and `local-customisations` are very much works in progress, so frequent updates are to be expected.

#### FjTools
This is just a little extra. It contains a set of bash shells that provide extra functionality for controlling Firejail and/or writing profiles.

Currently, it consists of:

**FjTools-Shared:** Contains the paths and distro specific commands used by FjTools. I only use Arch Linux, so I cant test or develop versions of FjTools for other distros. However, if you wish to port the tools to other distros, I will be only to glad to help, and suggest, as a first step, you open an issue.
* *Note*: As written, it is assumed that FjTools are installed to `/usr/local/bin`, or some other location in the ${PATH}

**FjTools-DisableSymlinks:** A tool to temporarily disable desktop integration
* *Note*: I keep my firejail symlinks in a custom folder `/usr/local/bin/FjSymlinks/` which I added to my ${PATH}. So, you will need to edit the `$FjSymlinks` variable to your own usage.

**FjTools-UnusedProfiles:** Finds unused Firejail profiles and offer's to create a symlink in the `$FjSymlinks` folder

**FjTools-SymlinkedProfiles:** Lists which applications are using Firejail by default.

**FjTools-HomeGrownProfiles:** Lists profiles in `/etc/firejail` which are not owned by Firejail

**FjTools-FjTools-DebugProfile:** A wrapper to launch applications in `firejail --debug` mode.
1. It has a lot of nice features like automatically making indexed backups of `<App>.profile`, `<App>.local`, and `<App>.net` all of which are cross-referenced to the relevant `firejail --debug` output
1. By default, it creates the work directory `${HOME}/Desktop/FjTools-DebugFolder` this can be changed in `FjTools-shared`
1. You should note that there is a great deal of useful in formation to gleaned from `stderr`, so both `stdout` and `stderr` are `tee`ed to the debug log file.

**FjTools-BackupProfile:** Backup and/or restore a last working cop of `<App>.profile`, `<App>.local` and `<App>.net`
1. The difference between this backup function and the one above, is that `FjTools-DebugProfile` automatically backs up an indexed copy of the profile being tested, which may or may not work. This backup function however, has it's own `LastWorkingCopy` sub-folder of the `FjTools-DebugFolder`, and, as the name suggests, is used to backup important milestones.
1. **Important Tip:** Being old, and very much an un-natural typist, I am not generally a great fan of *keybindings*. However, in this case, I have to admit that having *hotkeys* to launch `FjTools-DebugProfile` and `FjTools-BackupProfile` greatly speeds up the workflow.

**FjTools-CreatePrivateLib:** Like the Firejail `private-lib` feature itself, this is pretty much still experimental. However, it did greatly simplify the building of the `private-lib` whitelist for Firefox 57. Which, by the way, is the first non-trivial working example of the `prvate-lib` feature I have seen. (Try `grep "private-lib" /etc/firejai/*` and see how many examples you find!)
* **Limitations:**
* It only tries to get the \<app\> to launch and ignores warnings. (See the inline notes for the shell)
* If the \<app\>  launches, it may immediately crash. (See my inline notes about `private-lib` in the Chromium based Opera and Inox browser's `.local` customisation files)
* Even if it launches, you will probably have to use `stderr` to manually find the missing files for things like Gtk
* After all this, your are still going to have to make an educated guess about what is needed to enable missing functionality, eg internet connectivity:
  1. In the case of Firefox 57, I guessed that it was the `nss` network security package and used `ls /usr/lib | grep "nss" | tr '\n' ','`
  1. After copy/pasting that rather large list onto the end of my `private-lib` I had internet connectivity.
  1. I then used a [binary chop algorithm](https://en.wikipedia.org/wiki/Binary_search_algorithm) to manually remove the unneeded libraries.

**FjTools-GuessMissingLibs:** Attempts to find all the files in `/usr/lib` owned by an applications dependencies.
* **Limitations and Usage:**
* The list is extensive and 99.9% of the entries are unneeded. For an Application like Firefox, this would make it completely unusable as a direct copy/paste. So, for convenience, it has "chop marks" to assist in systematically testing for missing functionality. In the case of Firefox, after restoring internet connectivity, I realised YouTube videos had no sound:
  1. Running *FjTools-GuessMissingLibs* I had a list of over a thousand potential libraries, about a dozen libraries which were hard coded to a particular version, and one package for which the algorithm couldn't find the "Provided By" package.
  1. It took six cuts of the "GuessPrivateLib-firefox" file to narrow the thousand potential libraries  down to `libnss_compat.so.2`, and, consequently, restore sound to YouTube
* Some dependencies are hard coded to a particular version, these are stored in a separate file. eg `Libraries-firefox`
* Similarly, some dependencies are "provided by" a package other than what the developers originally intended. The algorithm tries to find this replacement package, but, rarely, this may not be possible and require the user to manually search for the "Provides" package. These missing packages are also stored in separate file, eg `NotFound-firefox`


**FjTools-GetAppDependencies:** This is the work horse for *FjTools-GuessMissingLibs*, but has so many potential applications, (like for example: guessing `private-bin`, `private-opt` and `private-etc` entries,) I have spun it off as a separate sub-shell. As the name suggests, it uses recursion to generate a 'chain of dependencies' for an application. this 'chain of dependencies' can then be cross-referenced against the owners of the files and folders in your `lib` `bin` `etc` and `opt` directories.
