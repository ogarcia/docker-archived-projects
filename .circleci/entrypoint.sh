#! /bin/sh
#
# entrypoint.sh
# Copyright (C) 2023 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# Start xserver
export DISPLAY=:${XNUM}
Xvfb :${XNUM} -screen 0 ${XRES} -nolisten tcp &

# Wait for xserver
sleep 4

# Run NextCloud client
eval `dbus-launch --sh-syntax`
eval `echo '' | gnome-keyring-daemon -r -d --unlock --components=secrets`
nextcloud $@ &

# Run x11vnc
x11vnc -forever -passwd ${VNCPASS} -display :${XNUM}
