# Update scheduler

### Overview
As users of Arch Linux are aware, unlike mainline distros, Arch does not have an *Official* scheduler for updates. We are expected to be able to set up either `cronie` or `systemd` to achieve the task. Since keeping a system up-to-date is an essential part of hardening, I have included the `shells` and `timers` I use to solve the problem, and, as a bonus, the core of my system actually makes a useful *traditional* alarm-clock :)


### Hu-AlarmClockMusic
This is the point of entry for a `systemd` timer. It can take upto two optional parameters:
1. The message to be displayed by `notify-send`
1. An `mp3` formatted music sequence.

#### IMPORTANT:
1. If you are using it to launch a system update, then the `Mesg` parameter must contain the substring `Pacman`
1. The `timer`  *name*, (and it's related service,) must contain the substring `Alarm`
1. The `Music` *name* must contain the substring `Alarm`
*(see the examples in [UserSystemd](UserSystemd))*

*Tweaks: You will need to change the default `Music`, (which must be in the `mp3` format,) and the location of the icon for `notify-send`


### Hu-AlarmClockCntrl
This is the control unit from which you can either `sleep` or turn `off` alarms. Noting that this is meant to be run either from *keybindings* or a *panel launcher*, it takes an *Action* parameter ie `Hu-AlarmClockCntrl "sleep"` or `Hu-AlarmClockCntrl "sleep"`. The default is *off*

The `hard-coded` parameters `snooze` and `repeat` can be adjusted by editing the shell.
1. `snooze` governs the interval between `notify-send` *pop-ups* reminding you the alarm is sleeping
2. `repeat` governs how many *pop-ups* reminders you get before it restarts playing the *Music*


### Hu-PacmanSyu
Unless you use an Arch based distro, this wont be of much use without editing the line `sudo pacman -Syu`. Although I make no guarantees, I believe the equivalent on Ubuntu based distros is something like:
```
sudo -s -- <<EOF
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get autoremove -y
apt-get autoclean -y
EOF
```


### UserSystemd--Examples
Just a couple of example alarms to give you an idea how things work.

#### PacmanMorningAlarm
If you are unfamiliar with `systemd`, then it probably sounds stupid, but: The `timer` launches the `service` which launches `Hu-AlarmClockMusic`. Because the `Mesg` *"PacmanMorningAlarm"* contains the substring `Pacman`, `Hu-AlarmClockMusic` runs `sudo pacman -Syu` in a terminal ready for ypur *password*.

#### WeekDayAlarm
An example of using my system as a *traditional* alarm clock. Notice how, since the `Mesg` does not contain the substring `Pacman`, `Hu-AlarmClockMusic` does not run `sudo pacman -Syu`

#### Tips
When setting up an alarm, you can use `systemd-analyze calendar` to check the `OnCalendar` parameter is correctly formatted, see the *Tip section* [here](https://wiki.archlinux.org/index.php/Systemd/Timers#Realtime_timer) for an example.
