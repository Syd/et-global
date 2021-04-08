FROM debian:stable-slim as initial-build

ENV DEBIAN_FRONTEND noninteractive
RUN dpkg --add-architecture i386
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install libc6:i386 libstdc++6:i386
RUN useradd -ms /bin/bash game
RUN chown game:game /home/game

# reset user perms
USER root
RUN mkdir -p /home/game/tmp/legacy/configs
RUN chown -R game:game /home/game

FROM initial-build as downloads
RUN apt-get -y install wget unzip

# do downloading as the user and at the top so changes don't require us to
# constantly redownload everything
USER game
WORKDIR /home/game/tmp
RUN wget http://files.games.scrimfind.org/et.tar
RUN wget https://www.etlegacy.com/download/file/257 -O etlegacy.tar.gz
RUN mkdir -p legacy/configs .etmain .etlegacy
WORKDIR /home/game/tmp/legacy/configs
RUN wget https://raw.githubusercontent.com/etlegacy/etlegacy/099bf245a638ffbccfde60ffc582cd48f5086e3a/etmain/configs/legacy1.config
RUN wget https://raw.githubusercontent.com/etlegacy/etlegacy/099bf245a638ffbccfde60ffc582cd48f5086e3a/etmain/configs/legacy3.config
RUN wget https://raw.githubusercontent.com/etlegacy/etlegacy/099bf245a638ffbccfde60ffc582cd48f5086e3a/etmain/configs/legacy5.config
RUN wget https://raw.githubusercontent.com/etlegacy/etlegacy/099bf245a638ffbccfde60ffc582cd48f5086e3a/etmain/configs/legacy6.config
WORKDIR /home/game/tmp
RUN tar -xvf et.tar && tar -xvf etlegacy.tar.gz && cp -R etlegacy-v2.77.1-i386/* . && rm et.tar && rm etlegacy.tar.gz && rm -rf etlegacy-v2.77..11-i386

# drop execute and write permissions
USER root
RUN chmod 444 *
RUN chown -R root:game *

FROM initial-build as game
USER game
WORKDIR /home/game
COPY --from=downloads /home/game/tmp/ .
RUN rm -rf tmp

# make the game binaries executable again
USER root
RUN chmod +x ettv.x86 etlded
RUN chmod g+x etmain legacy pb etpro
RUN rm -rf /var/lib/apt/lists/*
RUN rm *.sh

# and now the final base to build from
FROM game as final
USER game

ENV GAME etpro
ENV MAP oasis
ENV JOINPASS ""
ENV RCONPASS changeme
ENV ETTVPASS 3ttv
ENV MAXCLIENTS 24
ENV HOSTNAME EThost
ENV NOQUERY 1
ENV BASEURL "https://www.gamestv.org/download/repository/et/etmain/"
ENV REFPASS ""
ENV SCPASS ""

ADD run.sh run.sh
USER root
RUN chmod +x run.sh
USER game

CMD ./run.sh
# TODO HEALTHCHECK via rcon
