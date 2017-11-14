# Customization 

This is the Enclustra ZX2 on the YUGE.

The customization to the device tree can be found in 

project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi

On the YUGE there are
1. various i2c devices connected to the Zynq. 
1. Several i2c devices connected to the main FPGA. These are accessed from the Zynq via a multiplexor in the PL part of the ZYNQ. The 2nd i2c bus is routed to the PL via the EMIO pins.
