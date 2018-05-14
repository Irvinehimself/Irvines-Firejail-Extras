# Irvines-Hardening-Project
Profiles, local customisations and tools for Firejail and AppArmor

***Under Reconstction***

## Contents
* [**Introduction**](#introduction)
* [**Profiles**](#profiles)
* [**Local customisations**](#local-customisations)
  * [**Browsers and HDMI audio**](#browsers-and-hdmi-audio)
* [**Appendix -- FjTools**](#appendix----fjtools)
  1. [FjTools-Shared](#fjtools-shared)
  1. [FjTools-Includes](#fjtools-includes)
  1. [FjTools-DisableSymlinks](#fjtools-disablesymlinks)
  1. [FjTools-UnusedProfiles](#fjtools-unusedprofiles)
  1. [FjTools-SymlinkedProfiles](#fjtools-symlinkedprofiles)
  1. [FjTools-StatusWarnings](#fjtools-statuswarnings)
  1. [FjTools-HomeGrownProfiles](#fjtools-homegrownprofiles)
  1. [FjTools-DebugProfile](#fjtools-debugprofile)
  1. [FjTools-BackupProfile](#fjtools-backupprofile)
  1. [FjTools-BackupProfile](#fjtools-discardedstuff)


## Introduction
My current long term project is to experiment with building a high-security Os using [Arch Linux](https://www.archlinux.org). Apart from a commercial Vpn, disk encryption ... etc, the project basically consists of the following parts:
1. Use Firejail to sandbox **ALL** top level applications
1. My [apparmor enabled](https://aur.archlinux.org/pkgbase/linux-hardened-apparmor/) linux-hardened kernel
1. Write restrictive Apparmor profiles for sensitive low level daemons. eg `NetworkManager`, `openvpn`, `wpa-supplicant`, `gvfsd`, `udisks2`, `tumblerd`, .... etc
1. Write tools, particularly for Firejail, to help automate the process of managing the enviroment.

***Under Reconstction***

[*Return to contents*](#contents)

## Profiles
I intend to post any Firejail profiles I have written, along with my local customisations of upstream profiles. While several of my profiles have already been accepted for inclusion upstream, the majority have not yet been submitted. For convenience, the file [`NotYetSubmitted`](https://github.com/Irvinehimself/Irvines-Firejail-Extras/blob/master/NotYetSubmitted) contains an an automatically updated list of all my unsubmitted `profiles`.

The following are my un-submitted `profiles` most likely to be of interest to a casual visitor:
```
epdfview.profile    : Restrictive and usable, but needs private-bin, private-etc and private-lib
Player.profile      : Restrictive and usable, but needs private-etc and private-lib
QMLPlayer.profile   : Restrictive and usable, but needs private-etc and private-lib
rsstail.profile     : Restrictive and usable, but needs private-etc and private-lib
showfoto.profile    : Basically a wrapper for the parent Digikam profile provided by upstream
```
*Note*: The above list of un-submitted profiles is a summary of what is most likely to be of interest, it is not an exhaustive list of my profiles.

*Further*: Both `profiles` and `local-customisations` are very much works in progress, so frequent updates are to be expected

[*Return to contents*](#contents)

## Local customisations
Currently, most of my local customisations are concerned with globally enabling apparmor confinement and/or disabling internet connectivity. However, I have recently started work on strengthening internet connected profiles. Mainly, this is to be achieved through creating whitelists for: `private-bin`, `private-lib`, `private-etc` and `private-opt`. The intention is to make these customisations **very** restrictive, while maintaining core functionality. For convenience, the file [`RestrictiveDotLocals`](https://github.com/Irvinehimself/Irvines-Firejail-Extras/blob/master/RestrictiveDotLocals) contains an an automatically updated list of all my `local` customisations which **further restrict** upstream profiles.

The following are the `.local` customisations most likely to be of interest to a casual visitor:
```
inox.local        	: private-bin, private-etc, private-dev, caps.keep whitelist and more
opera.local       	: private-bin, private-etc, private-dev, caps.keep whitelist and more
firefox.local     	: private-bin, private-etc, private-dev, and private-lib (Tested with Firefox 57)
transmission-gtk.local  : private-lib, private-etc, private-opt, noexec ${HOME} and noexec /tmp
```
[*Return to contents*](#contents)

#### Browsers and HDMI audio
*Note*: This does not apply to jack-in speakers or headphones, but solely to HDMI audio output.

In my home setup, I mirror my laptop screen to my Tv and have a shell with launcher to toggle the audio output between the 'built-in' and 'HDMI' speakers. Unfortunately, for this to work when a browser is playing streaming media, `private-etc` needs to include the file [machine-id](https://www.freedesktop.org/software/systemd/man/machine-id.html). Since `/etc/machine-id` is a unique identifier, this constitutes a serious privacy threat, and, by default, my local customisations do not enable it. If you wish to switch between 'built-in' and 'HDMI' audio, (or use 'HDMI' audio for streaming media,) then you need to add `machine-id` to the end of the `private-etc` string.

Further, be warned, when`machine-id` is not present in `private-etc`, trying to toggle between the 'built-in' and 'HDMI' speakers **while playing streaming media**  will crash audio output for everything except the browser. On the other hand, if you are not currently playing streaming media, then you can toggle between the 'built-in' and 'HDMI' speakers with no ill effect, irrespective of whether the browser is open or not.

[*Return to contents*](#contents)

## Appendix -- FjTools
This is a set of bash shells that provide extra functionality for controlling Firejail and writing profiles. It has it's own work folder, `${HOME}/Documents/FjToolsWork`, which can be changed in `FjTools-Shared`. Additionally, the various tools will create their own subfolders in which to store their results.

Currently, it consists of:

#### FjTools-Shared
Contains the shared paths and distro specific functions used by FjTools which a user may wish to customise. I only use Arch Linux, so I can't test or develop versions of FjTools for other distros. However, if you wish to port the tools, I will be only to glad to help, and suggest, as a first step, you open an issue.

*Note*: As written, it is assumed that the FjTools shells are installed to `/usr/local/bin`, or some other location in the ${PATH}

[*Return to contents*](#contents)

#### FjTools-Includes
Contains the shared functions which a user is unikely to wish to customise.

[*Return to contents*](#contents)

#### FjTools-DisableSymlinks
A couple of tools to enable/disable desktop integration

*Note*: I keep my firejail symlinks in a custom folder `/usr/local/bin/FjSymlinks/` which I added to my ${PATH}. So, you will need to edit the `$FjSymlinks` variable to your own usage.

[*Return to contents*](#contents)

#### FjTools-StatusWarnings
A bash to nag you if various security related features, cameras and microphones are disabled/enabled

[*Return to contents*](#contents)

#### FjTools-UnusedProfiles
Finds unused Firejail profiles and offer's to create a symlink in the `$FjSymlinks` folder

[*Return to contents*](#contents)

#### FjTools-SymlinkedProfiles
Lists which applications are using Firejail by default.

[*Return to contents*](#contents)

#### FjTools-HomeGrownProfiles
Lists profiles in `/etc/firejail` which are not owned by Firejail

[*Return to contents*](#contents)

#### FjTools-DebugProfile
A wrapper to launch applications in `firejail --debug` mode:
1. Basically, it's just a quick way to launch a profile in debug mode. However, it has useful features like automatically copying the profile under test, along with it's local customisations, to a backup folder, the contents of which are also backed up.
1. You should note that there is a great deal of useful information to gleaned from `stderr`. So, both `stdout` and `stderr` are `tee`ed to the debug log file.

[*Return to contents*](#contents)

#### FjTools-BackupProfile
Backup and/or restore working copies of `<App>.profile`, `<App>.local` and `<App>.net` to `${HOME}/Documents/FjToolsWork/BackupProfiles/`
1. The difference between this backup function and the one above, is that `FjTools-DebugProfile` automatically makes backups of the profile being tested, which may or may not work. As the name suggests, however, this backup function is used to backup important milestones.
1. Additionaly, it has an option to  backup **ALL** the local customisations and homegrown profiles in `/etc/firejail`

[*Return to contents*](#contents)

#### FjTools-DiscardedStuff
Basically a few routines to help with creating `private lib, bin, etc` they have been discarded partly because upstream is working on the problem. Also, I discovered [LDD(1)](http://man7.org/linux/man-pages/man1/ldd.1.html)  which, along with Apparmor's `aa-genprof`, seem to offer a ready made solutions

[*Return to contents*](#contents)
