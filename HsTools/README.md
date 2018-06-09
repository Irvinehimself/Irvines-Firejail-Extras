# Security tools

### Overview
This section is focused on monitoring, general security and the tools to make it easier to adopt good habits. Since most of these shells run continuously in the background, as per my usual habit, I have included the necessary `systemd  unit files`. However, if `systemd` is not to your taste, with some minor tweaking you can run them from your `autostart` file or folder.

### Hsr-PartitionMonitor
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


### Hs-MountReadWrite
When mounting `partitions` and `disks`, my file manager correctly asks for a password, but, by default, whether it mounts the drive `read only` or `read/write` depends on the drive and it's formatting. If I want more direct control over how a drive is mounted, then I would normally have to use `sudo mount sd?? $mntpnt`, which I find to be a pain.

With their own nested panel launchers, `Hs-MountReadWrite`, (along with `Hs-UnMount`,) create a menu of connected devices, and offer the choice between mounting the selected device as either `read only` or `read/write`. This drastically reduces the hassle of mounting and un-mounting: *Usb's*, *partitions* and *external drives*.

While it is *cli* shell, `Hs-MountReadWrite` has all the features of a *GUI*, and makes mounting/unmounting devices straight forward. As a result, implementing a strict security policy with regard to partitions is not a major chore.


### Hs-StatusWarnings
`Hs-StatusWarnings` is bash to nag you if various security related *daemons*, *devices*, ... *whatever*, are, as appropriate, *enabled/disabled*, *mounted/unmounted* ... *active/inactive*.

Generally, unless you have turned something off or on, you will never know it's their. Even then, the nagging is fairly low key with a little notification popping up periodical to remind you that *the camera/microphone is ON*; *the firewall is OFF*; *Firejail symlinks are DISABLED* ... *whatever*.

Personally, I have a low tolerance for annoyances, and this is just intrusive enough to be useful without becoming irritating.


### Polkit-Tweaks
I have included a couple of useful [polkit rules](EtcPolkitRules.d) which can be dropped into `/etc/polkit-1/rules.d/`

#### [50-custom-mount-authority.rules](EtcPolkitRules.d/50-custom-mount-authority.rules)
Is a rule to ensure only authorised users can mount *external drives*, *partitions* and *thumb drives*.

#### [49-custom-ask-for-rootpw.rules](EtcPolkitRules.d/49-custom-ask-for-rootpw.rules)
This is an example from the [Arch Wiki](https://wiki.archlinux.org/index.php/Polkit#Administrator_identities) which resolves one of those annoying discrepancies between `sudo` and `polkit` authorisation.

To use sudo, you should add your user name to `/etc/sudoers` like so:
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

Unfortunately, in Arch, the `polkit` rule `50-default.rules` defines all members of group `wheel` as administrators, which means your `login` password is also your `polkit` administrators password. Like most people, for practical reasons, my `login` password is moderately simple and common social niceties often mean allowing friends and family access to my laptop. This makes me very nervous. Rule `49-custom-ask-for-rootpw.rules` overrides rule `50-default.rules` and ensures that `polkit` prompts for my `root` password. This, of course, is an extremely complicated, randomly generated 30 character sequence, which is, hopefully, impossible to guess.
