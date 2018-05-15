# Apparmor
Profiles, local customisations and for AppArmor

## Overview
Still under development: I had all the profiles working in ***enforce*** mode using the Ubuntu abstractions, however some of these abstractions, particularly `base`, `plugins-common` and most of the `ubuntu-*` stuff is way, way tooo permissive to provide adequate confinement.

For example, just scratch the surface of common `logprof` suggestions and we find:
1. Ptrace is wide open for abuse
1. Dbus is completely unrestricted
1. #Plus my personal favourites:
* /{usr/,}bin/* Pixr,
* /{usr/,}sbin/* Pixr,
* /usr/local/bin/* Pixr,
* /{,usr/}bin/bash ixr,
* /{,usr/}bin/dash ixr,
* /{,usr/}bin/grep ixr,
* /{,usr/}bin/sed ixr,

Remember, that this list is not exhaustive, just indicative of how weak some of the standard abstractions really are.

Of course, depending on the context, some abstractions are quite safe and far too useful to ignore, the `audio` abstraction for `pulseaudio` being a case in point. Suffice to say: Any abstractions I am using have been carefully vetted and, and in case interested parties do have them, I have included copies, along with the requisite tunables.




