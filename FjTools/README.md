## Introduction FjTools
This is a set of bash shells that provide extra functionality for controlling Firejail and writing profiles. It has it's own work folder, `${HOME}/Documents/FjToolsWork`, which can be changed in `FjTools-Shared`. Additionally, the various tools will create their own subfolders in which to store their results.

Currently, it consists of:

## Contents
  1. [FjTools-Shared](#fjtools-shared)
  1. [FjTools-Includes](#fjtools-includes)
  1. [FjTools-DisableSymlinks](#fjtools-disablesymlinks)
  1. [FjTools-UnusedProfiles](#fjtools-unusedprofiles)
  1. [FjTools-SymlinkedProfiles](#fjtools-symlinkedprofiles)
  1. [FjTools-StatusWarnings](#fjtools-statuswarnings)
  1. [FjTools-HomeGrownProfiles](#fjtools-homegrownprofiles)
  1. [FjTools-DebugProfile](#fjtools-debugprofile)
  1. [FjTools-DiscardedStuff](#fjtools-discardedstuff)




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

#### FjTools-DiscardedStuff
Basically a few routines to help with creating `private lib, bin, etc` they have been discarded partly because upstream is working on the problem. Also, I discovered [LDD(1)](http://man7.org/linux/man-pages/man1/ldd.1.html)  which, along with Apparmor's `aa-logprof`, seem to offer a ready made solution

[*Return to contents*](#contents)
