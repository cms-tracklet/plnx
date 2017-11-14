DESCRIPTION = "PETALINUX image definition for Xilinx boards"
LICENSE = "MIT"

require recipes-core/images/petalinux-image-common.inc 

inherit extrausers
IMAGE_LINGUAS = " "

IMAGE_INSTALL = "\
		kernel-modules \
		i2c-tools \
		i2c-tools-misc \
		mtd-utils \
		procps \
		bash \
		util-linux-hwclock \
		util-linux-fdisk \
		canutils \
		openssh-sftp-server \
		less \
		pciutils \
		vim \
		python \
		run-postinsts \
		packagegroup-core-boot \
		packagegroup-core-ssh-dropbear \
		sysfsutils \
		tcf-agent \
		bridge-utils \
		gpio-demo \
		peekpoke \
		xvcServer \
		"
EXTRA_USERS_PARAMS = "usermod -P root root;"
