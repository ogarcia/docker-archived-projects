#! /bin/sh
#
# entrypoint.sh
# Copyright (C) 2023 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# Work in a loop
while true; do
  # Perform sync
  nextcloudcmd $@
  # Sleep a minute
  sleep 60
done
