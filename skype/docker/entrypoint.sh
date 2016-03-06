#! /bin/bash
#
# entrypoint.sh
# Copyright (C) 2016 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the MIT license.
#


USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}
USER_NAME=${USER_NAME:-skype}

create_user () {
  # create group for USER_NAME with USER_GID
  [[ ! $(getent group ${USER_NAME}) ]] && \
    groupadd -f -g ${USER_GID} ${USER_NAME}

  # create user for USER_NAME with USER_GID
  [[ ! $(getent passwd ${USER_NAME}) ]] && \
    useradd -u ${USER_UID} -g ${USER_GID} -s /bin/bash -o ${USER_NAME}

  # create home dir and fix permissions
  mkdir -p /home/${USER_NAME}
  chown -R ${USER_UID}:${USER_GID} /home/${USER_NAME}
}

configure_user() {
  # small fix to have much better fonts
  mkdir /home/${USER_NAME}/.config
  cat > /home/${USER_NAME}/.config/Trolltech.conf << EOF
[Qt]
font="Cantarell,11,-1,5,50,0,0,0,0,0"
EOF
  chown ${USER_UID}:${USER_GID} /home/${USER_NAME}/.config/Trolltech.conf
}

grant_access_to_video_devices() {
	for device in /dev/video*
	do
    if [[ -c $device ]]; then
      VIDEO_GID=$(stat -c %g $device)
      VIDEO_GROUP=$(stat -c %G $device)
      if [[ ${VIDEO_GROUP} == "UNKNOWN" ]]; then
        VIDEO_GROUP=skypevideo
        groupadd -g ${VIDEO_GID} ${VIDEO_GROUP}
      fi
      usermod -a -G ${VIDEO_GROUP} ${USER_NAME}
      break
    fi
  done
}

run_skype() {
  su - ${USER_NAME} -c "PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM=native skype ${ARGS}"
}

# Exec CMD or Chrome if nothing present
if [ $# -gt 0 ];then
  exec "$@"
else
  create_user
	configure_user
	grant_access_to_video_devices
  run_skype
fi
