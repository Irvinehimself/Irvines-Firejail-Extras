# Firejail profile for Convert-All
# This profile will be automatically replaced when an upstream profile becomes available.

# Persistent local customizations
include /etc/firejail/convertall.local
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
# private
# private-bin program
private-dev
# private-etc none
# private-lib
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
