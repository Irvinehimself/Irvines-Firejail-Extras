# Security tools

### Overview
This section is focused on monitoring, general security and the tools to make it easier to adopt good habits. Since most of these shells run continuously in the background, as per my usual habit, I have included the necessary `systemd  unit files`. However, if `systemd` is not to your taste, with some minor tweaking you can run them from your `autostart` file or folder.

### Contents
  * [Hsr-PartitionMonitor](#hsr-partitionmonitor)
    * [Install](#install)
  * [Hs-MountReadWrite](#hs-mountreadwrite)
  * [Hs-StatusWarnings](#hs-statuswarnings)
  * [Polkit-Tweaks](#polkit-tweaks)
    * [49-custom-ask-for-rootpw.rules](#49-custom-ask-for-rootpw.rules)
    * [50-custom-mount-authority.rules](#50-custom-mount-authority.rules)
  * [Udisks2-Hardening](#udisks2-hardening)


### Hsr-PartitionMonitor
Dating back to the early days of the Pc, one of the simplest and most effective ways of protecting your personal data was to use partitions. Nowadays, very few people seem to realise that partitions should only be mounted on an *as-need* basis, and, even then, only with the minimum permissions needed.

For example, on my laptop, generally, the only permanently mounted partitions are the `boot` and `root` partitions. Additionally, while `${HOME}` is also on the `root` partition all the documents and folders, except my `Desktop`, are kept on either, a separate partition for stuff that I will need even when travelling, or external drives for the bulk of the stuff like: *photos*. *videos*, *media*, *data*, *projects* and the *like*, which I only really need occasionally and would be an absolute utter disaster if I were to lose.

Anyway, `Hsr-PartitionMonitor` uses `fuser`to periodically check if a drive is currently in use. If not, and it is still not being used the next time it checks, then it will dismount it. This not only minimises the risks of general `snooping hacks`, but also the risks of a `ransom-ware` attack.

#### Install
**Step-1:** Since both `fuser` and `umount` normally require `sudo` and the shell will either be tweaked to run from `auto-start` without user input, or, like mine, running as a service, (again without user input,) you need to add the following to `/etc/sudoers`

```
### Run without sudo
<YourUserName>     ALL=(ALL) NOPASSWD: /usr/local/bin/Hsr-PartitionMonitor
```

**Step-2:** Additionally, since it now has `root` privileges, to prevent attackers or un-privileged users using the shell as a backdoor, you need to change the permissions so that only `root` can edit it.

```
sudo chown root:root /usr/local/bin/Hsr-PartitionMonitor
sudo chmod o-rwx /usr/local/bin/Hsr-PartitionMonitor
```

**Step-3:** Although you won't be prompted for the password, you will still need to prepend the command with `sudo`, ie

```
sudo Hsr-PartitionMonitor
```
*For example:* [UserSystemd/Hs-PartitionMonitor.service](UserSystemd/Hs-PartitionMonitor.service)

[*Return to contents*](#contents)


### Hs-MountReadWrite
Properly set up, when mounting `partitions` and `disks`, the file manager should ask for a password before mounting a drive, (see *Polkit-Tweaks* below) But, if you are using `udisks2`, then how it mounts the drive is hard coded and not configurable by the user, [see below](#udisks2-hardening). If I could, I would get rid of `udisks`, but unfortunately its a dependency for too many things I actually need. As a consequence, if I want more direct control over how a drive is mounted, then I would normally have to use `sudo mount $options sd?? $mntpnt`, which I find to be a pain.

With their own nested panel launchers, `Hs-MountReadWrite`, (along with `Hs-UnMount`,) create a menu of connected devices, and offer the choice between mounting the selected device as either `read only` or `read/write`. This drastically reduces the hassle of mounting and un-mounting: *Usb's*, *partitions* and *external drives*.

While it is *cli* shell, `Hs-MountReadWrite` has all the features of a *GUI*, and makes mounting/unmounting devices straight forward. As a result, implementing a strict security policy with regard to partitions is not a major chore.

**Note:** By default, `Hs-MountReadWrite` mounts *drives* and *partitions* with the `noexec` flag set. From a security point of view, this is a really good idea, and unlikely to cause any major inconvenience,

[*Return to contents*](#contents)


### Hs-StatusWarnings
`Hs-StatusWarnings` is bash to nag you if various security related *daemons*, *devices*, ... *whatever*, are, as appropriate, *enabled/disabled*, *mounted/unmounted* ... *active/inactive*.

Generally, unless you have turned something off or on, you will never know it's their. Even then, the nagging is fairly low key with a little notification popping up periodical to remind you that *the camera/microphone is ON*; *the firewall is OFF*; *Firejail symlinks are DISABLED* ... *whatever*.

Personally, I have a low tolerance for annoyances, and this is just intrusive enough to be useful without becoming irritating.

[*Return to contents*](#contents)


### Polkit-Tweaks
I have included a couple of useful [polkit rules](EtcPolkitRules.d) which can be dropped into `/etc/polkit-1/rules.d/`

#### 49-custom-ask-for-rootpw.rules
This is a rule copied from the [Arch Wiki](https://wiki.archlinux.org/index.php/Polkit#Administrator_identities) which resolves one of those annoying discrepancies between `sudo` and `polkit` authorisation.

For example: To use sudo, I add my user name to `/etc/sudoers` like so:
```
########################################################
## User privilege specification
##
root ALL=(ALL) ALL
<YourUserName> ALL=(ALL) ALL

## Uncomment to allow members of group wheel to execute any command
# %wheel ALL=(ALL) ALL
```
*Noting how group wheel is still commented out*, unless you are *unwisely* logged in as `root`, with this method, the `sudo` password should not be the same as your `login` password.

Unfortunately, in Arch, the `polkit` rule `50-default.rules` defines all members of group `wheel` as administrators, which means your `login` password is also your `polkit` administrators password. Like most people, for practical reasons, my `login` password is moderately simple and common social niceties often mean allowing friends and family access to my laptop. This makes me very nervous. Rule `49-custom-ask-for-rootpw.rules` overrides rule `50-default.rules` and ensures that `polkit` prompts for my `root` password. This, of course, is an extremely complicated, randomly generated 300 character sequence :D, which is, hopefully, impossible to guess.

#### 50-custom-mount-authority.rules
Largely superseded by my Apparmor profile for `usr.lib.udisks2.udisksd`, this rule ensures only authorised users can mount *external drives*, *partitions* and *thumb drives*. See below for a fuller discussion.

[*Return to contents*](#contents)


### Udisks2-Hardening

`Udisks2` is a rabid, insane beast that should be taken out and shot. In fact, after [Stuxnet](https://en.wikipedia.org/wiki/Stuxnet#Operation), I suspect the Iranians would gladly provide the firing squad. The basic problem is that mount options are hard coded into [udiskslinuxfilesystem.c](https://cgit.freedesktop.org/udisks/tree/src/udiskslinuxfilesystem.c?id=aa02e5fc53efdeaf66047d2ad437ed543178965b). A quick google search will reveal at least two patches have been submitted two fix this, for example [here](http://lists.freedesktop.org/archives/devkit-devel/2015-April/001668.html).

Long story short, the developers do not really see any need to change the current setup. This causes a lot of problems, not only from the point of view of security, but also, as a very simple example, with `UTF8` encoding for non-English speakers.

As I pointed out above, if I could, I would get rid of `udisks2`. But, since I unfortunately need it as a `dependency`, I have struggled for over two weeks; scouring the internet; trying everything I can think of to try and gain some control how devices are mounted by my file manager and/or other applications.

Finally, by a painstaking process of logic and elimination, that's right: no blinding flash of insight or surge of desperation, but pure logical deduction, I came upon the perfect solution. It is so simple: If all the mount options are hard-coded, then simply modify the `usr.lib.udisks2.udisksd` Apparmor profile to deny `udiks2` any access to either `/run/media/` or `/media/`. Thus, when, for example, my file manger asks `udisks` to mount a *device* or *partition*, it tries and fails to create the mount point and I get a `permission denied` notification. As a result, mounts can only be controlled from [Hs-MountReadWrite](#hs-mountreadwrite).

If all this seems a bit OTT, just remember, not only do I now have control over whether a device is mounted *read only* or *read write*, but also, because of the `noexec` flag, if someone with access to my laptop plugs in a Usb contaminated with, for example, a variant of Stuxnet, it won't be able to automatically deliver it's payload. Further, since all my applications are, by default, sandboxed, even reading from the contaminated Usb with, say, Libre Office, would most likely result in a failure to deliver the payload.

[*Return to contents*](#contents)

