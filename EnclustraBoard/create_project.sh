#! /bin/bash -ex

# Usage: ./create_project.sh <project_name>

# Prerequisites:
#  1. petalinux v2017.4 installed in /opt/petalinux
#  2. source /opt/petalinux/settings.sh
#  3. source /opt/petalinux/components/yocto/source/aarch64/environment-setup-aarch64-xilinx-linux
#  4. export PATH=/opt/petalinux/components/yocto/source/aarch64/layers/core/bitbake/bin:$PATH

#BASEDIR=/mnt/scratch/wittich/tracklet/firmware/TrackletProject/YUGE/BoardTest/Zynq2/MarsZX2_6089_101_revA
#I'm assuming that you're cwd is here
BASEDIR=`pwd`
HDW=${BASEDIR}/Vivado/Vivado_PM3/MarsZX2_PM3.sdk

DIR=$1
[ -d $DIR ] && (echo $DIR already exists; exit 1)


petalinux-create -t project --template zynq --name $1
cd $1
petalinux-config --get-hw-description=${HDW}

##Removed because ubuntu doesn't know what "konsole" is
cat >> project-spec/meta-user/conf/petalinuxbsp.conf <<EOF
OE_TERMINAL = "konsole"
EOF


# EDIT such that the device tree file looks like this
cat > project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi <<EOF
/include/ "system-conf.dtsi"
/ {
};
/{
  chosen {
          bootargs = "console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rw rootwait uio_pdrv_genirq.of_id=\"generic-uio\"";
  };
};
&gem0 {
            phy-handle = <&phy0>;
            ps7_ethernet_0_mdio: mdio {
                 phy0: phy@3 {
                    device_type = "ethernet-phy";
                    reg = <3>;
                 };
            };
};
&flash0 {
   compatible = "s25fl512s";
   spi-tx-bus-width = <0x1>;
   spi-rx-bus-width = <0x4>;
};
&i2c0 {
	status = "okay";
        // RTC on the enclustra board
	pcf85063: pcf85063@51 {
		status = "okay";
		compatible = "nxp,pcf85063";
		reg = <0x51>;
	};
        // eeprom on YUGE
        at24@84 {
                status = "okay";
                compatible = "atmel,at24c01";
                reg = <0x54>;
        };
};
&i2c1 {
       status = "okay";
       // various i2c power supplies, use generic drivers
       // these are the ones directly connected to the Zynq
       // select via AXI registers
       // will need to update for devices off FPGA
       // PMBUS ADDRESS: 0x20, NOT STUFFED
       // REFDES: U6
       // hwmon@32 {
       //         status = "okay";
       //         compatible = "pmbus";
       //         reg = <32>;
       //};
       // PMBUS ADDRESS: 0x21,
       // REFDES: U8
       hwmon@33 {
                status = "okay";
                compatible = "pmbus";
                reg = <33>;
       };
       // PMBUS ADDRESS: 0x23
       // REFDES: U1
       hwmon@35 {
                status = "okay";
                compatible = "pmbus";
                reg = <35>;
       };
       // PMBUS ADDRESS: 0x24
       // REFDES: U2
       hwmon@36 {
                status = "okay";
                compatible = "pmbus";
                reg = <36>;
       };
};
EOF
#Note that for the gem0, the actual compatible line is commented out.

petalinux-config -c kernel
#this is to enable Micrel PHY support (not as a module, built into kernel)
#Navigate to kernel configuration -> Device Drivers -> Network device support ->PHY Device and Infrastructure -> Micrel PHY
#exit the config
#This generates a file under project-spec and some directories there, not sure if you can just do it w/o the kernel config

echo "if the command below fails you did not update the kernel for the MICREL phy."

ls project-spec/meta-user/recipes-kernel/linux/linux-xlnx/
#user_2017-10-20-10-47-00.cfg
# values currently set in the custom kernel beyond the defaults
# CONFIG_MICREL_PHY=y -- for Ethernet PHY on the ZX2
# CONFIG_SPI_SPIDEV=y -- probably not needed?
# CONFIG_RTC_DRV_PCF85063=y -- RTC on ZX2
# CONFIG_UIO_PDRV_GENIRQ=y -- for xvcServer
# CONFIG_UIO_DMEM_GENIRQ=y -- probably not needed

#Need to add this to config to get ethernet to work
cat >> project-spec/meta-user/recipes-kernel/linux/linux-xlnx/user_*.cfg <<EOF
CONFIG_KSZ9031=y
EOF

