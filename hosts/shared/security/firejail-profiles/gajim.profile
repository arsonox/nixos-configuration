noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.cache/gajim
noblacklist ${HOME}/.config/gajim
noblacklist ${HOME}/.local/share/gajim

mkdir ${HOME}/.gnupg
mkdir ${HOME}/.cache/gajim
mkdir ${HOME}/.config/gajim
mkdir ${HOME}/.local/share/gajim
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.cache/gajim
whitelist ${HOME}/.config/gajim
whitelist ${HOME}/.local/share/gajim
whitelist ${HOME}/Downloads

# Network access
netfilter

# D-Bus for Gajim functionality
dbus-user filter
dbus-user.own org.gajim.Gajim
dbus-user.talk org.freedesktop.Notifications
dbus-user.talk org.freedesktop.secrets
dbus-user.talk ca.desrt.dconf
dbus-user.talk org.kde.StatusNotifierWatcher
dbus-user.talk com.canonical.indicator.application
dbus-user.talk org.ayatana.indicator.application
dbus-system filter
dbus-system.talk org.freedesktop.login1

# Basic protections
caps.drop all
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp