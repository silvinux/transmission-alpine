# Transmission on Alpine Linux
## docker-transmission-alpine
Transmission daemon docker container based in a minimal Alpine linux, customized to run with specific user ID and group ID, to avoid permissions issues between host and container.

### On host you should create the folowing directory structure:

```
# mkdir /$HOME/Videos/{Downloads,Incomplete,Movies,TV_Shows}
# tree /$HOME/Videos/ -L 1
/$HOME/Videos
├── Downloads
├── Incomplete
├── Movies
└── TV_Shows
```
### Directory structure should belongs to user/group who access to downloaded files:

```
# ls -la /$HOME/Videos/
total 0
drwxrwxr-x. 3 user group 81 Dec  9 22:29 Downloads
drwxr-xr-x. 2 user group  6 Dec 10 13:16 Incomplete
drwxrwxr-x. 2 user group 70 Dec  3 17:43 Movies
drwxrwxr-x. 3 user group 31 Dec  9 23:53 TV_Shows

```

### Run the container:

```
    podman run --restart=always -d --name transmission \
    -p 51413:51413 -p 51413:51413/udp -p 127.0.0.1:9091:9091 \
    -e USERNAME=user -e ADMIN_PASS=password \
    -e PGID=1000 -e PUID=1000 \
    -v /$HOME/Videos/Downloads:/transmission/downloads \
    -v /$HOME/Videos/Incomplete:/transmission/incomplete \
    -v /$HOME/Videos/TV_Shows:/transmission/TV_Shows\
    transmission-alpine

```
#### Options:

```
--restart=always: Container will be persistent across reboots.
--name: Name of the container
-p ports to be exposed to host. If we want transmission web be reachable from anywhere change 127.0.0.1:9091:9091 to 9091:9091.
-e PGID=1000 -e PUID=1000: User and group ID running container and onwer of the files.
Volumes on host binding to container:
-v /$HOME/Videos/Downloads:/transmission/downloads \
-v /$HOME/Videos/Incomplete:/transmission/incomplete \
-v /$HOME/Videos/TV_Shows:/transmission/TV_Shows\

```

### Build image

- Set variable's values.
$ TUID=1313
$ TGID=1313
$ USERNAME=btannen
$ PASSWORD=biffco

- Build the image
$ podman build --tag alpine:transmission -f Dockerfile --build-arg TUID=${TUID} --build-arg TGID=${TGID} --build-arg USERNAME=${USERNAME} --build-arg PASSWORD=${PASSWORD}
