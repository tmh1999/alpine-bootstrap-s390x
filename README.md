This repo is dedicated to provide patches to bootstrap Alpine Linux for s390x architecture.

-------
* Musl s390x status

musl s390x is merged upstream. Package musl-1.1.15.tar.gz is a clone from http://git.musl-libc.org/cgit/musl/, with 2 unmerged patches http://www.openwall.com/lists/musl/2016/11/15/2, http://www.openwall.com/lists/musl/2016/11/15/3.

-------
* Issues

1. Had to disable PaX while building native gcc. Same on Alpine aarch64. Looks like grsecurity does not support s390x. So we stick with vanilla flavor.
2. Cross-compiling linux-vanilla still fails. Needed for building kernel image (or ISO image).

-------
* Patches

Most patches in patches/aports are already merged in Alpine's upstream tree.

-------
* Docker

To run :
```
$ docker run -ti tmh1999/alpine-s390x gcc -v

$ docker run -ti tmh1999/alpine-s390x ping google.com
```

To get list of current supported Alpine s390x packages (more will come) : 
```
$ docker run -ti tmh1999/alpine-s390x apk info
```
( also can be found in [packages.list] [packages.list.url])

This Docker image contains some heavy packages, making it 160MB++ and 50++MB when compressed.

-------
* More infomation

To keep track of current/experimental Alpine Linux porting system and specifically s390x port, please check out :

http://lists.alpinelinux.org/alpine-devel/5427.html

http://lists.alpinelinux.org/alpine-devel/5386.html


[packages.list.url]: https://github.com/tmh1999/alpine-bootstrap-s390x/blob/master/packages.list

