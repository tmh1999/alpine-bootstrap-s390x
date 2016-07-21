#!/bin/sh

TARGET_ARCH=aarch64

export ABUILD_CREATECROSS_CONF=$PWD/abuild-createcross-$TARGET_ARCH.conf
export ABUILD_CONF=$PWD/abuild-crossbuild-$TARGET_ARCH.conf
export APORTS=$HOME/aports

SUDO_APK=abuild-apk
CBUILDROOT="$(source $ABUILD_CONF ; echo $CBUILDROOT)"
CTARGET="$(source $ABUILD_CONF ; echo $CTARGET)"
REPODEST="$(source $ABUILD_CONF ; echo $REPODEST)"
REPODEST_HOST="$(source $ABUILD_CREATECROSS_CONF ; echo $REPODEST)"
PACKAGER_PRIVKEY="$(source ~/.abuild/abuild.conf ; echo $PACKAGER_PRIVKEY)"

if [ -z "$CBUILDROOT" ]; then
	echo "CBUILDROOT needs to be set in $ABUILD_CONF."
	exit 1
fi

# remove possible old pass2 gcc
${SUDO_APK} del gcc-pass2-$CTARGET

# implicit build dependencies for bootstrapping
${SUDO_APK} add gcc-gnat
${SUDO_APK} --repository $REPODEST_HOST/main add gcc-$CTARGET g++-$CTARGET gcc-gnat-$CTARGET || return 1

# initialize build root (copy packager's key)
mkdir -p "${CBUILDROOT}" "${CBUILDROOT}/etc/apk/keys" "${CBUILDROOT}/lib"
cp -f ${PACKAGER_PRIVKEY}.pub ${CBUILDROOT}/etc/apk/keys
sudo sh -c "echo $REPODEST/main > ${CBUILDROOT}/etc/apk/repositories"
${SUDO_APK} --quiet --arch "$TARGET_ARCH" --root "$CBUILDROOT" --initdb add
${SUDO_APK} --root "$CBUILDROOT" add libgcc libstdc++ #libgnat

# optional parts
KERNEL_PKG="linux-firmware linux-vanilla"
#DEBUG_PKG="ncurses gdb"

# ordered cross-build
for PKG in fortify-headers linux-headers musl libc-dev \
	   busybox busybox-initscripts binutils make pkgconf \
	   zlib openssl libfetch apk-tools \
	   gmp mpfr3 mpc1 isl cloog gcc \
	   openrc alpine-conf alpine-baselayout alpine-keys alpine-base build-base \
	   attr libcap patch sudo acl fakeroot tar \
	   pax-utils abuild openssh \
	   ncurses util-linux lvm2 popt xz cryptsetup kmod lddtree mkinitfs \
	   $KERNEL_PKG $DEBUG_PKG ; do

	cd $APORTS/main/$PKG
	BOOTSTRAP=bootimage abuild -r || exit 1

	case "$PKG" in
	fortify-headers | libc-dev)
		# install libc-dev, as implicit but mandatory dependency
		${SUDO_APK} -u --root "$CBUILDROOT" add libc-dev || exit 1
		;;
	esac
done

