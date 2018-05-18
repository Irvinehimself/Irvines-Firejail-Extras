# Apparmor
Profiles and local customisations for AppArmor

#### Overview
Still under development: All the [Canonical abstractions](#note--abstractions) have been ditched and things are progressing nicely. Everything is working in *enforce* mode and running `aa-logprof`, most profiles do not need any refinement. I have started to makings pretty retty, with a nice layout and inline notes. The main profile that still needs a little bit of work is `usr.lib.udisks2.udisksd`. It is working with *thumb drives*, *external drives*, *external video players* etc, etc. At that the moment, I have been switching stuff around to make sure things are not tied to a specific *usb socket* and checking functionality like *mount*, *unmount* and *eject*. I still have a few things to check, but everything is looking good.

#### Portability
Since I only use *Arch Linux*, which has a rational file system layout, depending on your distro, you may have to tweak `/usr/bin/` and `/usr/lib/` to the particular mix of: `/bin/`,`/sbin/`, `/usr/bin/`, .... `/lib/`, `/lib64/` and `/usr/lib/` used by your distro of choice.

#### Profiles
An uptodate list of the profiles I am working on is available [here](https://github.com/Irvinehimself/Irvines-Hardening-Project/blob/master/AppArmor/AppArmor-ProfileList), but currently it connsists of:

* usr.lib.udisks2.udisksd
  * Running in `enforce` mode, but still needs some work
* usr.lib.gvfsd
  * Running in `enforce` mode, needs tidying up and checking
* usr.lib.tumbler-1.tumblerd
  * Running in `enforce` mode, needs tidying up and checking
* usr.bin.NetworkManager
  * Running in `enforce` mode, needs tidying up
* usr.bin.wpa_supplicant
  * Running in `enforce` ---- completed?
* usr.bin.pulseaudio
  * Running in `enforce` mode, needs tidying up and checking


#### Urgent TODO list, (mostly checking stuff.)
1. Obviously, `usr.lib.udisks2.udisksd` needs broad authority over `mounts`, and I have added:
   * mount,
   * remount,
   * umount,
   * The question is: Should I include `pivot_root`, in the above list?
1. As stated above, the rest of it is just running these profiles and checking for errors; finding stuff that is blocked but I actually need, and of course checking for stuff that is permitted but unnecessary :)

#### Whats next?
I have a list, (which is constanly under review,) of things which need confinement
1. Almost certainly AppArmor:
   * Drill
   * Etherape
   * Iftop
   * Iptraf
   * Nethogs
1. Possibly Apparmor, but Firejail, (with the `firejail-default` Apparmor profile) may be more appropriate
   * ffmpeg
   * imagemagick

#### Far, far away in the future:
Upgrade the default profiles for `ping` and `traceroute`??? The problem is that the `base` abstraction is very permissive when it comes to `ptrace`, `signals` `sockets` ... etc. You need to read it for yourself, but it permits a lot of undesirable capabilities that most applications shouldn't need.

#### Note--abstractions
Some of the common abstractions, particularly `base`, `plugins-common` and most of the `ubuntu-*` stuff is way, way too permissive to provide adequate confinement.

For example, just scratch the surface of common `logprof` suggestions and we find:
* Ptrace is wide open for abuse
* Dbus is completely unrestricted
* Plus my personal favourites:
  * /{usr/,}bin/* Pixr,
  * /{usr/,}sbin/* Pixr,
  * /usr/local/bin/* Pixr,
  * /{,usr/}bin/bash ixr,
  * /{,usr/}bin/dash ixr,
  * /{,usr/}bin/grep ixr,
  * /{,usr/}bin/sed ixr,

Remember, that this list is not exhaustive, just indicative of how weak some of the standard abstractions really are.

Of course, depending on the context, some abstractions are quite safe and far too useful to ignore, the `audio` abstraction for `pulseaudio` being a case in point. Suffice to say: Any abstractions I am using have been carefully vetted and, and in case interested parties do not have them, I have included copies, along with the requisite tunables.




