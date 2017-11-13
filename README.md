# plnx
PetaLinux code for various Zynqs. The first iteration is for the Enclustra ZX2-based board for the YUGE.

these are based on Petalinux 2017.2 and Vivado 2017.2.

Commands to finish the build after reconfiguration. These are specific to the YUGE project.

    % petalinux-build
    % petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga images/linux/system_top_6089_101_revA.bit --u-boot  --kernel --force

