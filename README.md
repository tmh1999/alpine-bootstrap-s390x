This repo is dedicated to provide patches to bootstrap Alpine Linux for s390x architecture.

-------
Status

- musl s390x is merged upstream. 2 small fixes still need review. Package musl-1.1.15.tar.gz is a clone from http://git.musl-libc.org/cgit/musl/, with 2 unmerged patches http://www.openwall.com/lists/musl/2016/11/15/2, http://www.openwall.com/lists/musl/2016/11/15/3. Need to package it so we do not need to edit musl's APKBUILD too much.

-------
Bugs

1. PaX on cross gcc still not work, had to disable.
2. Cross-compiling linux-vanilla still fails.

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
