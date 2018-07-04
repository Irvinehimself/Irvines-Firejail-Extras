# Apparmor
Profiles and local customisations for AppArmor

### Overview
The AppArmor part of this project is to write profiles for low level daemons that would benefit from more specific AppArmor confinement than that provided by the generic *firejail-default* profile. For the most part, I am concentrating on daemons and applications that either live in user space, or have some input/output function.

Note:  All the [Canonical abstractions](#note--abstractions) have been ditched.

### Portability
Since I only use *Arch Linux*, which has a rational file system layout, depending on your distro, you may have to tweak `/usr/bin/` and `/usr/lib/` to the particular mix of: `/bin/`,`/sbin/`, `/usr/bin/`, .... `/lib/`, `/lib64/` and `/usr/lib/` used by your distro of choice.

### Finished profiles
An uptodate list of profiles is available [here](AppArmor-ProfileList), but these are the ones people will likely find most interesting:

**Cleaned and in enforce mode**
1. usr.bin.NetworkManager
1. usr.bin.wpa_supplicant
1. usr.bin.nm-applet
1. usr.lib.udisks2.udisksd
1. usr.lib.gvfsd
1. usr.lib.gvfsd-metadata
1. usr.lib.gvfs-udisks2-volume-monitor
1. usr.bin.pulseaudio
1. usr.lib.xfce4.notifyd.xfce4-notifyd
1. usr.lib.tumbler-1.tumblerd
1. usr.bin.ffplay
1. usr.bin.ffmpegthumbnailer

**Testing in enforce mode**
1. usr.bin.vnstatd
1. usr.bin.mpg123
1. usr.bin.aplay

**Testing in complain mode**
1. usr.bin.ffmpeg
1. usr.bin.youtube-dl
1. usr.bin.vnstat
1. usr.bin.vnstati
1. usr.bin.magick

#### **IMPORTANT**
The `usr.lib.udisks2.udisksd` profile deny's all operations on `/run/media` and `/media`. The reasoning for this is to gain full control of how *external drives* and *partitions* are mounted. In particular, I wish to ensure that they are mounted with the `noexec` flag set, and that I can, as I choose, either mount them as  `read-only` or `read-write`. My reasoning is explained fully in the [HsTools readme](/HsTools#udisks2-hardening).

Suffice to say, my `usr.lib.udisks2.udisksd` profile in combination with [Hs-MountReadWrite](/HsTools#hs-mountreadwrite) offer full control of mount operations in a manner that is secure against threats like, for example, [Stuxnet](https://en.wikipedia.org/wiki/Stuxnet#Operation).

#### Signal receive ~~ peer=*unconfined*
After a bit of research and finding [old vulnerabilities](https://tools.cisco.com/security/center/viewAlert.x?alertId=30107), (long since fixed,) my first reaction was to deny `signal receive ~~ peer=unconfined`. However, in practice, this is not practical.  At the very least, the task-manager needs to be able to `kill`, `terminate`, `stop` and `continue` processes; as do I.

After further research revealed the complexity of the problem, I reviewed `abstractions/base`, which is the recomended abstraction.

My main objection are:
1. It allows `PROT_EXEC` access to the entirety of `usr\lib`
1. It allows `ptrace (readby)` and `  ptrace (tracedby)`

As a result, I created a more restrictive version of `abstractions/base` called `local/MyBase` and am now including it as standard in all my profiles. Basically, the aim is to allow `signal` and `unix socket` operations but while only allowing `PROT_EXEC` on an *as need* basis.

#### Notes:
1. `usr.bin.magick` is the main entry point for *ImageMagick*


### Whats next?
I have a list, (which is constanly under review,) of things which need confinement
1. Not yet started, but certainly AppArmor:
   * Drill
   * Etherape
   * Iftop
   * Iptraf
   * Nethogs


### Far, far away in the future:
Upgrade the default profiles for `ping` and `traceroute`??? The problem is that the `base` abstraction is very permissive when it comes to `ptrace`, `signals` `sockets` ... etc. You need to read it for yourself, but it permits a lot of undesirable capabilities that most applications shouldn't need.


### Note--abstractions
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




