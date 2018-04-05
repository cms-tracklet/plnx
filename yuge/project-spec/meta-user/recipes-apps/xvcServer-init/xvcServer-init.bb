#
# This file is the xvcServer-init recipe.
#

SUMMARY = "Simple xvcServer-init application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://xvcServer-init \
	"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME= "xvcServer-init"
INITSCRIPT_PARAMS=" start 99 S . "

do_install() {
	     install -d ${D}${sysconfdir}/init.d
	     install -m 0755 ${S}/xvcServer-init ${D}${sysconfdir}/init.d/xvcServer-init
             update-rc.d -r ${D} xvcServer-init start 99 2 3 4 5 . stop 99 0 1 6 .
}


