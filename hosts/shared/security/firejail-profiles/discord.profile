noblacklist ${HOME}/.config/discord

mkdir ${HOME}/.config/discord
whitelist ${HOME}/.config/discord
whitelist ${HOME}/Downloads

# Network access
netfilter

# D-Bus notifications and screen sharing
dbus-user filter
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.portal.Desktop
dbus-user.talk org.freedesktop.portal.Documents
dbus-user.talk org.freedesktop.portal.ScreenCast
dbus-user.talk org.freedesktop.portal.RemoteDesktop
dbus-user.talk org.freedesktop.portal.Camera

# D-Bus system tray
dbus-user.talk org.kde.StatusNotifierWatcher

# Allow video devices for webcam and capture cards
noblacklist /dev/video*
noblacklist /sys/devices
noblacklist /sys/class/video4linux
read-only /sys/devices
read-only /sys/class/video4linux

# Allow audio devices for microphone and audio input
noblacklist /dev/snd

# PipeWire support for media streaming
noblacklist /run/user/*/pipewire-*
noblacklist /dev/dri

# Additional device access for capture cards
noblacklist /dev/media*
noblacklist /dev/v4l-subdev*
noblacklist /sys/bus
noblacklist /sys/dev
read-only /sys/bus
read-only /sys/dev

# Basic protections
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp