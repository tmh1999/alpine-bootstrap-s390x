This repo is dedicated to provide some patches to bootstrap Alpine Linux for s390x architecture.

-------
Patches

See patches/aports

-------
Docker

The current/experimental Alpine Linux s390x Docker image now have musl, gcc, shell (busybox) and some other packages.

To run the Docker image, download ```alpine-s390x.tar.xz``` file, import it or pull from Docker hub :

```
$ docker pull tmh1999/alpine-s390x

$ docker tag tmh1999/alpine-s390x alpine:s390x
```

Then run :

```
$ docker run -ti alpine:s390x /lib/ld-musl-s390x.so.1 /usr/bin/gcc -dumpmachine

$ docker run -ti alpine:s390x /lib/ld-musl-s390x.so.1 /usr/bin/gcc -v

$ docker run -ti alpine:s390x /lib/ld-musl-s390x.so.1 /bin/busybox cat /etc/os-release
```
-------

To keep track of current/experimental Alpine Linux porting system and specifically s390x port, please check out :

http://lists.alpinelinux.org/alpine-devel/5427.html
http://lists.alpinelinux.org/alpine-devel/5386.html
