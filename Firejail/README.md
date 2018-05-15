# Profiles and local customisations

## Contents
* [**Profiles**](#profiles)
* [**Local customisations**](#local-customisations)
  * [**Browsers and HDMI audio**](#browsers-and-hdmi-audio)


## Profiles
I intend to post any Firejail profiles I have written, along with my local customisations of upstream profiles. While several of my profiles have already been accepted for inclusion upstream, the majority have not yet been submitted, (Note: for reason that I will explain where appropriate, some profiles, while useful in the context of my hardening project, will never be submitted upstream).

For convenience, the file [Firejail-ProfilesNotYetSubmittedUpstream](https://github.com/Irvinehimself/Irvines-Hardening-Project/blob/master/Firejail/Firejail-ProfilesNotYetSubmittedUpstream) contains an an automatically updated list of all my unsubmitted `profiles`.

The following are my un-submitted `profiles` most likely to be of interest to a casual visitor:
```
epdfview.profile    : Restrictive and usable, but needs private-bin, private-etc and private-lib
Player.profile      : Restrictive and usable, but needs private-etc and private-lib
QMLPlayer.profile   : Restrictive and usable, but needs private-etc and private-lib
rsstail.profile     : Restrictive and usable, but needs private-etc and private-lib
showfoto.profile    : Basically a wrapper for the parent Digikam profile provided by upstream
```
*Note*: The above list of un-submitted profiles is a summary of what is most likely to be of interest, it is not an exhaustive list of my profiles.

*Further*: Both `profiles` and `local-customisations` are very much works in progress, so frequent updates are to be expected

[*Return to contents*](#contents)

## Local customisations
Currently, most of my local customisations are concerned with globally enabling apparmor confinement and/or disabling internet connectivity. However, I have recently started work on strengthening internet connected profiles. Mainly, this is to be achieved through creating whitelists for: `private-bin`, `private-lib`, `private-etc` and `private-opt`. The intention is to make these customisations **very** restrictive, while maintaining core functionality. For convenience, the file [`RestrictiveLocalCustomisations`](https://github.com/Irvinehimself/Irvines-Hardening-Project/blob/master/Firejail/Firejail-RestrictiveLocalCustomisations) contains an an automatically updated list of all my `local` customisations which **further restrict** upstream profiles.

The following are the `.local` customisations most likely to be of interest to a casual visitor:
```
inox.local        	: private-bin, private-etc, private-dev, caps.keep whitelist and more
opera.local       	: private-bin, private-etc, private-dev, caps.keep whitelist and more
firefox.local     	: private-bin, private-etc, private-dev, and private-lib (Tested with Firefox 57)
transmission-gtk.local  : private-lib, private-etc, private-opt, noexec ${HOME} and noexec /tmp
```
[*Return to contents*](#contents)

#### Browsers and HDMI audio
*Note*: This does not apply to jack-in speakers or headphones, but solely to HDMI audio output.

In my home setup, I mirror my laptop screen to my Tv and have a shell with launcher to toggle the audio output between the 'built-in' and 'HDMI' speakers. Unfortunately, for this to work when a browser is playing streaming media, `private-etc` needs to include the file [machine-id](https://www.freedesktop.org/software/systemd/man/machine-id.html). Since `/etc/machine-id` is a unique identifier, this constitutes a serious privacy threat, and, by default, my local customisations do not enable it. If you wish to switch between 'built-in' and 'HDMI' audio, (or use 'HDMI' audio for streaming media,) then you need to add `machine-id` to the end of the `private-etc` string.

Further, be warned, when`machine-id` is not present in `private-etc`, trying to toggle between the 'built-in' and 'HDMI' speakers **while playing streaming media**  will crash audio output for everything except the browser. On the other hand, if you are not currently playing streaming media, then you can toggle between the 'built-in' and 'HDMI' speakers with no ill effect, irrespective of whether the browser is open or not.

[*Return to contents*](#contents)

