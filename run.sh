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

run="$cmd +set dedicated 2 +set fs_game $GAME +set rconpassword $RCONPASSWORD \
    +set sv_maxclients $MAXCLIENTS +set ettv_password $ETTVPASS \
    +set sv_hostname $HOSTNAME +map $MAP +config $cfg"

$run
