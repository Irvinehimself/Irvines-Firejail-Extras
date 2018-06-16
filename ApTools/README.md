# ApparmorTools


### Overview
Much like `FjTools`, this section contains extremely simple shells and wrappers for writing and maintaining Apparmor profiles. Going back to when I first started using Apparmor, they have their own menu launchers which means all the common Apparmor operations can be launched with a mouse click. While trivial, they are designed to make life easy.


### Hsa-ApparmorStatus
A simple shell to get the status of Apparmor and `grep` `dmesg` for messages containing either `AppArmor` or `Audit`


### Hsa-ReloadProfiles
As it says, a quick no muss no fuss way of reloading profiles matching a pattern


### Hsa-ComplainEnforce
Sets profiles matching a pattern to either `complain` or `enforce` mode, and then reloads them


### Hsa-EnableDisable
Enable or disable profiles matching a pattern, and then reloads them


### Hsa-ListDisabledProfiles
List disabled profiles


### Hsa-CreateFreshAppArmorProfile
Takes the drudgery out of starting new Apparmor profiles. It takes the path to an `executable` and creates an empty profile with it's  `site specific` customisation file. It also does housekeeping; for example, loading te profile and adding it to [AppArmor-ProfileList](Apparmor/AppArmor-ProfileList).


### Hsa-AaLogProf
A wrapper to run `aa-logprof` with a mouseclick

### Hsa-CleanProfList
Using [AppArmor-ProfileList](Apparmor/AppArmor-ProfileList), it creates a list of executable paths prepended with `sudo aa-cleanprof -d /etc/apparmor.d/`. While it echo's the output to the terminal window for quick copy pasting, it is also `tee-ed` to a file which can be used directly as an executable to run `aa-cleanprof` on **ALL** the profiles on the list. Again, although it is extremely trivial it really does cut down a lot of the drudge work.


### Hsa-Shared
Common functions used by `ApTools`
