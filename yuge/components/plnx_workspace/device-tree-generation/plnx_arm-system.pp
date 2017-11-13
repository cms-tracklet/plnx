# 1 "/mnt/scratch/wittich/tracklet/plnx/yuge/build/../components/plnx_workspace/device-tree-generation/system-top.dts"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/mnt/scratch/wittich/tracklet/plnx/yuge/build/../components/plnx_workspace/device-tree-generation/system-top.dts"







/dts-v1/;
/include/ "zynq-7000.dtsi"
/include/ "pl.dtsi"
/include/ "pcw.dtsi"
/ {
 chosen {
  bootargs = "earlycon";
  stdout-path = "serial0:115200n8";
 };
 aliases {
  ethernet0 = &gem0;
  serial0 = &uart0;
  spi0 = &qspi;
 };
 memory {
  device_type = "memory";
  reg = <0x0 0x20000000>;
 };
 cpus {
 };
};
# 1 "/mnt/scratch/wittich/tracklet/plnx/yuge/build/tmp/work/plnx_arm-xilinx-linux-gnueabi/device-tree-generation/xilinx+gitAUTOINC+43551819a1-r0/system-user.dtsi" 1
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

 pcf85063: pcf85063@51 {
  status = "okay";
  compatible = "nxp,pcf85063";
  reg = <0x51>;
 };

        at24@84 {
                status = "okay";
                compatible = "atmel,at24c01";
                reg = <0x54>;
        };
};
&i2c1 {
       status = "okay";




       hwmon@32 {
                status = "okay";
                compatible = "pmbus";
                reg = <32>;
       };
       hwmon@33 {
                status = "okay";
                compatible = "pmbus";
                reg = <33>;
       };
       hwmon@35 {
                status = "okay";
                compatible = "pmbus";
                reg = <35>;
       };
       hwmon@36 {
                status = "okay";
                compatible = "pmbus";
                reg = <36>;
       };
};

&axi_jtag {
    compatible = "generic-uio";
};
# 29 "/mnt/scratch/wittich/tracklet/plnx/yuge/build/../components/plnx_workspace/device-tree-generation/system-top.dts" 2