cat >> project-spec/meta-user/conf/petalinuxbsp.conf <<EOF
#define CONFIG_EXTRA_ENV_SETTINGS \
	SERIAL_MULTI \
	CONSOLE_ARG \
	PSSERIAL0 \
	"nc=setenv stdout nc;setenv stdin nc;\0" \
	"ethaddr=00:0a:35:00:1e:52\0" \
	"importbootenv=echo \"Importing environment from SD ...\"; " \
		"env import -t ${loadbootenv_addr} $filesize\0" \
	"loadbootenv=load mmc $sdbootdev:$partid ${loadbootenv_addr} ${bootenv}\0" \
	"sd_uEnvtxt_existence_test=test -e mmc $sdbootdev:$partid /uEnv.txt\0" \
	"uenvboot=" \
	"if run sd_uEnvtxt_existence_test; then" \
		"run loadbootenv" \
		"echo Loaded environment from ${bootenv};" \
		"run importbootenv; \0" \
	"sdboot=echo boot Petalinux; run uenvboot ; mmcinfo && fatload mmc 0 ${netstart} ${kernel_img} && bootm \0" \
	"autoload=no\0" \
	"clobstart=0x10000000\0" \
	"netstart=0x10000000\0" \
	"dtbnetstart=0x11800000\0" \
	"loadaddr=0x10000000\0" \
	"boot_img=BOOT.BIN\0" \
	"load_boot=tftpboot ${clobstart} ${boot_img}\0" \
	"update_boot=setenv img boot; setenv psize ${bootsize}; setenv installcmd \"install_boot\"; run load_boot ${installcmd}; setenv img; setenv psize; setenv installcmd\0" \
	"install_boot=mmcinfo && fatwrite mmc 0 ${clobstart} ${boot_img} ${filesize}\0" \
	"bootenvsize=0x20000\0" \
	"bootenvstart=0x500000\0" \
	"eraseenv=sf probe 0 && sf erase ${bootenvstart} ${bootenvsize}\0" \
	"jffs2_img=rootfs.jffs2\0" \
	"load_jffs2=tftpboot ${clobstart} ${jffs2_img}\0" \
	"update_jffs2=setenv img jffs2; setenv psize ${jffs2size}; setenv installcmd \"install_jffs2\"; run load_jffs2 test_img; setenv img; setenv psize; setenv installcmd\0" \
	"sd_update_jffs2=echo Updating jffs2 from SD; mmcinfo && fatload mmc 0:1 ${clobstart} ${jffs2_img} && run install_jffs2\0" \
	"install_jffs2=sf probe 0 && sf erase ${jffs2start} ${jffs2size} && " \
		"sf write ${clobstart} ${jffs2start} ${filesize}\0" \
	"kernel_img=image.ub\0" \
	"load_kernel=tftpboot ${clobstart} ${kernel_img}\0" \
	"update_kernel=setenv img kernel; setenv psize ${kernelsize}; setenv installcmd \"install_kernel\"; run load_kernel ${installcmd}; setenv img; setenv psize; setenv installcmd\0" \
	"install_kernel=mmcinfo && fatwrite mmc 0 ${clobstart} ${kernel_img} ${filesize}\0" \
	"cp_kernel2ram=mmcinfo && fatload mmc 0 ${netstart} ${kernel_img}\0" \
	"dtb_img=system.dtb\0" \
	"load_dtb=tftpboot ${clobstart} ${dtb_img}\0" \
	"update_dtb=setenv img dtb; setenv psize ${dtbsize}; setenv installcmd \"install_dtb\"; run load_dtb test_img; setenv img; setenv psize; setenv installcmd\0" \
	"sd_update_dtb=echo Updating dtb from SD; mmcinfo && fatload mmc 0:1 ${clobstart} ${dtb_img} && run install_dtb\0" \
	"fault=echo ${img} image size is greater than allocated place - partition ${img} is NOT UPDATED\0" \
	"test_crc=if imi ${clobstart}; then run test_img; else echo ${img} Bad CRC - ${img} is NOT UPDATED; fi\0" \
	"test_img=setenv var \"if test ${filesize} -gt ${psize}\\; then run fault\\; else run ${installcmd}\\; fi\"; run var; setenv var\0" \
	"netboot=tftpboot ${netstart} ${kernel_img} && bootm\0" \
	"default_bootcmd=run cp_kernel2ram && bootm ${netstart}\0" \
""
EOF

petalinux-build

petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga images/linux/system_top.bit --u-boot  --kernel --force

#Note that this latter step will put all the relevant files in images/linux

#% cp BOOT.bin images/linux/image.ub <sd card boot partition>

# success! The PHY appears both to the u-boot and to the kernel

# For a new SD card it must be formatted with two partitions

# 1. the first partition must be FAT and at least 64 MB, and bootable
# 2. the second partition can be ext4 and take up the rest of the card.

# by default petalinux will boot into a RAMFS.

# the default project sets the root file system to an INITRAMFS
