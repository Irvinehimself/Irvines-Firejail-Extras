# Security tools

#### Overview
This section is focused on monitoring, general security and the tools to make it easier to adopt good habits. Since most of these shells run continuously in the background, as per my usual habit, I have included the necessary `systemd  unit files`. However, if `systemd` is not to your taste, with some minor tweaking you can run them from your `autostart` file or folder.

#### Hsr-PartitionMonitor
Dating back to the early days of the Pc, one of the simplest and most effective ways of protecting your personal data was to use partitions. Nowadays, very few people seem to realise that partitions should only be mounted on an *as-need* basis, and, even then, only with the minimum permissions needed.

For example, on my laptop, generally, the only permanently mounted partitions are the `boot` and `root` partitions. Additionally, while `${HOME}` is also on the `root` partition all the documents and folders, except my `Desktop`, are `symlinked` to either a separate partition for stuff that I will need even when travelling or to external drives for the bulk of the stuff like: *photos*. *videos*, *media*, *data*, *projects* and the *like*, which I only really need occasionally and would be an absolute utter disaster if I were to lose.

Anyway, `Hsr-PartitionMonitor` uses `fuser`to periodically check if a drive is currently in use. If not, and it is still not being used the next time it checks, then it will dismount it. This not only minimises the risks of general `snooping hacks`, but also the risks of a `ransom-ware` attack.

**Install-1:** Since both `fuser` and `umount` normally require `sudo` and the shell will either be tweaked to run from `auto-start` without user input, or, like mine, running as a service, (again without user input,) you need to add the following to `/etc/sudoers`

```
### Run without sudo
<YourUserName>     ALL=(ALL) NOPASSWD: /usr/local/bin/Hsr-PartitionMonitor
```

**Install-2:** Additionally, since it now has `root` privileges, to prevent attackers or un-privileged users using the shell as a backdoor, you need to change the permissions so that only `root` can edit it.

```
sudo chown root:root /usr/local/bin/Hsr-PartitionMonitor
sudo chmod o-rwx /usr/local/bin/Hsr-PartitionMonitor
```

**Install-3:** Although you won't be prompted for the password, you will still need to prepend the command with `sudo`, ie

```
sudo Hsr-PartitionMonitor
```
*For example:* [UserSystemd/Hs-PartitionMonitor.service](UserSystemd/Hs-PartitionMonitor.service)


#### Hs-MountReadWrite
The way my system is set up, when mounting partitions and disks, the file manager correctly asks for a password and mounts the drive read only. If I want to mount as read/write, then I would normally have to use `sudo mount sd? $mntpnt`, which I find to be a pain. With their own nested panel launchers, `Hs-MountReadWrite`, along with `Hs-UnMount`, create a menu of connected devices, and offer the choice between mounting the selected device as either `read only` or `read write`. This takes a great deal of the pain out of mounting and unmounting: *Usb's*, *partitions* and *external drives*.

While it is *cli* shell, it has all the features of a *GUI*, and makes mounting/unmounting devices straight forward. As a result, implementing a strict security policy with regard to partitions is not a major chore.


#### Hs-StatusWarnings
`Hs-StatusWarnings` is bash to nag you if various security related daemons, devices ... etc, are, as appropriate, *enabled/disabled*, *mounted/unmounted* ... *active/inactive*.

Generally, unless you have turned something off or on, you will never know it's their. Even then, the nagging is fairly low key with a little notification popping up periodical to remind you that the camera/microphone is *ON*, or that you have left a partition mounted with *write* permission. Personally, I have a low tolerance for annoyances, and this is just intrusive enough to be useful without becoming irritating.

