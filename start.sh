#!/bin/bash
set -x
GROUP=plextmp

mkdir -p /config/logs/supervisor

touch /supervisord.log
touch /supervisord.pid
chown plex: /supervisord.log /supervisord.pid

# Get the proper group membership, credit to http://stackoverflow.com/a/28596874/249107

TARGET_GID=$(stat -c "%g" /data)
EXISTS=$(cat /etc/group | grep ${TARGET_GID} | wc -l)

# Create new group using target GID and add plex user
if [ $EXISTS = "0" ]; then
  groupadd --gid ${TARGET_GID} ${GROUP}
else
  # GID exists, find group name and add
  GROUP=$(getent group $TARGET_GID | cut -d: -f1)
  usermod -a -G ${GROUP} plex
fi

usermod -a -G ${GROUP} plex

if [[ -z "${SKIP_CHOWN_CONFIG}" ]]; then
  CHANGE_CONFIG_DIR_OWNERSHIP=false
fi

if [ "${CHANGE_CONFIG_DIR_OWNERSHIP}" = true ]; then
  find /config ! -user plex -print0 | xargs -0 -I{} chown -R plex: {}
fi

# Will change all files in directory to be readable by group
if [ "${CHANGE_DIR_RIGHTS}" = true ]; then
  chgrp -R ${GROUP} /data
  chmod -R g+rX /data
fi

# Current defaults to run as root while testing.
if [ "${RUN_AS_ROOT}" = true ]; then
  /usr/sbin/start_pms
else
  sudo -u plex -E sh -c "/usr/sbin/start_pms"
fi