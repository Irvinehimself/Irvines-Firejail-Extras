# Firejail profile for sol (Aislette Solitaire)
# This profile will be automatically replaced when an upstream profile becomes available.

# Persistent local customizations
include /etc/firejail/sol.local

# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

disable-mnt
private-dev
private-tmp

# Stopped working with memory-deny-write-execute enabled after 5/6-3-2018 update. see the note Firejai-5/6-3-2018-update
# Probably either dbus or librsvg. (see /home/stupidme/Desktop/Firejail-ExecMemoryProblem folder for elimination work files)
#memory-deny-write-execute
noexec ${HOME}
noexec /tmp
