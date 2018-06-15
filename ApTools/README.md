# ApparmorTools


### Overview
Much like `FjTools`, this section contains simple shells for writing and maintaining Apparmor profiles which I use on a daily basis. While trivial, they are designed to make life easy, with the basics going back to when I first started using Apparmor.


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
A simple shell I wrote to take the drudgery out of starting new Apparmor profiles. If I give it the path to the `executable` I want to confine, it creates an empty profile; of the correct name; set in complain mode, along with the local `site specific` customisation file and appends the profile name to [AppArmor-ProfileList](Apparmor/AppArmor-ProfileList). Finally, it loads the profile so that, when I am ready, I only need to run `aa-logprof` to start filling it in.


### Hsa-GetCleanProfList
Basically, this takes the [AppArmor-ProfileList](Apparmor/AppArmor-ProfileList) and uses it to get a list of executable paths prepended with `sudo aa-cleanprof -d /etc/apparmor.d/`. The resulting file can either be used directly as an executable to run `aa-cleanprof` on **all** my Apparmor profiles, or used to copy paste the relevant line for a specific profile. While it is extremely trivial it does cut down a lot of the drudge work.


### Hsa-Shared
Common functions used by `ApTools`
