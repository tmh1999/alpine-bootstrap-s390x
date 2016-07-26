This repo is dedicated to bootstrap Alpine for s390x architecture.

It heavily uses existed work from Alpine developers at : http://dev.alpinelinux.org/~tteras/bootstrap/

-------

The current Docker image only have musl, gcc and some other packages. Busybox is broken for now (which means shell is broken).
To run the Docker image:

$ docker run -ti alpine /lib/ld-musl-s390x.so.1 /usr/bin/gcc -dumpmachine

$ docker run -ti alpine /lib/ld-musl-s390x.so.1 /usr/bin/gcc -v

