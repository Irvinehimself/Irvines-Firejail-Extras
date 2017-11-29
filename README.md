# Irvines-Firejail-Extras
Extra profiles, local customisations and tools for Firejail

## Contents
* [**Introduction**](#introduction)
* [**Profiles**](#profiles)
* [**Local customisations**](#local-customisations)
  * [**Browsers and HDMI audio**](#browsers-and-hdmi-audio)
* [**FjTools**](#fjtools)
  1. [FjTools-DisableSymlinks](#fjtools-disablesymlinks)
  1. [FjTools-UnusedProfiles](#fjtools-unusedprofiles)
  1. [FjTools-SymlinkedProfiles](#fjtools-symlinkedprofiles)
  1. [FjTools-HomeGrownProfiles](#fjtools-homegrownprofiles)
  1. [FjTools-DebugProfile](#fjtools-debugprofile)
  1. [FjTools-BackupProfile](#fjtools-backupprofile)
  1. [FjTools-CreatePrivateLib](#fjtools-createprivatelib)
  1. [FjTools-GuessMissingLibs](#fjtools-guessmissinglibs)
  1. [FjTools-GetAppDependencies](#fjtools-getappdependencies)
  1. [FjTools-GuessMissingEtcs](#fjtools-guessmissingetcs)
* [**Example Usage -- Creating Firefox private-lib**](#example-usage----creating-firefox-private-lib)

## Introduction
Inspired by recent security threats and the new [SubGraph OS](https://subgraph.com/), my current long term project is to experiment with building a high-security Os using [Arch Linux](https://www.archlinux.org)

Apart from a commercial Vpn, disk encryption ... etc, the project basically consists of two parts:
1. **Use Firejail to sandbox everything!!!**
1. My [apparmor enabled](https://aur.archlinux.org/pkgbase/linux-hardened-apparmor/) linux-hardened kernel

It is the first item on the list that this GitHub project is concerned with.

[*Return to contents*](#contents)

## Profiles
Mainly, I intend to post any Firejail profiles I have written, along with my local customisations of upstream profiles. While several of these profiles have already been accepted for inclusion upstream, the majority have not yet been submitted. For convenience, the file [`NotYetSubmitted`](https://github.com/Irvinehimself/Irvines-Firejail-Extras/blob/master/NotYetSubmitted) contains an an automatically updated list of all my unsubmitted `profiles`.

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

## FjTools
This is a set of bash shells that provide extra functionality for controlling Firejail and writing profiles. Currently, it consists of:

#### FjTools-Shared
Contains the paths and distro specific commands used by FjTools. I only use Arch Linux, so I can't test or develop versions of FjTools for other distros. However, if you wish to port the tools to other distros, I will be only to glad to help, and suggest, as a first step, you open an issue.

*Note*: As written, it is assumed that the FjTools shells are installed to `/usr/local/bin`, or some other location in the ${PATH}

[*Return to contents*](#contents)

#### FjTools-DisableSymlinks
A tool to temporarily disable desktop integration

*Note*: I keep my firejail symlinks in a custom folder `/usr/local/bin/FjSymlinks/` which I added to my ${PATH}. So, you will need to edit the `$FjSymlinks` variable to your own usage.

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
1. It has a lot of nice features like automatically making indexed backups of `<App>.profile`, `<App>.local`, and `<App>.net` all of which are cross-referenced to the relevant `firejail --debug` output
1. By default, it creates the work directory `${HOME}/Desktop/FjTools-DebugFolder` this can be changed in `FjTools-shared`
1. You should note that there is a great deal of useful in formation to gleaned from `stderr`, so both `stdout` and `stderr` are `tee`ed to the debug log file.

[*Return to contents*](#contents)

#### FjTools-BackupProfile
Backup and/or restore a last working copy of `<App>.profile`, `<App>.local` and `<App>.net`
1. The difference between this backup function and the one above, is that `FjTools-DebugProfile` automatically backs up an indexed copy of the profile being tested, which may or may not work. This backup function however, has it's own `LastWorkingCopy` sub-folder of the `FjTools-DebugFolder`, and, as the name suggests, is used to backup important milestones.

[*Return to contents*](#contents)

#### FjTools-CreatePrivateLib
Like the Firejail `private-lib` feature itself, this is pretty much still experimental. However, it did greatly simplify the building of the `private-lib` whitelist for Firefox 57. Which, by the way, is the first non-trivial working example of the `prvate-lib` feature I have seen. (Try `grep "private-lib" /etc/firejai/*` and see how many examples you find!)
* **Limitations:**
* It only tries to get the \<app\> to launch and ignores warnings. (See the inline notes for the shell)
* If the \<app\>  launches, it may immediately crash. (See my inline notes about `private-lib` in the Chromium based Opera and Inox browser's `.local` customisation files)
* Even if it launches, you will probably have to use `stderr` to manually find the missing files for things like Gtk
  1. Typically, the missing GTK libraries might be: *"gtk-3.0, gdk-pixbuf-2.0 and libcanberra-gtk3.so.0"*
* After all this, your are still going to have to make an educated guess about what is needed to enable missing functionality. To help with this task, I wrote the complementary *FjTools-GuessMissingLibs*, (below,) which greatly eases the task of guessing the libraries missed by *FjTools-CreatePrivateLib*.
  1. In the case of Firefox 57, I guessed that it was the `nss` network security package and used `ls /usr/lib | grep "nss" | tr '\n' ','`
  1. After copy/pasting that rather large list onto the end of my `private-lib` I had internet connectivity.
  1. I then used a [bisection](https://en.wikipedia.org/wiki/Bisection_method) to manually remove the unneeded libraries.

[*Return to contents*](#contents)

#### FjTools-GuessMissingLibs
A complement to *FjTools-CreatePrivateLib*, *FjTools-GuessMissingLibs:* attempts to find all the files in `/usr/lib` owned by an applications dependencies.
* **Limitations and Usage:**
* The list is extensive and 99.9% of the entries are unneeded. For an Application like Firefox, this would make it completely unusable as a direct copy/paste. So, for convenience, it has "chop marks" to assist in systematically testing for missing functionality.
* Some dependencies are hard coded to a particular version, these are stored in a separate file. eg `Libraries-firefox`
* Similarly, some dependencies are "provided by" a package other than what the developers originally intended. The algorithm tries to find this replacement package, but, rarely, this may not be possible and require the user to manually search for the "Provides" package. These missing packages are also stored in separate file, eg `NotFound-firefox`

[*Return to contents*](#contents)

#### FjTools-GetAppDependencies
This is the work horse for *FjTools-GuessMissingLibs*, but has so many potential applications, (like for example: guessing `private-bin`, `private-opt` and `private-etc` entries,) I have spun it off as a separate sub-shell. As the name suggests, it uses recursion to generate a 'chain of dependencies' for an application. this 'chain of dependencies' can then be cross-referenced against the owners of the files and folders in your `lib` `bin` `etc` and `opt` directories.

[*Return to contents*](#contents)

#### FjTools-GuessMissingEtcs
Much like *FjTools-GuessMissingLibs*, it attempts to find all the files in `/etc` owned by an applications dependencies. This list can then be quickly [bisected](https://en.wikipedia.org/wiki/Bisection_method) to to remove unneeded entries.

*Note:* *FjTools-GuessMissingEtcs* also creates a list of files in `/etc` which are not owned by any package. This includes things like: *hostname and machine-id*, which may, or may not be needed for certain functionality. See [**Browsers and HDMI audio**](#browsers-and-hdmi-audio)

[*Return to contents*](#contents)

## Example Usage -- Creating Firefox private-lib
*Note*: In what follows it will help to have a basic understanding of [bisection](https://en.wikipedia.org/wiki/Bisection_method)

*Step 1:*
1. Run *FjTools-CreatePrivateLib* and enter `firefox`
1. Navigate to your work folder, open `CreatePrivateLib-firefox` and, ignoring any errors or warnings, copy the `private-lib` string into `firefox.local`
1. Using a terminal, launch firefox with the new firejail profile.
1. Scroll through the expected GTK messages, until you find errors and warnings about missing files and add the indicated folders and libraries to your `private-lib`.
   1. You may need to use your file search utility to find containing folders.
   1. If the file search fails to find a missing folder, use something like: `ls /usr/lib | grep "canberra"` to get a list of missing shared objects. By continually *bisecting* the resulting list and discarding the half that doesn't work you can quickly narrow it down to a single shared object library.
1. Repeat steps 3 through 5 until there are no more GTK errors. (Ignore the depreciation warnings, they are normal)

*Step 2:*
1. Test the application for basic functionality: In the case of Firefox, there was no internet connectivity
1. Run *FjTools-GuessMissingLibs* and enter `firefox`
1. Make a backup copy of the resulting file `GuessPrivateLib-firefox`
1. Try the list `Libraries-firefox` to see if provides the missing functionality.
1. If successful, use *bisection* to eliminate unseeded shared objects.
1. Otherwise, use the provided "chop marks" to systematically test each section of `GuessPrivateLib-firefox` to see if it provides the missing functionality.
1. Once you find the required section, use *bisection* to eliminate unneeded shared objects.
1. Run further tests for core functionality and repeat steps 6, 7 and 8 as needed.

In the case of Firefox, after resolving internet connectivity, successive tests revealed the following functionality to be missing:
1. YouTube sound
1. Libraries for multiple HTML5 video codecs (eg, H264)
1. Libraries for multiple audio codecs
1. Libraries for switching to HDMI audio

Each of these issues had to be resolved individually before it was possible to test the next issue on the list. However, testing systematically in the manner outlined, it only took about twenty minutes to have a fully functional `private-lib`

*As an aside, porn sites are a good place to test streaming media*

[*Return to contents*](#contents)
