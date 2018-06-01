This is for a test build of the Enclustra XU3 -- Mars EB1 design

I use the reference design from Enclustra for the HDF.

Then generate a project as in `project.sh`

I need to update the u-boot configuration, as discussed in 
https://www.xilinx.com/support/answers/69780.html
However this fix doesn't quite work; you also need to pull out the mmcinfo command. This makes something that boots, though it still has a problem in that the boot takes a long time, I suspect due to an earlier call to mmcinfo.