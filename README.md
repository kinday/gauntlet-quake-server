# Gauntlet Quake Server

Simply put, this is just a `Dockerfile` that will build a container with ioquake3 dedicated server, point release update and bare OSP Tourney Q3A mod installed.

Beware that there’s no server configuration provided whatsoever, if you need an easy way to start, download full OSP Toruney Q3A mod an mount its default configuration as described below.

## Usage

### Mounts

At minimum following files must be mounted:

- `pak0.pk3` file. The server will not start without it. See [ioquake3 help](https://ioquake3.org/help/players-guide/#syserror) for more details.
- Configuration for either base game (`/opt/ioq3/.q3a/baseq3`) or OSP mod (`/opt/ioq3/.q3a/osp`) or both.

### Ports

Unless your configuration changes default port (via `net_port` cvar) the server uses UDP port 27960.

### Command

By default server will work in private mode and will start `q3dm1` as map. This can be altered as necessary.

### Example

Assuming following file structure on host machine:

```
/
└── home/
    └── user/
        └── quake-configs/
            ├── baseq3/
            │   ├── pak0.pk3
            │   ├── autoexec.cfg
            │   └── ...
            └── osp/
                ├── ffa.cfg
                ├── ffa-maps.txt
                └── ...
```

Assuming configuration does not alter `net_port`, we want to start public OSP server and use `ffa.cfg` as starting config.

Correct `docker run` command would be:

```sh
docker run \
  --publish 27960:27960/udp \
  --volume /home/user/quake-configs:/opt/ioq3/.q3a \
  ghcr.io/kinday/gauntlet-quake-server:latest \
  +set dedicated 2 +set fs_game osp +exec ffa.cfg
```
