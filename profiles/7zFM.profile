# Firejail profile for 7zFM
# This profile will be automatically replaced when an upstream profile becomes available.

# Persistent local customizations
include /etc/firejail/7zFM.local
# Persistent global definitions
include /etc/firejail/globals.local

ignore noroot
net none
no3d
nodvd
nosound
notv
novideo
shell none
tracelog

include /etc/firejail/default.profile
