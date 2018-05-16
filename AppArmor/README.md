# Apparmor
Profiles and local customisations for AppArmor

## Overview
Still under development: All profiles are back to working in *enforce* mode after I ditched the [Canonical abstractions](#note1: abstractions).

## Urgent TODO list, (mostly checking stuff.)
1. Check up on `signal`:
   * Currently I am only allowing signal from confined peers :
     *  deny signal receive set=exists peer=unconfined,
     *  deny signal receive set=cont peer=unconfined,
     *  deny signal receive set=term peer=unconfined,
     *  deny signal receive set=kill peer=unconfined,
   * An example of what is permitted, (for gvfsd) :
     * signal receive set=hup peer=/usr/lib/gvfsd,
     * signal receive set=rtmin+0 peer=/usr/lib/gvfsd,
     * signal receive set=term peer=/usr/lib/gvfsd,
     * signal send set=hup peer=/usr/lib/gvfsd,
     * signal send set=rtmin+0 peer=/usr/lib/gvfsd,
     * signal send set=term peer=/usr/lib/gvfsd,
   * Particularly with reference to `deny signal receive set=kill peer=unconfined`, this may not be the best setup?
1. Obviously, `usr.lib.udisks2.udisksd` needs broad authority over `mounts`, and I have added:
   * mount,
   * remount,
   * umount,
   The question is: Should I include `pivot_root`, in the above list?
1. The rest of it is just running these profiles and checking for errors; finding stuff that is blocked but I actually need, and of course checking for stuff that is permitted but unnecessary :)

## Whats next?
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

## Far, far away in the future:
Upgrade the default profiles for `ping` and `traceroute`??? The problem is that the `base` abstraction is very permissive when it comes to `ptrace`, `signals` `sockets` ... etc. You need to read it for yourself, but it permits a lot of undesirable capabilities that most applications shouldn't need.

## Note1: abstractions
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




