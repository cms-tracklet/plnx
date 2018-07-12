# plnx
PetaLinux code for various Zynqs. The first iteration is for the Enclustra ZX2-based board for the YUGE.

these are based on Petalinux 2017.2 and Vivado 2017.2.

Commands to finish the build after reconfiguration. These are specific to the YUGE project.

    % petalinux-build
    % petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga images/linux/system_top_6089_101_revA.bit --u-boot  --kernel --force

The directory XU3_EB1 describes the workflow for the XU3 Enclustra board on top of the EB1 base board. The hardware comes from the Enclustra Reference design.
