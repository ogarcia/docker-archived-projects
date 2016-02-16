#! /bin/bash
#
# entrypoint.sh
# Copyright (C) 2016 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the MIT license.
#


USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}
USER_NAME=${USER_NAME:-chrome}

create_user () {
  # create group for USER_NAME with USER_GID
  [[ ! $(getent group ${USER_NAME}) ]] && \
    groupadd -f -g ${USER_GID} ${USER_NAME}

  # create user for USER_NAME with USER_GID
  [[ ! $(getent passwd ${USER_NAME}) ]] && \
    useradd -u ${USER_UID} -g ${USER_GID} -s /bin/bash -o -m ${USER_NAME}

  # add USER_NAME to audio group if have audio device available
  [ -d /dev/snd ] && \
    chgrp -fR audio /dev/snd && \
    gpasswd -a ${USER_NAME} audio &> /dev/null
}

run_chrome () {
  su - ${USER_NAME} -c '/usr/bin/google-chrome --no-sandbox --make-default-browser'
  su - ${USER_NAME} -c '/usr/bin/google-chrome --no-sandbox'
}

# Exec CMD or Chrome if nothing present
if [ $# -gt 0 ];then
  exec "$@"
else
  create_user
  run_chrome
fi
