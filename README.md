# et-global
a hybrid wolfenstein enemy territory server container


## tl;dr quick run

```sh
docker run -it -d -p 27960:27960/udp -e GAME=etpro -e JOINPASS=joinme \
-e HOSTNAME="etpro server" -e RCONPASS="rcon-pass" sydz/et:latest
```

### environment variables

#### GAME
default: `etpro`
uses the ettv binaries by default, use `legacy` for a legacy server

#### MAP
default: `oasis`
map to load on startup


#### JOINPASS
default: none
password for players to join


#### RCONPASS
default: `changeme`
you should *definitely* change this

#### ETTVPASS
default: `3ttv`
password required for an ETTV slave to connect

#### MAXCLIENTS
default: `24`
number of player slots

#### HOSTNAME
default: `EThost`
the name of the server

#### NOQUERY
default: `1`
injects the noquery library, your server will no longer appear on the master list
etpro *only*.

#### BASEURL 
default: `http://www.gamestv.org/download/repository/et`
your http download url

#### REFPASS
default: none
password to log in as a referee

#### SCPASS
default: none
password to log in as a shoutcaster


## extending
this image is intended to serve as a base image to extended via a multi-stage
Dockerfile with your own maps, configs, mods, etc.


### example

``` dockerfile
FROM sydz/et:latest

COPY etmain/*.pk3 /home/game/etmain/
WORKDIR /home/game/
```

## todo
- ettv slaves + flags
- support running as an ettv slave
