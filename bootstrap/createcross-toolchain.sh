#!/bin/sh

set -x

export TARGET_ARCH=s390x
export ABUILD_CREATECROSS_CONF=$PWD/abuild-createcross-$TARGET_ARCH.conf
export ABUILD_CROSSBUILD_CONF=$PWD/abuild-crossbuild-$TARGET_ARCH.conf
export APORTS=$HOME/s390x/aports

CBUILDROOT="$(source $ABUILD_CREATECROSS_CONF ; echo $CBUILDROOT)"
CTARGET="$(source $ABUILD_CREATECROSS_CONF ; echo $CTARGET)"
REPODEST_HOST="$(source $ABUILD_CREATECROSS_CONF ; echo $REPODEST)"
REPODEST_TARGET="$(source $ABUILD_CROSSBUILD_CONF ; echo $REPODEST)"

if [ -z "$CBUILDROOT" ]; then
	echo "CBUILDROOT needs to be set in $ABUILD_CREATECROSS_CONF."
	exit 1
fi

# Prepare local build environment
abuild-apk add build-base gcc-gnat

# Step 1. Build binutils (--with-sysroot)
#
cd $APORTS/main/binutils
ABUILD_CONF=$ABUILD_CREATECROSS_CONF abuild -r || return 1
abuild-apk --repository $REPODEST_HOST/main add binutils-$CTARGET || return 1

cd $APORTS/main/musl
# CARCH=$TARGET_ARCH
ABUILD_CONF=$ABUILD_CROSSBUILD_CONF abuild up2date
if [ $? -ne 0 ]; then
	# Step 2. Install kernel headers for target
	# Step 3. Pass1 GCC for C-headers (--with-newlib --without-headers)
	# musl does not need GCC for headers installation, skipped step.
	# ABUILD_CONF=$ABUILD_CREATECROSS_CONF BOOTSTRAP=noheaders abuild

	# Step 4. C-library headers for target
	#
	cd $APORTS/main/musl
	# CARCH=$TARGET_ARCH
	ABUILD_CONF=$ABUILD_CROSSBUILD_CONF abuild unpack prepare install_sysroot_headers || return 1

	# Step 5. Pass2 GCC for C-library (--with-newlib --enable-threads=no --disable-bootstrap)
	#
	cd $APORTS/main/gcc
	# CTARGET_ARCH=$TARGET_ARCH
	ABUILD_CONF=$ABUILD_CREATECROSS_CONF BOOTSTRAP=nolibc CTARGET_LIBC=musl abuild -r || return 1

	# Step 6. C-library
	abuild-apk --repository $REPODEST_HOST/main add gcc-pass2-$CTARGET || return 1
	cd $APORTS/main/musl
	# tmh  CARCH=$TARGET_ARCH if we add this, cant sign the index
	# CTARGET_LIBC=musl
	ABUILD_CONF=$ABUILD_CROSSBUILD_CONF BOOTSTRAP=noutils abuild || return 1
	abuild-apk del gcc-pass2-$CTARGET
fi

# Step 7. Final GCC for target
sudo mkdir -p "$CBUILDROOT/etc/apk/keys"
sudo cp -a /etc/apk/keys/* "$CBUILDROOT/etc/apk/keys"
#cd $REPODEST_TARGET/main
#ln -s unknown $TARGET_ARCH
#cd -
abuild-apk --initdb --repository "$REPODEST_TARGET/main" --root "$CBUILDROOT" --arch "$TARGET_ARCH" add musl-dev || return 1

cd $APORTS/main/gcc
# CTARGET_ARCH=$TARGET_ARCH 
ABUILD_CONF=$ABUILD_CREATECROSS_CONF CTARGET_LIBC=musl abuild -r || return 1

# Step 8. Clean abuild mess.
mv $REPODEST_HOST/main/*/lib*apk $REPODEST_TARGET/main/$TARGET_ARCH
rm $REPODEST_TARGET/main/$TARGET_ARCH/musl-*
ABUILD_CONF=$ABUILD_CREATECROSS_CONF abuild update_abuildrepo_index
ABUILD_CONF=$ABUILD_CROSSBUILD_CONF  abuild update_abuildrepo_index

# Done. Toolchain with C-library and GCC helper libs for target done.

