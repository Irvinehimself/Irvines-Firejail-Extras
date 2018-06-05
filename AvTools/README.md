# Anti-Virus tools

#### Overview
There is a common misconception that Linux is immune to malware, (I wish). In fact, since the vast majority of the worlds servers run on *\*nix* based systems, a Linux exploit is a potential goldmine. As a result, any self respecting, career orientated hacker who is thinking of that *private island* with no extradition treaty, will spend a great deal of time looking for that *special* Linux exploit.

Sadly, Linux is not well served with good quality, *free* antivirus products which reliably detect Linux malware. In [this](https://www.av-test.org/en/news/news-single-view/linux-16-security-packages-against-windows-and-linux-malware-put-to-the-test/) 2015 article, [AV-TEST](https://en.wikipedia.org/wiki/AV-TEST) summarises the test results for current Linux antivirus products. An article based on this summary is available [here](https://www.csoonline.com/article/2989137/linux/av-test-lab-tests-16-linux-antivirus-products-against-windows-and-linux-malware.html).

For economic reasons, (it's free,) I chose to go with [Sophos](https://www.sophos.com/en-us/products/free-tools/sophos-antivirus-for-linux.aspx). As to be expected, support is fairly minimal:
1. You have to compile it from source. (Not difficult, even for novices)
1. No *GUI*, it's controlled from the command line.
1. Once set up, it has automatic *on-access* scanning. Since this can, occasionally, be fairly resource intensive, it needs some tweaking to only run *on-access* scans of folders in ${HOME}

Anyway, this section of my project contains various shells to provide some common Window's features to Linux anti-virus products. Like I say, because it is free, I am using Sophos. If you can afford a paid subscription of another product, then you will need to tweak any line which calls `savscan`.

*Also:* My anti-virus shells use `notify-send` to communicate with the user. As a result. I make reference to icons like `Sophos.png`, `SophosClear.png` and `SophosAlert.png`. To avoid any possible copyright infringement, I am not distributing these icons and suggest you follow my lead and use `Gimp` to create your own icons.

Below is a summary of the shells I am currently using:

#### SophosAv--WatchDownloads
Unless I turn off my various security features, **ALL** of my browser downloads, uploads and torrents must go through the Download folder. `SophosAv--WatchDownloads` monitors that folder and detects when a download is finished. After which, it launches a **full** anti-virus scan of the completed download. For best results, it should be started either as a `service`, or through your `auto-start` file or folder.

For your convenience, I have included my `SophosAv--WatchDownloads.service` which should be placed in `${HOME}/.config/systemd/user/`. After which, of course, it should be enabled with `systemctl --user enable --now SophosAv--WatchDownloads.service`


*Note1:* When torrenting, multiple files can finish downloading at the same time, you have to give the scanner time to finish scanning all the files

#### ThunarAvScan
This shell provides *on-demand* scans of selected files through your file manager's *RMB* menu. The basic usage is to add `ThunarAvScan %f` to your file manager's context menu which, in Thunar, is easily achieved by going to Thunar's `Edit -> configure custom actions` menu.

*Note2:* Because `savscan` raises privileges, `seccomp` will kill it when Thunar is confined by it's Firejail sandbox.

The above caveat is not actually as big a problem as it might seem. For general file browsing, eg download folders and various work directories, I launch a sandboxed Thunar instance either from the panel or from desktop menus. Any directories I browse not only get an *on-access quick-scan*, but if I accidentally launch `something bad`, it will be confined by both the Thunar sandbox and the generic `firejail-default` AppArmor profile.

However, for system maintenance, using `key bindings`, I can launch either an un-sandboxed instance of Thunar, or even launch Thunar as `root`. At this point, the ability to launch a **full** antivirus scan of a suspicious file from the context menu becomes invaluable.

*Note3:* Even when *file-browsing* with un-sandboxed instances of Thunar, when you access a folder, `savscan` still launches a *quick-scan* of it's contents before any potential malware has a chance to be obnoxious.


