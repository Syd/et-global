#!/bin/bash

if [ "$GAME" = etpro ]; then
  cmd=./ettv.x86
  if [ "$NOQUERY" = 1 ]; then
    #cmd="LD_PRELOAD=libnoquery.so ./ettv.x86"
    export LD_PRELOAD="./libnoquery.so"
  fi
  cfg=global6
else
  cmd=./etlded
  cfg=legacy6
fi

run="$cmd +set dedicated 2 +set fs_game $GAME +set rconpassword $RCONPASS \
    +set sv_maxclients $MAXCLIENTS +set ettv_password $ETTVPASS \
    +set b_shoutcastpassword $SCPASS \
    +set sv_hostname $HOSTNAME +set g_password $JOINPASS +net_ip 0.0.0.0 \
    +set net_port $GAMEPORT \
    +set sv_wwwDownload “1” +set sv_wwwBaseURL $BASEURL +map $MAP \
    +set refereePassword $REFPASS +config $cfg"
$run
