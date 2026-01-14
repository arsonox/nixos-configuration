noblacklist ${HOME}/.config/mpv
noblacklist ${HOME}/.cache/mpv

mkdir ${HOME}/.config/mpv
mkdir ${HOME}/.cache/mpv
whitelist ${HOME}/.config/mpv
whitelist ${HOME}/.cache/mpv
whitelist ${HOME}/Downloads
whitelist ${HOME}/Videos
whitelist ${HOME}/Music

# Network access for streaming
netfilter

# Hardware acceleration and video output
noblacklist /dev/dri
noblacklist /dev/video*
noblacklist /sys/devices
noblacklist /sys/class/video4linux
read-only /sys/devices
read-only /sys/class/video4linux

# Audio devices
noblacklist /dev/snd

# PipeWire support
noblacklist /run/user/*/pipewire-*

# D-Bus for MPRIS and notifications
dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.mpris.MediaPlayer2.*

# Basic protections
caps.drop all
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp