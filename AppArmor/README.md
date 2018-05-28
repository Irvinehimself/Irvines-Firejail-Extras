# Apparmor
Profiles and local customisations for AppArmor

#### Overview
The AppArmor part of this project is to write profiles for low level daemons that would benefit from more specific AppArmor confinement than that provided by the generic *firejail-default* profile. For the most part, I am concentrating on daemons and applications that either live in user space, or have some input/output function.

Note:  All the [Canonical abstractions](#note--abstractions) have been ditched.

#### Portability
Since I only use *Arch Linux*, which has a rational file system layout, depending on your distro, you may have to tweak `/usr/bin/` and `/usr/lib/` to the particular mix of: `/bin/`,`/sbin/`, `/usr/bin/`, .... `/lib/`, `/lib64/` and `/usr/lib/` used by your distro of choice.

#### Finished profiles
An uptodate list of profiles is available [here](https://github.com/Irvinehimself/TheBeggarsHardeningProject/blob/master/AppArmor/AppArmor-ProfileList), but currently it consists of:

1. **usr.lib.udisks2.udisksd**
   * `enforce mode`  ----  `checked` ----- `completed`
1. **usr.lib.gvfsd**
   * `enforce mode`  ----  `checked` ----- `completed`
1. **usr.lib.tumbler-1.tumblerd**
   * `enforce mode`  ----  `checked` ----- `completed`
1. **usr.bin.NetworkManager**
   * `enforce mode`  ----  `checked` ----- `completed`
1. **usr.bin.wpa_supplicant**
   * `enforce mode` ----  `checked` ----- `completed`
1. **usr.bin.pulseaudio**
   * `enforce mode`  ----  `checked` ----- `completed`
1. **usr.lib.gvfsd-metadata**
   * `complain mode` ----  `started`
1. **usr.lib.gvfs-udisks2-volume-monitor**
   * `complain mode` ----  `started`
1. **usr.lib.xfce4.notifyd.xfce4-notifyd**
   * `complain mode` ----  `started`
1. **usr.bin.nm-applet**
   * `complain mode` ----  `started`
1. **usr.bin.ffplay**
   * `complain mode` ----  `started`
1. **usr.bin.ffmpeg**
   * `complain mode` ----  `not started`
1. **usr.bin.ffmpegthumbnailer**
   * `complain mode` ----  `started`

#### Whats next?
I have a list, (which is constanly under review,) of things which need confinement
1. Not yet started, but certainly AppArmor:
   * Drill
   * Etherape
   * Iftop
   * Iptraf
   * Nethogs
1. Possibly Apparmor, but Firejail, (with the generic `firejail-default` Apparmor profile) may be more appropriate
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




