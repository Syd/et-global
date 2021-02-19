FROM debian:stable-slim as initial-build

ENV DEBIAN_FRONTEND noninteractive
RUN dpkg --add-architecture i386
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install wget unzip libc6:i386 libstdc++6:i386
RUN useradd -ms /bin/bash game

WORKDIR /home/game/ettv
RUN mkdir -p /home/game/ettv /home/game/legacy/legacy/configs
RUN chown -R game:game /home/game

USER game
# download the original game server
RUN wget https://storage.syd.cloud.ovh.net/v1/AUTH_470b321eceba40249ca54db2d9935c32/et/et.tar
RUN tar -xvf et.tar
RUN rm -rf et.tar
RUN rmdir .etwolf
RUN ln -s ./ettv.x86 server

# grab etlegacy
WORKDIR /home/game/legacy
RUN wget https://www.etlegacy.com/download/file/122 -O etlegacy.tar.gz
RUN tar -xvf etlegacy.tar.gz
RUN rm -rf etlegacy.tar.gz
RUN cp -R etlegacy-v2.76-i386/* .
RUN rm -rf etlegacy-v2.76-i386

USER root
# remove the legacy etmain folder and symbolic link
# it to save space.
RUN rm -rf etmain
RUN ln -s ../ettv/etmain
RUN ln -s ../ettv/etpro
RUN ln -s ./etlded server

USER game
WORKDIR /home/game/legacy/legacy/configs
RUN wget https://raw.githubusercontent.com/etlegacy/etlegacy/099bf245a638ffbccfde60ffc582cd48f5086e3a/etmain/configs/legacy1.config
RUN wget https://raw.githubusercontent.com/etlegacy/etlegacy/099bf245a638ffbccfde60ffc582cd48f5086e3a/etmain/configs/legacy3.config
RUN wget https://raw.githubusercontent.com/etlegacy/etlegacy/099bf245a638ffbccfde60ffc582cd48f5086e3a/etmain/configs/legacy5.config
RUN wget https://raw.githubusercontent.com/etlegacy/etlegacy/099bf245a638ffbccfde60ffc582cd48f5086e3a/etmain/configs/legacy6.config

USER root
# lets check all our permissions
WORKDIR /home/game/
RUN chmod 744 -R ettv
RUN chmod 744 -R legacy
RUN chmod +x ettv/ettv.x86
RUN chmod +x legacy/etlded
RUN chown game:game ettv legacy
RUN chown -R root:root ettv/* legacy/*
RUN chown game:game ettv/etmain ettv/etpro legacy/legacy
RUN chown -h game:game legacy/etmain
RUN chown -h game:game legacy/etpro
RUN chown -h game:game ettv/server
RUN chown -h game:game legacy/server

# pull the standard match configs from the etlegacy team
USER game
WORKDIR /home/game/
RUN mkdir .etwolf
RUN mkdir .etlegacy

FROM initial-build
ENV TYPE ettv
ENV GAME etpro
ENV HOSTNAME ETHost
ENV RCONPASSWORD changeme
ENV MAXCLIENTS 24
ENV ETTV_PASSWORD 3ttv
ENV STARTMAP oasis

CMD cd $TYPE && ./server +set dedicated 2 +set fs_game $GAME +set sv_hostname $HOSTNAME +set rconpassword $RCONPASSWORD +set sv_maxclients $MAXCLIENTS +set ettv_password $ETTV_PASSWORD +config legacy6 +config global6 +map $STARTMAP

#CMD ./ettv.x86 +set fs_game etpro \
#    +set dedicated 2 \
#    +set sv_hostname $SERVERNAME \
#    +set fs_home ~/.etwolf \
#    +set rconpassword $RCONPASSWORD \
#    +set sv_maxclients $MAXCLIENTS \
#    +set ettv_password $ETTV_PASSWORD \
#    +config global6 \
#    +map $MAP
