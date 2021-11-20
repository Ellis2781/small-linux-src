default: all
ROOTFS=${PWD}
PACKAGES=${PWD}/packages

all: configure build install

configure:
	cd packages/musl/ && ./configure --prefix=${ROOTFS}/usr
	cd packages/nano/ && ./configure --prefix=${ROOTFS}/usr --target=gnu-linux
	cd packages/git/ && autoconf
	cd packages/git/ && ./configure --prefix=${ROOTFS}/usr --target=gnu-linux
build:
	cmake CMAKE_INSTALL_PREFIX=${PWD}/usr packages/BSDCoreUtils
	make -C packages/BSDCoreUtils
	make -C packages/git
	cd packages/ksh && bin/package make
	make -C packages/musl
	make -C packages/nano
	make -C packages/pkg
install:
	cp ${PACKAGES}/ksh/arch/linux.i386-64/bin/ksh ${ROOTFS}/usr/bin
	cd packages/musl/ && make install
	cd packages/nano/ && make install
	cd packages/git/ && make install
	make -C packages/BSDCoreUtils install
