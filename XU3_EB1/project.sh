#! /bin/sh


NAME=xupl
petalinux-create -t project --template zynqMP --name $NAME
cd $NAME
petalinux-config --get-hw-description ../hardware

## see commends in the readme file
