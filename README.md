This repo is dedicated to provide some patches to bootstrap Alpine Linux for s390x architecture.

It uses existed work from Alpine developers at : http://dev.alpinelinux.org/~tteras/bootstrap/

-------

The current/experimental Alpine Linux s390x Docker image now have musl, gcc, shell (busybox) and some other packages.

To run the Docker image, download ```alpine-s390x.tar.xz``` file, import it and run :

```
$ docker run -ti alpine:s390x /lib/ld-musl-s390x.so.1 /usr/bin/gcc -dumpmachine

$ docker run -ti alpine:s390x /lib/ld-musl-s390x.so.1 /usr/bin/gcc -v

$ docker run -ti alpine:s390x /lib/ld-musl-s390x.so.1 /bin/busybox echo Hello World!

$ docker run -ti alpine:s390x /lib/ld-musl-s390x.so.1 /bin/sh
```
-------

To keep track of current/experimental Alpine Linux porting system and specifically s390x port, please check out :

http://lists.alpinelinux.org/alpine-devel/5427.html
http://lists.alpinelinux.org/alpine-devel/5386.html
